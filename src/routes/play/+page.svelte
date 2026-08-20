<script lang="ts">
  import { toast } from "$lib/components/toast/toast.svelte";
  import { supabase } from "$lib/supabaseClient";
  import { Lock, ChevronRight, ScrollText, X, MapPinned } from "@lucide/svelte";
  import { onMount, onDestroy, tick } from "svelte";
  import * as ml from "maplibre-gl";
  import "maplibre-gl/dist/maplibre-gl.css";
  import workerUrl from "maplibre-gl/dist/maplibre-gl-worker.mjs?worker&url";
  import "./map.css";
  import calculateResults from "$lib/functions/calculateResults";
  import type { Photo, GameState } from "../../consts";
  import {
    IMAGE_COUNT,
    MAP_STYLE_URL,
    CAMPUS_BOUNDS,
    CAMPUS_CENTER,
  } from "../../consts";
  import { loadAvatar } from "$lib/functions/loadAvatar";
  import { destroyMap } from "$lib/functions/destroyMap";
  import { formatDist } from "$lib/functions/formatDistance";
  import {
    setAnswerMarker,
    setGuessMarker,
    setMapLines,
  } from "$lib/functions/mapUtils";

  ml.setWorkerUrl(workerUrl);

  let game: GameState = $state({
    id: crypto.randomUUID(),
    rounds: [],
    currIndex: 0,
    totalScore: 0,
  });

  let imageLoading: boolean = $state(true);
  let lockedIn: boolean = $state(false);
  let showModal: boolean = $state(false);
  let photos: Photo[] = $state([]);
  let currentPhotoIndex: number = $state(0);

  let avatarUrl = $state<string | null>(null);

  let scale = $state(1);
  let x = $state(0);
  let y = $state(0);
  let dragging = $state(false);
  let last = { x: 0, y: 0 };
  let frame: HTMLDivElement | undefined = $state();

  let mapGuessContainer: HTMLDivElement;
  let mapScoreContainer: HTMLDivElement;
  let map: ml.Map | undefined;
  let guessMarker: ml.Marker | undefined;
  let answerMarker: ml.Marker | undefined;
  let guess: ml.LngLat = $state<ml.LngLat>(new ml.LngLat(0, 0));

  let dist: number | undefined = $state();
  let score: number = $state(0);

  const loadPhotos = async () => {
    const {
      data: { user },
    } = await supabase.auth.getUser();

    const { data, error } = await supabase.rpc("get_random_photos", {
      photo_count: IMAGE_COUNT,
      exclude_user_id: user?.id ?? null,
    });

    if (error) {
      toast(error.message, "error");
      return;
    } else if (data.length === 0) {
      toast("No photos :(", "error");
      return;
    }

    for (let i = 0; i < IMAGE_COUNT; i++) {
      const photo = data[i];

      const { data: pubData } = supabase.storage
        .from("photos")
        .getPublicUrl(photo.storage_path);

      photos[i] = { ...photo, publicUrl: pubData.publicUrl };

      game.rounds[i] = {
        id: crypto.randomUUID(),
        photo,
        guess: null,
        score: 0,
        dist: undefined,
      };
    }

    imageLoading = false;
  };

  const handleNextPhoto = async () => {
    currentPhotoIndex++;
    game.currIndex = currentPhotoIndex;
    guess = new ml.LngLat(0, 0);
    showModal = false;
    lockedIn = false;

    await tick();

    requestAnimationFrame(() => {
      destroyMap(map);
      createGuessMap();
      map?.resize();
    });
  };

  function onWheel(e: WheelEvent) {
    e.preventDefault();
    if (!frame) return;

    const rect = frame.getBoundingClientRect();
    const mx = e.clientX - rect.left;
    const my = e.clientY - rect.top;

    const prev = scale;
    const next = Math.min(
      4,
      Math.max(1, scale * (e.deltaY < 0 ? 1.12 : 1 / 1.12)),
    );

    // zoom toward cursor
    x = mx - (mx - x) * (next / prev);
    y = my - (my - y) * (next / prev);
    scale = next;

    if (scale === 1) {
      x = 0;
      y = 0;
    }
  }

  function onPointerDown(e: PointerEvent) {
    if (scale <= 1) return;
    dragging = true;
    last = { x: e.clientX, y: e.clientY };
    (e.currentTarget as HTMLElement).setPointerCapture(e.pointerId);
  }

  function onPointerMove(e: PointerEvent) {
    if (!dragging) return;
    x += e.clientX - last.x;
    y += e.clientY - last.y;
    last = { x: e.clientX, y: e.clientY };
  }

  function onPointerUp() {
    dragging = false;
  }

  const handleLockIn = async () => {
    lockedIn = true;
    showModal = true;
    destroyMap(map);

    const answer = new ml.LngLat(0, 0);
    if (photos[currentPhotoIndex].lng && photos[currentPhotoIndex].lat) {
      answer.lng = photos[currentPhotoIndex].lng || 0;
      answer.lat = photos[currentPhotoIndex].lat || 0;
    }

    const results = calculateResults(guess, answer);
    dist = Math.round(results.dist);
    score = results.score;

    map = new ml.Map({
      container: mapScoreContainer,
      style: MAP_STYLE_URL,
      center: guess,
      zoom: 15,
      minZoom: 12,
      maxZoom: 20,
      maxBounds: CAMPUS_BOUNDS,
      attributionControl: false,
    }).addControl(
      new ml.AttributionControl({
        compact: true,
      }),
    );

    map.on("load", () => {
      answerMarker = setAnswerMarker(answer, map, answerMarker);
      guessMarker = setGuessMarker(guess, map, avatarUrl, guessMarker);
      setMapLines(guess, answer, map);

      const bounds = new ml.LngLatBounds(guess, guess);
      bounds.extend(answer);

      map!.fitBounds(bounds, {
        padding: { top: 48, bottom: 48, left: 48, right: 48 },
        maxZoom: 17,
        duration: 1000,
      });

      // Update game state
      game.rounds[currentPhotoIndex].dist = dist;
      game.rounds[currentPhotoIndex].guess = guess;
      game.rounds[currentPhotoIndex].score = score;
      game.totalScore += score;

      // Store game data in localStorage
      localStorage.setItem("game", JSON.stringify(game));
    });

    await handleRoundUpload();
  };

  const handleRoundUpload = async () => {
    if (localStorage.getItem("loggedIn") !== "true") return;

    const { error } = await supabase.from("game_rounds").upsert({
      id: game.rounds[currentPhotoIndex].id,
      game_id: game.id,
      round_index: currentPhotoIndex,
      photo_id: game.rounds[currentPhotoIndex].photo.id,
      guess_lat: guess.lat,
      guess_lng: guess.lng,
      score: score,
      dist: dist,
      created_at: new Date().toISOString(),
    });

    if (error) toast(error.message, "error");
  };

  const createGuessMap = () => {
    map = new ml.Map({
      container: mapGuessContainer,
      style: MAP_STYLE_URL,
      center: CAMPUS_CENTER,
      zoom: 15,
      minZoom: 12,
      maxZoom: 20,
      maxBounds: CAMPUS_BOUNDS,
      attributionControl: false,
    }).addControl(
      new ml.AttributionControl({
        compact: true,
      }),
    );

    map?.on("click", (e) => {
      guess = e.lngLat;
      guessMarker = setGuessMarker(guess, map, avatarUrl, guessMarker, true);
    });
  };

  onMount(async () => {
    loadPhotos();
    avatarUrl = await loadAvatar();
    createGuessMap();
    uploadEmptyGame();
  });

  const uploadEmptyGame = async () => {
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      return;
    }

    const { error } = await supabase.from("games").upsert({
      id: game.id,
      user_id: user.id,
    });
    if (error) toast(error.message, "error");
  };

  const onKeyDown = (event: KeyboardEvent) => {
    if (event.key === " " && guess.lat !== 0 && !lockedIn) {
      handleLockIn();
    }
  };

  onDestroy(() => {
    map?.remove();
  });
</script>

<svelte:head>
  <title>TechGuessr - Play</title>
</svelte:head>

<svelte:window onkeydown={onKeyDown} />

<div
  class="relative flex-1 min-h-0 overflow-hidden touch-none"
  bind:this={frame}
>
  {#if imageLoading}
    <p class="h-full text-center place-content-center">
      <span class="loading loading-spinner loading-xl"></span>
      <span class="block text-lg mt-4">Next location loading...</span>
    </p>
  {:else}
    <div
      class="absolute inset-0 origin-top-left will-change-transform {scale !==
        1 && 'cursor-grab'} {dragging && 'cursor-grabbing'}"
      style="transform: translate({x}px, {y}px) scale({scale})"
      onpointerdown={onPointerDown}
      onpointermove={onPointerMove}
      onpointerup={onPointerUp}
      onpointercancel={onPointerUp}
      role="presentation"
      onwheel={onWheel}
    >
      <img
        src={photos[currentPhotoIndex].publicUrl}
        alt="Check internet connection 👌"
        class="w-full h-full object-contain select-none pointer-events-none"
      />
    </div>
  {/if}

  <div
    class="absolute w-full h-full flex flex-col gap-2 place-content-between pointer-events-none"
  >
    {#if !lockedIn || !showModal}
      <div class="badge badge-lg badge-neutral m-2 font-bold">
        Round {currentPhotoIndex + 1}/5
      </div>
    {/if}

    {#if !lockedIn}
      <div class="w-full flex place-content-between place-items-end p-2">
        <div></div>
        <div
          class="flex flex-col gap-2 w-[25vw] min-h-[35vh] pointer-events-auto"
        >
          <div
            id="map-guess-container"
            bind:this={mapGuessContainer}
            class="top-0 left-0 w-[25vw] h-[30vh] rounded-box flex"
          ></div>
          <button
            type="button"
            class="btn btn-success w-full z-20 shadow-lg {guess.lng === 0 &&
              'btn-disabled bg-success/50'}"
            onclick={() => handleLockIn()}
          >
            <Lock size={16} />
            <span class="font-black">LOCK IT IN</span>
          </button>
        </div>
      </div>
    {/if}

    {#if lockedIn && !showModal}
      <div
        class="w-full h-full flex place-items-end place-content-end p-2 pointer-events-auto"
      >
        <div class="flex gap-2">
          <button class="btn" onclick={() => (showModal = true)}>
            <span>Show score</span>
            <MapPinned />
          </button>
          <button class="btn btn-primary" onclick={handleNextPhoto}>
            <span>Next round</span>
            <ChevronRight />
          </button>
        </div>
      </div>
    {/if}
  </div>
</div>

<!-- Modal -->
<dialog class="modal {showModal && 'modal-open'}" id="score-modal">
  <div class="modal-box flex flex-col gap-2 p-4">
    <div class="flex place-content-between place-items-center mb-2">
      <h2 class="text-xl font-bold">Round {currentPhotoIndex + 1}</h2>
      <button
        class="btn btn-circle tooltip tooltip-left"
        onclick={() => (showModal = false)}
        data-tip="Hide score"
      >
        <X />
      </button>
    </div>

    <div class="rounded-box h-64 w-full" bind:this={mapScoreContainer}></div>
    <div class="text-center mb-4">
      <p class="text-7xl font-black my-4">{score}</p>
      <p>
        Your guess was {formatDist(dist)} away!
      </p>
    </div>

    {#if currentPhotoIndex != 4}
      <div class="flex place-content-end">
        <button class="btn btn-primary" onclick={handleNextPhoto}>
          <span>Next round</span>
          <ChevronRight />
        </button>
      </div>
    {:else}
      <div class="flex place-content-center">
        <a href="/play/results" class="btn btn-primary btn-wide">
          <ScrollText />
          <span>Results</span>
        </a>
      </div>
    {/if}
  </div>
</dialog>

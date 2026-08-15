<script lang="ts">
  import { toast } from "$lib/components/toast/toast.svelte";
  import { supabase } from "$lib/supabaseClient";
  import { Lock, ChevronRight, ScrollText } from "@lucide/svelte";
  import { onMount, onDestroy, tick } from "svelte";
  import * as ml from "maplibre-gl";
  import "maplibre-gl/dist/maplibre-gl.css";
  import "./map.css";
  import calculateResults from "$lib/functions/calculateResults";
  import Results from "./Results.svelte";
  import type { Photo, RoundState, GameState } from "../../consts";

  const IMAGE_COUNT = 5;

  let game: GameState = $state({ rounds: [], currIndex: 0, totalScore: 0 });

  let imageLoading: boolean = $state(true);
  let lockedIn: boolean = $state(false);
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

  let showResults: boolean = $state(false);

  const MAP_STYLE_URL: string = "https://tiles.openfreemap.org/styles/bright";

  const CAMPUS_CENTER: ml.LngLat = new ml.LngLat(-84.398815, 33.776099);
  const CAMPUS_NE_BOUND: ml.LngLat = new ml.LngLat(
    -84.3831385540561,
    33.79079208919991,
  );
  const CAMPUS_SW_BOUND: ml.LngLat = new ml.LngLat(
    -84.41193287304678,
    33.761922412793176,
  );
  const CAMPUS_BOUNDS: ml.LngLatBounds = new ml.LngLatBounds(
    CAMPUS_SW_BOUND,
    CAMPUS_NE_BOUND,
  );

  const loadPhotos = async () => {
    const { data, error } = await supabase
      .from("photos")
      .select("id, storage_path, lat, lng, status")
      .eq("status", "approved");

    if (error) {
      toast(error.message, "error");
      return;
    } else if (data.length === 0) {
      toast("No photos :(", "error");
      return;
    }

    for (let i = 0; i < IMAGE_COUNT; i++) {
      const photo = data[Math.floor(Math.random() * data.length)];

      const { data: pubData } = supabase.storage
        .from("photos")
        .getPublicUrl(photo.storage_path);

      photos[i] = { ...photo, publicUrl: pubData.publicUrl };

      game.rounds[i] = {
        photo,
        guess: null,
        score: 0,
        dist: undefined,
      };
    }

    console.log(game);
    imageLoading = false;
  };

  const handleNextPhoto = async () => {
    currentPhotoIndex++;
    game.currIndex = currentPhotoIndex;
    guess = new ml.LngLat(0, 0);
    lockedIn = false;

    await tick();

    requestAnimationFrame(() => {
      initGuessMap();
      map?.resize();
    });
  };

  const destroyMap = () => {
    map?.remove();
    map = undefined;
    guessMarker = undefined;
  };

  const initGuessMap = () => {
    destroyMap();

    map = new ml.Map({
      container: mapGuessContainer,
      style: MAP_STYLE_URL,
      center: CAMPUS_CENTER,
      zoom: 15,
      minZoom: 14,
      maxZoom: 18,
      maxBounds: CAMPUS_BOUNDS,
    });

    map?.on("click", (e) => {
      guess = e.lngLat;
      setGuessMarker(guess);
    });
  };

  const loadAvatar = async () => {
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      avatarUrl = null;
      return;
    }

    const { data: profile } = await supabase
      .from("profiles")
      .select("avatar_url")
      .eq("id", user.id)
      .single();

    const { data, error } = await supabase.storage
      .from("avatars")
      .download(profile?.avatar_url);

    if (error) {
      console.error(error.message);
    } else {
      const url = URL.createObjectURL(data);
      avatarUrl = url;
    }
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
    destroyMap();

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
      minZoom: 14,
      maxZoom: 18,
      maxBounds: CAMPUS_BOUNDS,
    });

    map.on("load", () => {
      answerMarker = new ml.Marker({ color: "#f43098" })
        .setLngLat(answer)
        .addTo(map!);

      setGuessMarker(guess);

      map!.addSource("guess-line", {
        type: "geojson",
        data: {
          type: "Feature",
          properties: {},
          geometry: {
            type: "LineString",
            coordinates: [
              [guess.lng, guess.lat],
              [answer.lng, answer.lat],
            ],
          },
        },
      });

      map!.addLayer({
        id: "guess-line-layer",
        type: "line",
        source: "guess-line",
        layout: {
          "line-cap": "round",
          "line-join": "round",
        },
        paint: {
          "line-color": "#f43098",
          "line-width": 3,
          "line-opacity": 0.9,
        },
      });

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
    });

    console.log("Distance away: " + dist);
    console.log("Score: " + score);
  };

  const setGuessMarker = (lngLat: ml.LngLat) => {
    if (!map) return;

    guessMarker?.remove();
    const el = document.createElement("div");
    el.classList.add(
      "w-8",
      "h-8",
      "rounded-full",
      "border-primary",
      "border-3",
      "flex",
      "place-content-center",
      "place-items-center",
    );

    if (avatarUrl) {
      const img = document.createElement("img");
      img.src = avatarUrl;
      img.alt = "Your guess";
      img.draggable = false;
      img.classList.add("w-7", "h-7", "rounded-full");
      el.appendChild(img);
    } else {
      el.classList.add("bg-primary/75");
    }

    guessMarker = new ml.Marker({
      element: el,
      anchor: "center",
    })
      .setLngLat(lngLat)
      .addTo(map!);
  };

  onMount(() => {
    loadPhotos();
    loadAvatar();

    map = new ml.Map({
      container: mapGuessContainer,
      style: MAP_STYLE_URL,
      center: CAMPUS_CENTER,
      zoom: 15,
      minZoom: 14,
      maxZoom: 18,
      maxBounds: CAMPUS_BOUNDS,
    });

    map?.on("click", (e) => {
      guess = e.lngLat;
      setGuessMarker(guess);
    });
  });

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

{#if showResults}
  <Results open={true} rounds={game.rounds} totalScore={game.totalScore} />
{:else}
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

    {#if !lockedIn}
      <div
        class="absolute w-full h-full flex flex-col gap-2 place-content-between pointer-events-none"
      >
        <div class="flex pl-2">
          <ul class="steps steps-vertical">
            {#each { length: IMAGE_COUNT }, i}
              <li class="step {currentPhotoIndex > i && 'step-success'}"></li>
            {/each}
          </ul>
        </div>

        <div class="w-full flex place-content-end p-2">
          <div
            class="flex flex-col gap-2 w-[25vw] h-[30vh] hover:w-[35vw] hover:h-[45vh] pointer-events-auto"
          >
            <div
              id="map-guess-container"
              bind:this={mapGuessContainer}
              class="flex-1 w-full rounded-box hover:rounded-box"
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
      </div>
    {/if}
  </div>

  <!-- Modal -->
  <dialog class="modal {lockedIn && 'modal-open'}" id="score-modal">
    <div class="modal-box flex flex-col gap-2">
      <div class="rounded-box h-64 w-full" bind:this={mapScoreContainer}></div>
      <div class="text-center">
        <p class="text-7xl font-black my-4">{score}</p>
        <p>Your guess was {dist}m away!</p>
      </div>
      {#if currentPhotoIndex != 4}
        <div class="flex place-content-end">
          <button class="btn btn-primary" onclick={handleNextPhoto}>
            <span>Next</span>
            <ChevronRight />
          </button>
        </div>
      {:else}
        <div class="flex place-content-center">
          <button
            class="btn btn-primary btn-wide"
            onclick={() => {
              showResults = true;
            }}
          >
            <ScrollText />
            <span>Results</span>
          </button>
        </div>
      {/if}
    </div>
  </dialog>
{/if}

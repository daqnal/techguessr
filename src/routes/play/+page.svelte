<script lang="ts">
  import { toast } from "$lib/components/toast/toast.svelte";
  import { supabase } from "$lib/supabaseClient";
  import { X, Map, Lock, LocateFixed } from "@lucide/svelte";
  import { onMount, onDestroy } from "svelte";
  // import { LngLat, LngLatBounds, Map as MapLibre, Marker } from "maplibre-gl";
  import * as ml from "maplibre-gl";
  import "maplibre-gl/dist/maplibre-gl.css";
  import "./map.css";
  import calculateResults from "$lib/functions/calculateResults";

  type Photo = {
    id: string;
    storage_path: string;
    lat: number | null;
    lng: number | null;
    status: "pending" | "approved" | "rejected";
    publicUrl?: string | null;
  };

  const imageCount = 5;

  let imageLoading: boolean = $state(true);
  let lockedIn: boolean = $state(false);
  let photos: Photo[] = $state([]);
  let currentPhotoIndex: number = $state(0);

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
  let score: number | undefined = $state();

  const MIN = 1;
  const MAX = 4;

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

    console.log(data);

    if (error) {
      toast(error.message, "error");
      return;
    } else if (data.length === 0) {
      toast("No photos :(", "error");
      return;
    }

    for (let i = 0; i < imageCount; i++) {
      const photo = data[Math.floor(Math.random() * data.length)];

      const { data: pubData } = supabase.storage
        .from("photos")
        .getPublicUrl(photo.storage_path);

      photos[i] = { ...photo, publicUrl: pubData.publicUrl };
    }

    imageLoading = false;
  };

  function onWheel(e: WheelEvent) {
    e.preventDefault();
    if (!frame) return;

    const rect = frame.getBoundingClientRect();
    const mx = e.clientX - rect.left;
    const my = e.clientY - rect.top;

    const prev = scale;
    const next = Math.min(
      MAX,
      Math.max(MIN, scale * (e.deltaY < 0 ? 1.12 : 1 / 1.12)),
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

  function resetView() {
    scale = 1;
    x = 0;
    y = 0;
  }

  const handleLockIn = async () => {
    lockedIn = true;
    map?.remove();

    map = new ml.Map({
      container: mapScoreContainer,
      style: "https://tiles.openfreemap.org/styles/bright",
      center: guess,
      scrollZoom: false,
      dragPan: false,
      zoom: 15,
      minZoom: 14,
      maxZoom: 18,
      maxBounds: CAMPUS_BOUNDS,
    });

    if (guessMarker) {
      guessMarker.addTo(map!);
    }

    const answerCoordinates = new ml.LngLat(0, 0);
    if (photos[currentPhotoIndex].lng && photos[currentPhotoIndex].lat) {
      answerCoordinates.lng = photos[currentPhotoIndex].lng;
      answerCoordinates.lat = photos[currentPhotoIndex].lat;
    }

    answerMarker = new ml.Marker({ color: "#f43098" })
      .setLngLat(answerCoordinates)
      .addTo(map!);

    const results = calculateResults(guess, answerCoordinates);
    dist = results.dist;
    score = results.score;

    console.log("Distance away: " + dist);
    console.log("Score: " + score);
  };

  onMount(() => {
    loadPhotos();

    map = new ml.Map({
      container: mapGuessContainer,
      style: "https://tiles.openfreemap.org/styles/bright",
      center: CAMPUS_CENTER,
      zoom: 15,
      minZoom: 14,
      maxZoom: 18,
      maxBounds: CAMPUS_BOUNDS,
    });

    map?.on("click", (e) => {
      guess = e.lngLat;

      if (!guessMarker) {
        guessMarker = new ml.Marker({ color: "#6366f1" })
          .setLngLat(guess)
          .addTo(map!);
      } else {
        guessMarker.setLngLat(guess);
      }
    });
  });

  onDestroy(() => {
    map?.remove();
  });
</script>

<div
  class="relative flex-1 min-h-0 overflow-hidden touch-none"
  bind:this={frame}
  onwheel={onWheel}
>
  {#if imageLoading}
    <p class="h-full text-center place-content-center">
      <span class="loading loading-spinner loading-xl"></span>
      <span class="block text-lg mt-4">Next location loading...</span>
    </p>
  {:else}
    <div
      class="absolute inset-0 origin-top-left bg-base-200 will-change-transform {scale !==
        1 && 'cursor-grab'} {dragging && 'cursor-grabbing'}"
      style="transform: translate({x}px, {y}px) scale({scale})"
      onpointerdown={onPointerDown}
      onpointermove={onPointerMove}
      onpointerup={onPointerUp}
      onpointercancel={onPointerUp}
      role="presentation"
    >
      <img
        src={photos[0].publicUrl}
        alt="Check internet connection 👌"
        class="w-full h-full object-contain select-none pointer-events-none"
      />
    </div>
  {/if}

  {#if !lockedIn}
    <div
      class="absolute w-full bottom-0 left-0 flex p-2 gap-2 place-content-between"
    >
      <button
        type="button"
        class="btn btn-primary btn-wide z-20 shadow-lg {guess.lng === 0 &&
          'btn-disabled bg-base-200/75'}"
        onclick={() => handleLockIn()}
      >
        <Lock size={16} />
        <span class="font-black">LOCK IT IN</span>
      </button>

      <div class="flex gap-2 z-20">
        {#if scale !== 1 || x !== 0 || y !== 0}
          <button
            class="btn btn-circle btn-primary shadow-lg"
            onclick={resetView}
          >
            <LocateFixed />
          </button>
        {/if}
      </div>
    </div>
  {/if}

  <div
    class="absolute bottom-0 right-0 w-[30vw] h-[30vh] bg-base-200 rounded-tl-box"
  >
    <div bind:this={mapGuessContainer} class="w-full h-full"></div>
  </div>
</div>

<!-- Modal -->
<dialog class="modal {lockedIn && 'modal-open'}" id="score-modal">
  <div class="modal-box flex flex-col gap-2">
    <div class="rounded-box h-64 w-full" bind:this={mapScoreContainer}></div>
    <p class="text-7xl text-center font-black">{score}</p>
    <div></div>
  </div>
</dialog>

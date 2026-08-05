<script lang="ts">
  import { toast } from "$lib/components/ui/toast/toast.svelte";
  import { supabase } from "$lib/supabaseClient";
  import { X, Map, Lock, LocateFixed } from "@lucide/svelte";
  import { onMount, onDestroy } from "svelte";
  import { LngLat, LngLatBounds, Map as MapLibre, Marker } from "maplibre-gl";
  import "maplibre-gl/dist/maplibre-gl.css";

  type Photo = {
    id: string;
    storage_path: string;
    lat: number | null;
    long: number | null;
    status: "pending" | "approved" | "rejected";
    publicUrl?: string | null;
  };

  const imageCount = 5;

  let imageLoading: boolean = $state(true);
  let mapOpen: boolean = $state(false);
  let lockedIn: boolean = $state(false);
  let photos: Photo[] = $state([]);
  let currentPhotoIndex: number = $state(0);

  let scale = $state(1);
  let x = $state(0);
  let y = $state(0);
  let dragging = $state(false);
  let last = { x: 0, y: 0 };
  let frame: HTMLDivElement | undefined = $state();

  let mapContainer: HTMLDivElement;
  let map: MapLibre | undefined;
  let marker: Marker | undefined;
  let guess = $state<LngLat | null>(null);

  const MIN = 1;
  const MAX = 4;

  const CAMPUS_CENTER: LngLat = new LngLat(
    -84.39794899041351,
    33.7779439355854,
  );
  const CAMPUS_NE_BOUND: LngLat = new LngLat(
    -84.3831385540561,
    33.79079208919991,
  );
  const CAMPUS_SW_BOUND: LngLat = new LngLat(
    -84.41193287304678,
    33.761922412793176,
  );
  const CAMPUS_BOUNDS: LngLatBounds = new LngLatBounds(
    CAMPUS_SW_BOUND,
    CAMPUS_NE_BOUND,
  );

  const handleLockIn = async () => {
    lockedIn = true;
  };

  const loadPhotos = async () => {
    const { data, error } = await supabase
      .from("photos")
      .select("id, storage_path, lat, long, status")
      .eq("status", "approved");

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

  onMount(() => {
    loadPhotos();

    map = new MapLibre({
      container: mapContainer,
      style: "https://tiles.openfreemap.org/styles/bright",
      center: CAMPUS_CENTER,
      zoom: 15,
      minZoom: 14,
      maxZoom: 18,
      maxBounds: CAMPUS_BOUNDS,
    });

    map?.on("click", (e) => {
      guess = e.lngLat;

      if (!marker) {
        marker = new Marker({ color: "#6366f1" }).setLngLat(guess).addTo(map!);
      } else {
        marker.setLngLat(guess);
      }

      console.log(guess);
    });
  });

  onDestroy(() => {
    map?.remove();
  });
</script>

<div
  class="flex-1 relative overflow-hidden rounded-box bg-base-200 touch-none"
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
      class="flex-1 absolute inset-0 origin-top-left will-change-transform {scale !==
      1
        ? 'cursor-grab'
        : ''}"
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

  <div
    class="absolute w-full bottom-0 left-0 flex p-2 gap-2 place-content-between"
  >
    <button
      type="button"
      class="btn btn-primary btn-wide z-20 shadow-lg {lockedIn || !guess
        ? 'btn-disabled bg-base-200/75'
        : ''}"
      onclick={() => handleLockIn()}
    >
      {#if lockedIn}
        <span class="loading loading-spinner"></span>
      {:else}
        <Lock size={16} />
        <span class="font-black">LOCK IT IN</span>
      {/if}
    </button>

    <div class="flex gap-2 z-20">
      <button
        class="btn btn-circle btn-primary shadow-lg {scale === 1 &&
        x === 0 &&
        y === 0
          ? 'btn-disabled'
          : ''}"
        onclick={resetView}
      >
        <LocateFixed />
      </button>

      <button
        type="button"
        class="btn btn-circle btn-primary shadow-lg"
        onclick={() => {
          mapOpen = !mapOpen;
          requestAnimationFrame(() => map?.resize());
        }}
      >
        {#if mapOpen}
          <X />
        {:else}
          <Map />
        {/if}
      </button>
    </div>
  </div>
</div>
<div
  class="fixed bottom-4 right-4 z-10 h-[min(50vh,22rem)] w-[min(90vw,24rem)]
             overflow-hidden rounded-box bg-base-300 shadow-lg
             transition-transform duration-100 ease-out
             {mapOpen
    ? 'translate-x-0 translate-y-0'
    : 'translate-x-[calc(100%+1.5rem)] translate-y-[calc(100%+1.5rem)]'}"
  bind:this={mapContainer}
></div>

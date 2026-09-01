<script lang="ts">
  import { onMount, tick } from "svelte";
  import { supabase } from "$lib/supabaseClient";
  import { extractGps, uploadPhoto } from "$lib/functions/photoUpload";
  import { toast } from "$lib/components/toast/toast.svelte";
  import {
    RotateCcw,
    Save,
    Scale,
    Trash,
    Map as MapIcon,
    X,
  } from "@lucide/svelte";
  import {
    CAMPUS_BOUNDS,
    CAMPUS_CENTER,
    MAP_STYLE_URL,
    type Photo,
  } from "../../consts";
  import { AttributionControl, LngLat, Map, Marker } from "maplibre-gl";
  import "maplibre-gl/dist/maplibre-gl.css";
  import "./map.css";
  import { setAnswerMarker, zoomToAllPoints } from "$lib/functions/mapUtils";
  import { destroyMap } from "$lib/functions/destroyMap";
  import { innerWidth } from "svelte/reactivity/window";

  let center = new LngLat(CAMPUS_CENTER.lng, CAMPUS_CENTER.lat);

  let photos = $state<Photo[]>([]);
  let selected = $state<Photo | null>(null);
  let previewUrl = $state<string | null>(null);
  let pendingFile = $state<File | null>(null);
  let oldCoordinates = $state<LngLat | undefined>(undefined);
  let uploading = $state(false);
  let showRulesModal: boolean = $state(false);
  let showMobileMap: boolean = $state(false);

  let desktopMapContainer: HTMLDivElement;
  let mobileMapContainer: HTMLDivElement;
  let map: Map | undefined;
  let newMarker: Marker | undefined = $state();
  let oldMarker: Marker | undefined;

  async function loadPhotos() {
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) return;

    const { data, error } = await supabase
      .from("photos")
      .select("id, storage_path, lat, lng, status, comment, created_at")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false });

    if (error) {
      toast(error.message, "error");
      photos = [];
      return;
    }

    photos = (data ?? []).map((p) => {
      const { data: pub } = supabase.storage
        .from("photos")
        .getPublicUrl(p.storage_path);

      return {
        ...p,
        publicUrl: pub.publicUrl,
      };
    });

    // Show rules modal for first time uploaders
    if (photos.length === 0) {
      showRulesModal = true;
    }
  }

  async function onFile(e: Event) {
    const input = e.target as HTMLInputElement;
    const file = input.files?.[0];
    if (!file) return;

    pendingFile = file;
    previewUrl = URL.createObjectURL(file);

    const gpsData = await extractGps(file);
    const initialLat = gpsData?.lat ?? CAMPUS_CENTER.lat;
    const initialLng = gpsData?.lng ?? CAMPUS_CENTER.lng;

    // Create a temporary selected object for the new upload so the UI
    // (preview, map, inputs) always read from `selected`.
    selected = {
      id: null,
      storage_path: "",
      lat: initialLat,
      lng: initialLng,
      status: "pending",
      comment: null,
      created_at: new Date().toISOString(),
      publicUrl: previewUrl,
    } as unknown as Photo;
    oldCoordinates = undefined;
  }

  const submitUpload = async () => {
    if (!pendingFile) return;
    if (
      !selected ||
      !selected.lat ||
      !selected.lng ||
      selected.lat === 0 ||
      selected.lng === 0
    ) {
      toast("Add coordinates to submit", "error");
      return;
    }

    // Check if coordinates are in campus bounds
    if (
      selected.lng < CAMPUS_BOUNDS._sw.lng ||
      selected.lng > CAMPUS_BOUNDS._ne.lng ||
      selected.lat < CAMPUS_BOUNDS._sw.lat ||
      selected.lat > CAMPUS_BOUNDS._ne.lat
    ) {
      toast("Coordinates out of bounds", "error");
      return;
    }
    uploading = true;

    try {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) throw new Error("Not logged in");

      await uploadPhoto(
        supabase,
        user.id,
        pendingFile,
        new LngLat(selected.lng ?? 0, selected.lat ?? 0),
        selected.comment ?? null,
      );
      pendingFile = null;
      previewUrl = null;
      selected = null;
      await loadPhotos();
    } catch (e) {
      toast(e instanceof Error ? e.message : "Upload failed", "error");
    } finally {
      uploading = false;
    }
  };

  const updatePhoto = async () => {
    if (!selected) return;
    if (!selected.lat || isNaN(selected.lat)) {
      if (!selected.lng || isNaN(selected.lng)) {
        toast("Invalid latitude and longitude", "error");
        return;
      }
      toast("Invalid latitude", "error");
      return;
    } else if (!selected.lng || isNaN(selected.lng)) {
      toast("Invalid longitude", "error");
      return;
    }
    // Check if coordinates are in campus bounds
    if (
      selected.lng < CAMPUS_BOUNDS._sw.lng ||
      selected.lng > CAMPUS_BOUNDS._ne.lng ||
      selected.lat < CAMPUS_BOUNDS._sw.lat ||
      selected.lat > CAMPUS_BOUNDS._ne.lat
    ) {
      toast("Coordinates out of bounds", "error");
      return;
    }

    const { error: err } = await supabase
      .from("photos")
      .update({
        lat: selected.lat,
        lng: selected.lng,
        comment: selected.comment,
        updated_at: new Date().toISOString(),
      })
      .eq("id", selected.id);
    if (err) {
      toast(err.message, "error");
    } else {
      toast("Photo updated successfully", "success");
      map?.remove();
      oldCoordinates = new LngLat(selected.lng ?? 0, selected.lat ?? 0);
      createMap(desktopMapContainer);
      await loadPhotos();
    }
  };

  const deletePhoto = async () => {
    if (!selected) return;

    const { error: err } = await supabase
      .from("photos")
      .delete()
      .eq("id", selected.id);

    if (err) {
      toast(err.message, "error");
    } else {
      photos = photos.filter((el) => {
        return el.id != selected?.id;
      });
      selected = null;
      previewUrl = null;
      toast("Deleted image successfully", "success");
    }
  };

  const createMap = (mapContainer: HTMLDivElement) => {
    const coords: LngLat = new LngLat(
      selected?.lng ?? CAMPUS_CENTER.lng,
      selected?.lat ?? CAMPUS_CENTER.lat,
    );

    map = new Map({
      container: mapContainer,
      style: MAP_STYLE_URL,
      center: coords,
      zoom: 15,
      minZoom: 12,
      maxZoom: 20,
      maxBounds: CAMPUS_BOUNDS,
      attributionControl: false,
    }).addControl(
      new AttributionControl({
        compact: true,
      }),
    );

    map?.on("click", (e) => {
      // Update the selected coordinates (unsaved) when the user clicks the map
      if (!selected) return;
      selected.lng = e.lngLat.lng;
      selected.lat = e.lngLat.lat;

      newMarker = setAnswerMarker(
        e.lngLat,
        map,
        newMarker,
        true,
        "New",
        "text-error-content",
        "fill-error",
      );
    });

    if (selected) {
      oldCoordinates = new LngLat(selected.lng ?? 0, selected.lat ?? 0);
      oldMarker = setAnswerMarker(
        new LngLat(selected?.lng ?? 0, selected?.lat ?? 0),
        map,
        newMarker,
        false,
        "Original",
        "text-slate-800",
        "fill-slate-600",
      );
      zoomToAllPoints(map, [oldCoordinates]);
    } else {
      zoomToAllPoints(map, [coords]);
    }
  };

  const resetCoordinates = () => {
    newMarker?.remove();
    newMarker = undefined;

    if (oldCoordinates !== undefined) {
      zoomToAllPoints(map, [oldCoordinates]);

      if (selected) {
        selected.lng = oldCoordinates.lng;
        selected.lat = oldCoordinates.lat;
      }
    } else {
      zoomToAllPoints(map, [center]);
    }
  };

  $effect(() => {
    const container = desktopMapContainer;
    const hasContent = !!selected;

    if (hasContent && container) {
      const id = requestAnimationFrame(() => {
        createMap(desktopMapContainer);
      });
      return () => {
        cancelAnimationFrame(id);
        destroyMap(map, newMarker);
      };
    }

    destroyMap(map, newMarker);
  });

  const toggleMobileMap = async () => {
    if (showMobileMap) {
      destroyMap(map, newMarker);
      map = undefined;
      showMobileMap = false;
      return;
    }

    showMobileMap = true;
    await tick();
    createMap(mobileMapContainer);
    map?.resize();
  };

  onMount(async () => {
    await loadPhotos();
  });
</script>

<svelte:head>
  <title>TechGuessr - Submit Photos</title>
</svelte:head>

<div
  class="flex flex-1 flex-col sm:flex-row gap-2 p-2 overflow-hidden backdrop-blur-[2px]"
>
  <div
    class="flex-1 bg-base-200 rounded-box border-2 border-primary/50 overflow-hidden flex flex-col"
  >
    <h2 class="text-xl text-center font-bold my-2 sm:my-4">Submitted Photos</h2>
    <div
      class="p-2 flex-1 flex flex-wrap place-content-evenly gap-4 overflow-y-auto"
    >
      {#each photos as photo}
        <button
          type="button"
          class="btn w-32 h-32 md:w-56 md:h-56 flex flex-col {selected?.id ===
          photo.id
            ? 'btn-disabled'
            : ''}"
          onclick={() => {
            selected = { ...photo };
            oldCoordinates = new LngLat(selected.lng ?? 0, selected.lat ?? 0);
            pendingFile = null;
            previewUrl = null;
          }}
        >
          <img
            src={photo.publicUrl}
            alt={photo.publicUrl}
            class="max-h-26 md:max-h-42 max-w-26 md:max-w-42 object-contain rounded-box {selected?.id ===
            photo.id
              ? 'opacity-50'
              : 'opacity-100'}"
          />
          <span
            class="badge badge-xs md:badge-sm {selected?.id === photo.id
              ? 'opacity-50'
              : 'opacity-100'}"
            >{photo.status.charAt(0).toUpperCase() +
              photo.status.substring(1)}</span
          >
        </button>
      {:else}
        <div
          class="w-full flex flex-col place-content-center place-items-center gap-4"
        >
          <p class="text-5xl">🥲</p>
          <p class="opacity-60">No photos yet</p>
        </div>
      {/each}
    </div>
  </div>
  <div
    class="flex-2 flex flex-col bg-base-200 rounded-box border-2 border-primary/50 gap-4 min-h-0"
  >
    <div class="flex-1 flex flex-col p-2 gap-4">
      {#if selected}
        <div class="flex-1 flex w-full place-items-center min-h-0 gap-2">
          <div
            class="{(innerWidth.current ?? 0) < 768 &&
              'hidden'} flex-1 h-full rounded-box overflow-hidden"
          >
            <div
              id="desktop-map-container"
              class="w-full h-full rounded-box overflow-hidden"
              bind:this={desktopMapContainer}
            >
              {#if newMarker}
                <button
                  class="btn btn-error btn-soft btn-sm absolute bottom-10 right-2 z-20 shadow-2xl"
                  onclick={resetCoordinates}
                >
                  <RotateCcw size={16} />
                  <span>Reset</span>
                </button>
              {/if}
            </div>
          </div>
          <div
            class="flex-1 relative min-w-0 min-h-0 h-full place-content-center place-items-center bg-base-300 rounded-box object-contain"
          >
            <div
              class="absolute inset-0 flex items-center justify-center overflow-hidden rounded-box"
            >
              <img
                src={selected ? selected.publicUrl : previewUrl}
                alt="Preview"
                class="w-fit max-w-full h-fit max-h-full object-contain rounded-box"
              />
              <button
                class="absolute md:hidden bottom-1 right-1 btn btn-circle btn-soft btn-success"
                onclick={toggleMobileMap}
              >
                <MapIcon />
              </button>
              {#if showMobileMap}
                <div
                  class="fixed w-screen h-screen bottom-0 left-0 backdrop-blur-xl z-70"
                >
                  <div
                    class="fixed w-7/8 h-5/6 top-1/2 left-1/2 -translate-1/2 z-80 flex flex-col gap-6"
                  >
                    <h1 class="text-3xl font-bold text-center">
                      Select location
                    </h1>
                    <div
                      id="mobile-map-container"
                      class="w-full h-full rounded-box overflow-hidden z-15"
                      bind:this={mobileMapContainer}
                    >
                      <button
                        class="absolute top-1 right-1 btn btn-circle btn-soft z-20 shadow-2xl"
                        onclick={toggleMobileMap}
                      >
                        <X />
                      </button>
                      {#if newMarker}
                        <button
                          class="btn btn-error btn-soft btn-sm absolute bottom-1 right-1 z-20 shadow-2xl"
                          onclick={resetCoordinates}
                        >
                          <RotateCcw size={16} />
                          <span>Reset</span>
                        </button>
                      {/if}
                    </div>
                  </div>
                </div>
              {/if}
            </div>
          </div>
        </div>

        <div class="flex flex-col lg:flex-row gap-2">
          {#if selected}
            <div class="flex gap-4 lg:flex-col lg:min-w-64">
              <label class="floating-label flex-1">
                <span>Latitude</span>
                <input
                  class="w-full input input-bordered input-sm"
                  type="number"
                  step="any"
                  placeholder="Latitude"
                  bind:value={selected.lat}
                  required
                />
              </label>
              <label class="floating-label flex-1">
                <span>Longitude</span>
                <input
                  class="w-full input input-bordered input-sm"
                  type="number"
                  step="any"
                  placeholder="Longitude"
                  bind:value={selected.lng}
                  required
                />
              </label>
            </div>
            <label class="w-full floating-label">
              <textarea
                placeholder="Comments (optional)"
                class="textarea w-full"
                bind:value={selected.comment}
              ></textarea>
              <span>Comments</span>
            </label>
          {/if}

          {#if selected && !pendingFile}
            <div class="flex gap-2 lg:flex-col lg:min-w-48">
              <button
                class="flex-1 btn btn-sm btn-primary"
                type="button"
                onclick={updatePhoto}
              >
                <Save size={16} />
                <span>Save</span>
              </button>
              <button
                class="flex-1 btn btn-sm btn-error"
                type="button"
                onclick={deletePhoto}
              >
                <Trash size={16} />
                <span>Delete</span>
              </button>
            </div>
          {/if}
        </div>

        <hr class="text-base-100 border-t-4 rounded-full" />
      {:else}
        <div class="h-full flex place-items-center place-content-center">
          <p class="h-fit opacity-60">Select a photo or choose a file</p>
        </div>
      {/if}

      <div class="flex gap-2">
        <input
          type="file"
          accept="image/*"
          class="file-input file-input-sm sm:file-input-md file-input-bordered flex-1"
          onchange={onFile}
        />

        <button
          class="btn btn-primary btn-sm sm:btn-md"
          type="button"
          disabled={!pendingFile || uploading}
          onclick={submitUpload}
        >
          {uploading ? "Uploading…" : "Submit for review"}
        </button>

        <button
          class="btn btn-circle btn-info btn-sm sm:btn-md tooltip tooltip-left"
          data-tip="Submission Rules"
          onclick={() => (showRulesModal = true)}
        >
          <Scale />
        </button>
      </div>
    </div>
  </div>
</div>

<!-- Rules modal -->
<div
  class="w-screen h-screen fixed backdrop-blur-xl pointer-events-none {!showRulesModal &&
    'hidden'} z-10 bottom-0 right-0"
>
  <dialog class="modal {showRulesModal && 'modal-open'}">
    <div
      class="fixed top-1/2 left-1/2 -translate-1/2 modal-box flex flex-col rounded-box gap-4 p-4 sm:p-4 max-h-[80vh] pointer-events-auto"
    >
      <article class="prose prose-sm sm:prose-base overflow-y-auto pt-4 pr-2">
        <h1 class="text-center">Submission Rules</h1>
        <h2>Do:</h2>
        <ul class="list-(--check)">
          <li>Make sure that the photo was taken on campus</li>
          <li>Include some recognizable feature</li>
          <li>
            Set the coordinates to <b>where the photographer was standing</b>,
            not where the focus of the photo is
          </li>
          <li>
            Confirm that the coordinates are exactly correct (many times the GPS
            data is inaccurate)
          </li>
          <li>Upload both indoor and outdoor photos</li>
        </ul>

        <hr style="margin: 12px 0px;" />

        <h2>Don't:</h2>
        <ul class="list-(--x)">
          <li>Edit your photo to obscure the location</li>
          <li>
            Upload a photo if you forgot <b>exactly</b> where it was taken
          </li>
          <li>
            Zoom in when taking the picture (lower quality & harder to pinpoint
            location)
          </li>
          <li class="list-(--skull)">Upload NSFW content (instant ban)</li>
          <li class="list-(--skull)">
            Try to spam or DDOS the server (instant ban)
          </li>
        </ul>

        <hr style="margin: 12px 0px;" />

        <h2>Remember:</h2>
        <ul class="list-(--info)">
          <li><b>Every photo submitted can be viewed publicly</b></li>
          <li>All photos will be reviewed by an admin prior to approval</li>
          <li>
            Submissions may be denied or deleted at any time without reason
          </li>
        </ul>
      </article>

      <div class="flex place-content-end">
        <button
          class="btn btn-success"
          onclick={() => {
            showRulesModal = false;
          }}>Understood 🫡</button
        >
      </div>
    </div>
  </dialog>
</div>

<style>
  :root {
    --check: "✅";
    --x: "❌";
    --skull: "💀";
    --info: "ℹ️";
  }
  /* Disable step indicators on numerical inputs */

  /* Chrome & Safari */
  input::-webkit-outer-spin-button,
  input::-webkit-inner-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }

  /* Firefox */
  input[type="number"] {
    -moz-appearance: textfield;
  }

  /* Disable resize corner on textareas */
  textarea {
    resize: none;
  }
</style>

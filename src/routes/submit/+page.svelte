<script lang="ts">
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";
  import {
    extractGps,
    uploadPhoto,
    type Gps,
  } from "$lib/functions/photoUpload";

  type Photo = {
    id: string;
    storage_path: string;
    lat: number | null;
    long: number | null;
    status: "pending" | "approved" | "rejected";
    created_at: string;
  };

  let photos = $state<Photo[]>([]);
  let selected = $state<Photo | null>(null);
  let previewUrl = $state<string | null>(null);
  let pendingFile = $state<File | null>(null);
  let gps = $state<Gps>(null);
  let uploading = $state(false);
  let error = $state<string | null>(null);

  async function loadPhotos() {
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) return;

    const { data } = await supabase
      .from("photos")
      .select("id, storage_path, lat, long, status, created_at")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false });

    photos = data ?? [];
  }

  async function onFile(e: Event) {
    const input = e.target as HTMLInputElement;
    const file = input.files?.[0];
    if (!file) return;

    pendingFile = file;
    gps = await extractGps(file); // from original, before compress
    previewUrl = URL.createObjectURL(file);
    selected = null;
  }

  async function submitUpload() {
    if (!pendingFile) return;
    uploading = true;
    error = null;
    try {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) throw new Error("Not logged in");

      await uploadPhoto(supabase, user.id, pendingFile, gps);
      pendingFile = null;
      previewUrl = null;
      gps = null;
      await loadPhotos();
    } catch (e) {
      error = e instanceof Error ? e.message : "Upload failed";
    } finally {
      uploading = false;
    }
  }

  async function saveLocation() {
    if (!selected) return;
    const { error: err } = await supabase
      .from("photos")
      .update({
        lat: selected.lat,
        long: selected.long,
        updated_at: new Date().toISOString(),
      })
      .eq("id", selected.id);
    if (err) error = err.message;
    else await loadPhotos();
  }

  onMount(loadPhotos);
</script>

<div class="flex flex-1 gap-2 p-2">
  <div class="flex-1 bg-base-200 rounded-box">
    <h2 class="text-xl text-center font-bold my-4">Submitted Photos</h2>
    <div class="p-2">
      {#each photos as photo}
        <button
          type="button"
          class="btn w-64 h-64 flex flex-col"
          onclick={() => {
            selected = { ...photo };
            pendingFile = null;
            previewUrl = null;
          }}
        >
          <!-- Source should be a preview of each image from the photos bucket -->
          <img
            src={previewUrl}
            alt={photo.id}
            class="max-h-32 max-w-48 object-contain rounded-box"
          />
          <span class="badge badge-sm">{photo.status}</span>
          <span class="truncate text-xs opacity-70">{photo.id.slice(0, 8)}</span
          >
        </button>
      {:else}
        <p class="opacity-60">No photos yet</p>
      {/each}
    </div>
  </div>
  <div class="flex-1 flex flex-col gap-2">
    <div class="flex-1 flex flex-col bg-base-200 rounded-box">
      <h2 class="text-xl text-center font-bold my-2">Location</h2>
      <div class="flex-1">
        {#if selected || pendingFile}
          <label class="form-control">
            <span class="label-text">Latitude</span>
            <input
              class="input input-bordered input-sm"
              type="number"
              step="any"
            />
          </label>
          <!-- same for lng; or bind into a small map pin editor -->
          {#if selected}
            <button
              class="btn btn-sm btn-primary"
              type="button"
              onclick={saveLocation}
            >
              Save location
            </button>
          {/if}
          {#if gps || selected?.lat != null}
            <p class="text-xs opacity-60">
              Tweak coords if EXIF was wrong or missing
            </p>
          {/if}

          <img
            src={previewUrl}
            alt="Preview"
            class="max-h-64 rounded-box object-contain"
          />
        {:else}
          <div class="h-full flex place-items-center place-content-center">
            <p class="h-fit opacity-60">Select a photo or choose a file</p>
          </div>
        {/if}
      </div>
    </div>

    <div class="bg-base-200 rounded-box p-2">
      <h2 class="text-xl text-center font-bold my-2">Upload</h2>
      <div class="flex gap-2">
        <input
          type="file"
          accept="image/*"
          class="file-input file-input-bordered flex-1"
          onchange={onFile}
        />
        <button
          class="btn btn-primary"
          type="button"
          disabled={!pendingFile || uploading}
          onclick={submitUpload}
        >
          {uploading ? "Uploading…" : "Submit for review"}
        </button>
      </div>
      {#if error}<p class="text-error text-sm">{error}</p>{/if}
    </div>
  </div>
</div>

<script lang="ts">
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";
  import { extractGps, uploadPhoto } from "$lib/functions/photoUpload";
  import { toast } from "$lib/components/toast/toast.svelte";
  import { Save, Trash } from "@lucide/svelte";
  import type { Gps, Photo } from "../../consts";

  let photos = $state<Photo[]>([]);
  let selected = $state<Photo | null>(null);
  let previewUrl = $state<string | null>(null);
  let pendingFile = $state<File | null>(null);
  let gps: Gps = $state({ lat: 0, lng: 0 });
  let comment: string | null = $state(null);
  let uploading = $state(false);

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
        thumbUrl: pub.publicUrl,
      };
    });
  }

  async function onFile(e: Event) {
    const input = e.target as HTMLInputElement;
    const file = input.files?.[0];
    if (!file) return;

    pendingFile = file;
    let gpsData = await extractGps(file);
    if (gpsData) {
      gps = gpsData;
    } else {
      gps = { lat: 0, lng: 0 };
    }
    previewUrl = URL.createObjectURL(file);
    selected = null;
  }

  async function submitUpload() {
    if (!pendingFile) return;

    if (!gps?.lat || !gps?.lng) {
      toast("Add coordinates to submit", "error");
      return;
    }

    uploading = true;

    try {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) throw new Error("Not logged in");

      await uploadPhoto(supabase, user.id, pendingFile, gps, comment);
      pendingFile = null;
      previewUrl = null;
      gps = null;
      comment = null;
      await loadPhotos();
    } catch (e) {
      toast(e instanceof Error ? e.message : "Upload failed", "error");
    } finally {
      uploading = false;
    }
  }

  async function savePhotoData() {
    if (!selected) return;

    if (!selected.lat || isNaN(selected.lat)) {
      if (!selected.lng || isNaN(selected.lng)) {
        toast("Invalid latitude and lngitude", "error");
        return;
      }
      toast("Invalid latitude", "error");
      return;
    } else if (!selected.lng || isNaN(selected.lng)) {
      toast("Invalid lngitude", "error");
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
      await loadPhotos();
    }
  }

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
      toast("Delete image successfully", "success");
    }
  };

  onMount(loadPhotos);
</script>

<svelte:head>
  <title>TechGuessr - Submit Photos</title>
</svelte:head>

<div class="flex flex-1 gap-2 p-2 overflow-hidden">
  <div class="flex-1 bg-base-200 rounded-box overflow-hidden flex flex-col">
    <h2 class="text-xl text-center font-bold my-4">Submitted Photos</h2>
    <div class="p-2 flex-1 flex flex-wrap gap-2 overflow-y-auto">
      {#each photos as photo}
        <button
          type="button"
          class="btn w-56 h-56 flex flex-col {selected?.id === photo.id
            ? 'btn-disabled'
            : ''}"
          onclick={() => {
            selected = { ...photo };
            pendingFile = null;
            previewUrl = null;
          }}
        >
          <img
            src={photo.thumbUrl}
            alt={photo.thumbUrl}
            class="max-h-42 max-w-42 object-contain rounded-box {selected?.id ===
            photo.id
              ? 'opacity-50'
              : 'opacity-100'}"
          />
          <span
            class="badge badge-sm {selected?.id === photo.id
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
  <div class="flex-1 flex flex-col gap-2">
    <div class="flex-1 flex flex-col bg-base-200 rounded-box">
      <h2 class="text-xl text-center font-bold my-2">Location</h2>
      <div class="flex-1 flex flex-col p-2 gap-2">
        {#if selected || pendingFile}
          <div class="flex-1 flex place-content-center place-items-center">
            <img
              src={selected ? selected.thumbUrl : previewUrl}
              alt="Preview"
              class="max-h-72 rounded-box"
            />
          </div>

          <div class="flex flex-col gap-2">
            {#if selected}
              <div class="flex gap-2">
                <label class="floating-label flex-1">
                  <span>Latitude</span>
                  <input
                    class="input input-bordered input-sm"
                    type="number"
                    step="any"
                    placeholder="Latitude"
                    bind:value={selected.lat}
                    required
                  />
                </label>
                <label class="floating-label flex-1">
                  <span>lngitude</span>
                  <input
                    class="input input-bordered input-sm"
                    type="number"
                    step="any"
                    placeholder="lngitude"
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
            {:else if pendingFile && gps}
              <div class="flex gap-2">
                <label class="floating-label flex-1">
                  <span>Latitude</span>
                  <input
                    class="input input-bordered input-sm"
                    type="number"
                    step="any"
                    placeholder="Latitude"
                    bind:value={gps.lat}
                    required
                  />
                </label>
                <label class="floating-label flex-1">
                  <span>lngitude</span>
                  <input
                    class="input input-bordered input-sm"
                    type="number"
                    step="any"
                    placeholder="lngitude"
                    bind:value={gps.lng}
                    required
                  />
                </label>
              </div>
              <label class="w-full floating-label">
                <textarea
                  placeholder="Comments (optional)"
                  class="textarea w-full"
                  bind:value={comment}
                ></textarea>
                <span>Comments</span>
              </label>
            {/if}

            <div class="flex gap-2">
              {#if selected}
                <button
                  class="flex-1 btn btn-sm btn-primary"
                  type="button"
                  onclick={savePhotoData}
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
              {/if}
            </div>
          </div>
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
    </div>
  </div>
</div>

<style>
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

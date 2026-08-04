<script lang="ts">
  import { toast } from "$lib/components/ui/toast/toast.svelte";
  import { supabase } from "$lib/supabaseClient";
  import { X, Map, Lock } from "@lucide/svelte";
  import { onMount } from "svelte";

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
      const photo = data[Math.floor(Math.random() * imageCount)];

      const { data: pubData } = supabase.storage
        .from("photos")
        .getPublicUrl(photo.storage_path);

      photos[i] = { ...photo, publicUrl: pubData.publicUrl };
    }

    imageLoading = false;
  };

  onMount(() => {
    loadPhotos();
  });
</script>

<div class="flex flex-col flex-1 p-2 gap-2">
  <div class="flex-1 max-h-12 rounded-box"></div>
  <div class="relative flex-1 min-h-0 overflow-hidden rounded-box bg-base-200">
    {#if imageLoading}
      <p class="h-full text-center place-content-center">
        <span class="loading loading-spinner loading-xl"></span>
        <span class="block text-lg mt-4">Next location loading...</span>
      </p>
    {:else}
      <img
        src={photos[0].publicUrl}
        alt="Check internet connection 👌"
        class="absolute inset-0 w-full h-full object-contain"
      />
    {/if}

    <div
      class="absolute w-full bottom-0 left-0 flex p-2 gap-2 place-content-between"
    >
      <div></div>

      <button
        type="button"
        class="btn btn-primary btn-wide z-20 shadow-lg {lockedIn
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

      <button
        type="button"
        class="btn btn-circle btn-primary z-20 shadow-lg"
        onclick={() => (mapOpen = !mapOpen)}
      >
        {#if mapOpen}
          <X />
        {:else}
          <Map />
        {/if}
      </button>
    </div>
  </div>
  <div
    class="fixed bottom-4 right-4 z-10 h-[min(50vh,22rem)] w-[min(90vw,24rem)]
             overflow-hidden rounded-box bg-base-300 shadow-lg
             transition-transform duration-100 ease-out
             {mapOpen
      ? 'translate-x-0 translate-y-0'
      : 'translate-x-[calc(100%+1.5rem)] translate-y-[calc(100%+1.5rem)]'}"
  >
    Map goes here
  </div>
</div>

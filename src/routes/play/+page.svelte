<script lang="ts">
  import { X, Map, Lock } from "@lucide/svelte";

  let imageLoading: boolean = $state(false);
  let mapOpen: boolean = $state(false);
  let lockedIn: boolean = $state(false);

  const handleLockIn = async () => {
    lockedIn = true;
  };
</script>

<div class="flex flex-col flex-1 p-2 gap-2">
  <div class="flex-1 max-h-12 rounded-box"></div>
  <div class="relative flex-1 rounded-box bg-base-200">
    <img src="" alt="Guess this location" class="w-full h-full object-cover" />

    <button
      type="button"
      class="btn btn-primary btn-wide absolute bottom-4 left-4 z-20 shadow-lg {lockedIn
        ? 'btn-disabled'
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
      class="btn btn-circle btn-primary absolute bottom-4 right-4 z-20 shadow-lg"
      onclick={() => (mapOpen = !mapOpen)}
    >
      {#if mapOpen}
        <X />
      {:else}
        <Map />
      {/if}
    </button>
  </div>
  <div
    class="fixed bottom-4 right-4 z-10 h-[min(50vh,22rem)] w-[min(90vw,24rem)]
             overflow-hidden rounded-box bg-base-300 shadow-lg
             transition-transform duration-300 ease-out
             {mapOpen
      ? 'translate-x-0 translate-y-0'
      : 'translate-x-[calc(100%+1.5rem)] translate-y-[calc(100%+1.5rem)]'}"
  >
    A
  </div>
</div>

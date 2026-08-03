<script lang="ts">
  import { X, Map, Lock } from "@lucide/svelte";

  let imageLoading: boolean = $state(true);
  let mapOpen: boolean = $state(false);
  let lockedIn: boolean = $state(false);

  const handleLockIn = async () => {
    lockedIn = true;
  };
</script>

<div class="flex flex-col flex-1 p-2 gap-2">
  <div class="flex-1 max-h-12 rounded-box"></div>
  <div class="relative flex-1 rounded-box bg-base-200">
    {#if imageLoading}
      <p class="h-full text-center place-content-center">
        <span class="loading loading-spinner loading-xl"></span>
        <span class="block text-lg mt-4">Next location loading...</span>
      </p>
    {:else}
      <img
        src=""
        alt="Guess this location"
        class="w-full h-full object-cover"
      />
    {/if}

    <div
      class="absolute w-full bottom-0 left-0 flex p-2 gap-2 place-content-between"
    >
      <div></div>

      <button
        type="button"
        class="btn btn-primary btn-wide z-20 shadow-lg {lockedIn
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

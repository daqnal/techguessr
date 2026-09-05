<script lang="ts">
  import BounceCards from "$lib/components/sveltebits/BounceCards.svelte";
  import SplitText from "$lib/components/sveltebits/SplitText.svelte";
  import { supabase } from "$lib/supabaseClient";
  import { onMount } from "svelte";

  const filenames = [
    "parking_deck.webp",
    "nav.webp",
    "heffernan.webp",
    "library.webp",
    "it.webp",
  ];

  let loaded = $state<boolean[]>(new Array(5).fill(false));
  let pubUrls: string[] = $state([]);

  onMount(async () => {
    pubUrls = filenames.map((f) => {
      const { data } = supabase.storage
        .from("photos")
        .getPublicUrl(`root_page/${f}`);
      return data.publicUrl;
    });
  });
</script>

<div class="w-full h-full relative">
  <div
    class="w-fit absolute top-1/2 left-1/2 -translate-1/2 pt-12 pointer-events-auto"
  >
    <BounceCards
      images={pubUrls}
      animationDelay={0.4}
      animationStagger={0.08}
      enableHover={true}
      bind:loaded
    />
  </div>

  <div
    class="w-full max-w-132 h-full absolute left-1/2 -translate-x-1/2 flex flex-col place-content-between text-center gap-4 px-2 py-8 pointer-events-none"
  >
    <div
      class="text-4xl sm:text-6xl lg:text-7xl p-3 rounded-box text-shadow-lg flex flex-col place-content-center place-items-center gap-2"
    >
      <div class="w-fit rounded-box">
        <span class="font-medium -mr-2">
          <SplitText text="Tech" class="overflow-x-visible" delay={50} />
        </span>
        <span class="font-black">
          <SplitText text="Guessr" delay={100} />
        </span>
      </div>
    </div>

    <div class="hover:scale-[1.1] duration-200">
      <div
        class="aura hover:aura-lg aura-rainbow duration-4000 rounded-full pointer-events-auto"
      >
        <a href="/play" class="btn btn-lg sm:btn-xl rounded-full">Play now!</a>
      </div>
    </div>
  </div>
</div>

<style>
  /* When vertical space is small, arrange hero as two columns: photos left, text/button right */
  :global(.short-row) {
    display: flex;
    align-items: center;
    justify-content: center;
    flex-direction: row;
    gap: 1rem;
    padding: 0.5rem;
  }

  :global(.short-row) > div {
    /* inner wrapper */
    flex: 1 1 auto;
    min-width: 0;
  }
</style>

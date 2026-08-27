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
    class="w-fit absolute top-1/2 left-1/2 -translate-1/2 pointer-events-auto"
  >
    <BounceCards
      images={pubUrls}
      animationDelay={0.4}
      animationStagger={0.08}
      enableHover={true}
      class="border-primary"
      bind:loaded
    />
  </div>

  <div
    class="w-fit h-full absolute left-1/2 -translate-x-1/2 flex flex-col place-content-center text-center gap-4 lg:place-content-between py-8 pointer-events-none"
  >
    <div
      class="text-4xl sm:text-5xl md:text-6xl lg:text-7xl bg-base-300/75 lg:bg-base-100/90 p-3 rounded-box shadow-2xl lg:shadow-none"
    >
      <span class="font-medium -mr-2">
        <SplitText text="Tech" class="overflow-x-visible" delay={50} />
      </span>
      <span class="font-black">
        <SplitText text="Guessr" delay={100} />
      </span>

      <p class="mt-2 text-sm sm:text-base md:text-lg">
        Locate photos across Georgia Tech's campus 🧭
      </p>
    </div>

    <div class="hover:scale-[1.1] duration-200">
      <div
        class="aura hover:aura-lg aura-rainbow duration-4000 rounded-full pointer-events-auto"
      >
        <a href="/play" class="btn btn-xl rounded-full">Play now!</a>
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

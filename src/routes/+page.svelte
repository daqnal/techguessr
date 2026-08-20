<script>
  import BounceCards from "$lib/components/sveltebits/BounceCards.svelte";
  import SplitText from "$lib/components/sveltebits/SplitText.svelte";
</script>

<div class="fixed inset-0 overflow-hidden pointer-events-none z-10">
  <div
    class="h-full flex flex-col place-items-center place-content-center overflow-hidden"
  >
    <div class="text-center text-7xl -mb-4">
      <span class="font-medium -mr-2">
        <SplitText text="Tech" class="overflow-x-visible" delay={50} />
      </span>
      <span class="font-black">
        <SplitText text="Guessr" delay={100} />
      </span>

      <p class="mt-2 text-lg">Locate photos across Georgia Tech's campus 🧭</p>
    </div>

    <div class="pointer-events-auto">
      <BounceCards
        images={[
          "/example_images/nav.jpg",
          "/example_images/library.jpg",
          "/example_images/5g.jpg",
          "/example_images/parking_deck.jpg",
        ]}
        animationDelay={0.4}
        animationStagger={0.08}
        containerHeight={600}
        containerWidth={400}
        enableHover={true}
        class="border-primary"
      />
    </div>

    <div class="hover:scale-[1.1] duration-200 -mt-16">
      <div
        class="aura hover:aura-lg aura-rainbow duration-4000 rounded-full pointer-events-auto"
      >
        <a href="/play" class="btn btn-xl rounded-full">Play now!</a>
      </div>
    </div>
  </div>
</div>

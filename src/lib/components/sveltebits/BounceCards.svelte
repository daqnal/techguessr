<script lang="ts">
  import { onMount } from "svelte";
  import { gsap } from "gsap";

  type Props = {
    class?: string;
    images?: string[];
    animationDelay?: number;
    animationStagger?: number;
    easeType?: string;
    transformStyles?: string[];
    enableHover?: boolean;
    loaded?: boolean[];
  };

  let {
    class: className = "",
    images = [],
    animationDelay = 0.5,
    animationStagger = 0.06,
    easeType = "elastic.out(1, 0.8)",
    transformStyles = [
      "rotate(10deg) translate(-170px)",
      "rotate(5deg) translate(-85px)",
      "rotate(-3deg)",
      "rotate(-10deg) translate(85px)",
      "rotate(2deg) translate(170px)",
    ],
    enableHover = false,
    loaded = $bindable(new Array(images.length).fill(true)),
    // loaded = new Array(images.length).fill(true),
  }: Props = $props();

  let containerRef: HTMLDivElement;

  onMount(() => {
    const ctx = gsap.context(() => {
      gsap.fromTo(
        ".bc-card",
        { scale: 0 },
        {
          scale: 1,
          stagger: animationStagger,
          ease: easeType,
          delay: animationDelay,
        },
      );
    }, containerRef);
    return () => ctx.revert();
  });

  function getNoRotationTransform(t: string): string {
    const hasRotate = /rotate\([\s\S]*?\)/.test(t);
    if (hasRotate) return t.replace(/rotate\([\s\S]*?\)/, "rotate(0deg)");
    if (t === "none") return "rotate(0deg)";
    return `${t} rotate(0deg)`;
  }
  function getPushedTransform(base: string, offsetX: number): string {
    const re = /translate\(([-0-9.]+)px\)/;
    const m = base.match(re);
    if (m) {
      const newX = parseFloat(m[1]) + offsetX;
      return base.replace(re, `translate(${newX}px)`);
    }
    return base === "none"
      ? `translate(${offsetX}px)`
      : `${base} translate(${offsetX}px)`;
  }

  function pushSiblings(hoveredIdx: number) {
    if (!enableHover || !containerRef) return;
    const q = gsap.utils.selector(containerRef);
    images.forEach((_, i) => {
      const selector = q(`.bc-card-${i}`);
      gsap.killTweensOf(selector);
      const base = transformStyles[i] || "none";
      if (i === hoveredIdx) {
        gsap.to(selector, {
          transform: getNoRotationTransform(base),
          duration: 0.4,
          ease: "back.out(1.4)",
          overwrite: "auto",
        });
      } else {
        let offsetX = 0;
        if (window.innerWidth >= 768) {
          offsetX = i < hoveredIdx ? -160 : 160;
        } else {
          offsetX = i < hoveredIdx ? -80 : 80;
        }

        gsap.to(selector, {
          transform: getPushedTransform(base, offsetX),
          duration: 0.4,
          ease: "back.out(1.4)",
          delay: Math.abs(hoveredIdx - i) * 0.05,
          overwrite: "auto",
        });
      }
    });
  }
  function resetSiblings() {
    if (!enableHover || !containerRef) return;
    const q = gsap.utils.selector(containerRef);
    images.forEach((_, i) => {
      const selector = q(`.bc-card-${i}`);
      gsap.killTweensOf(selector);
      gsap.to(selector, {
        transform: transformStyles[i] || "none",
        duration: 0.4,
        ease: "back.out(1.4)",
        overwrite: "auto",
      });
    });
  }
</script>

<div
  bind:this={containerRef}
  class="relative flex items-center justify-center {className}"
>
  {#each images as src, idx (idx)}
    <div
      class="bc-card bc-card-{idx} absolute
        w-[32vh] min-h-[24vh]
        border-4 md:border-6 lg:border-8 border-neutral-content bg-neutral-content rounded-box overflow-hidden"
      style="box-shadow:0 4px 10px rgba(0,0,0,0.2); transform:{transformStyles[
        idx
      ] || 'none'};"
      onmouseenter={() => pushSiblings(idx)}
      onmouseleave={resetSiblings}
      role="presentation"
    >
      {#if !loaded[idx]}
        <div class="skeleton absolute inset-0 w-full h-full"></div>
      {/if}

      <img
        class="w-full h-full object-cover {loaded[idx]
          ? 'opacity-100'
          : 'opacity-0'}"
        {src}
        alt="card-{idx}"
        onload={() => (loaded[idx] = true)}
        loading="lazy"
      />
    </div>
  {/each}
</div>

<script lang="ts">
  import "./layout.css";
  import Navbar from "$lib/components/Navbar.svelte";
  import ToastHost from "$lib/components/toast/ToastHost.svelte";
  import { SvelteTheme } from "svelte-themes";
  import ShapeGrid from "$lib/components/sveltebits/ShapeGrid.svelte";
  import { userState } from "./state.svelte";

  let { children } = $props();
</script>

<svelte:head
  ><link
    rel="icon"
    href="data:image/svg+xml,<svg xmlns=%22http://www.w3.org/2000/svg%22 viewBox=%220 0 100 100%22><text y=%22.9em%22 font-size=%2290%22>🧭</text></svg>"
  />
  <title>TechGuessr</title>
</svelte:head>
<!-- https://css-tricks.com/emoji-as-a-favicon/ -->

<SvelteTheme
  themes={[
    "tokyonight",
    "catppuccin",
    "gruvbox",
    "synthwave",
    "rosepine",
    "dracula",
    "kanagawa",
    "nord",
    "emerald",
  ]}
  colorScheme={{
    tokyonight: "dark",
    catppuccin: "dark",
    gruvbox: "dark",
    synthwave: "dark",
    rosepine: "dark",
    dracula: "dark",
    kanagawa: "dark",
    nord: "light",
    emerald: "light",
  }}
  attribute="data-theme"
>
  <div class="flex h-full min-h-0 flex-col overflow-hidden">
    <Navbar />
    <div class="flex min-h-0 flex-1 flex-col overflow-hidden">
      {@render children()}
    </div>
    <div
      class="w-full h-full absolute top-0 left-0 pointer-events-auto z-[-10]"
    >
      {#if userState.gridEnabled}
        <ShapeGrid
          direction="diagonal"
          speed={userState.gridSpeed}
          squareSize={30}
          hoverTrailAmount={4}
        />
      {/if}
    </div>
  </div>
</SvelteTheme>

<ToastHost />

<script lang="ts">
  import { onMount } from "svelte";
  import "./layout.css";
  import Navbar from "$lib/components/Navbar.svelte";
  import ToastHost from "$lib/components/toast/ToastHost.svelte";
  import { SvelteTheme } from "svelte-themes";
  import ShapeGrid from "$lib/components/sveltebits/ShapeGrid.svelte";
  import { userState } from "$lib/state.svelte";

  let { children } = $props();
  let stateHydrated = $state(false);

  onMount(() => {
    const storedState = localStorage.getItem("techguessr.user-state");

    if (storedState) {
      try {
        const parsedState = JSON.parse(storedState);

        if (parsedState && typeof parsedState === "object") {
          if (typeof parsedState.loggedIn === "boolean") {
            userState.loggedIn = parsedState.loggedIn;
          }
          if (
            parsedState.unitSystem === "metric" ||
            parsedState.unitSystem === "imperial"
          ) {
            userState.unitSystem = parsedState.unitSystem;
          }
          if (typeof parsedState.gridEnabled === "boolean") {
            userState.gridEnabled = parsedState.gridEnabled;
          }
          if (
            typeof parsedState.gridSpeed === "number" &&
            Number.isFinite(parsedState.gridSpeed)
          ) {
            userState.gridSpeed = parsedState.gridSpeed;
          }
        }
      } catch {
        localStorage.removeItem("techguessr.user-state");
      }
    }

    stateHydrated = true;
  });

  $effect(() => {
    if (stateHydrated) {
      localStorage.setItem("techguessr.user-state", JSON.stringify(userState));
    }
  });
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

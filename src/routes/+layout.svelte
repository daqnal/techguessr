<script lang="ts">
  import "./layout.css";
  import favicon from "$lib/assets/favicon.svg";
  import Navbar from "$lib/components/Navbar.svelte";
  import ToastHost from "$lib/components/toast/ToastHost.svelte";
  import { SvelteTheme } from "svelte-themes";

  let { children } = $props();
</script>

<svelte:head
  ><link rel="icon" href={favicon} />
  <title>TechGuessr</title>
</svelte:head>

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
  </div>
</SvelteTheme>

<ToastHost />

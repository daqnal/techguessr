<script lang="ts">
  import "./layout.css";
  import favicon from "$lib/assets/favicon.svg";
  import Navbar from "$lib/components/Navbar.svelte";
  import ToastHost from "$lib/components/toast/ToastHost.svelte";

  let { children } = $props();

  try {
    const t = localStorage.getItem("themeId");
    if (t) {
      document.documentElement.setAttribute("data-theme", t);
    }
  } catch (_) {}
</script>

<svelte:head
  ><link rel="icon" href={favicon} />
  <title>TechGuessr</title>
</svelte:head>
<div class="flex h-full min-h-0 flex-col overflow-hidden">
  <Navbar />
  <div class="flex min-h-0 flex-1 flex-col overflow-hidden">
    {@render children()}
  </div>
</div>

<ToastHost />

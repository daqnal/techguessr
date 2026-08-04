<script lang="ts">
  import "./layout.css";
  import favicon from "$lib/assets/favicon.svg";
  import Navbar from "$lib/components/ui/Navbar.svelte";
  import ToastHost from "$lib/components/ui/toast/ToastHost.svelte";

  let { children } = $props();
</script>

<svelte:head
  ><link rel="icon" href={favicon} />
  <title>TechGuessr</title>
</svelte:head>
<div class="flex h-full min-h-0 flex-col overflow-hidden">
  <Navbar />
  {@render children()}
</div>

<ToastHost />

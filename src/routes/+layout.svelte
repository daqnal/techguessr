<script lang="ts">
  import "./layout.css";
  import favicon from "$lib/assets/favicon.svg";
  import Navbar from "$lib/components/ui/Navbar.svelte";

  let { children } = $props();
</script>

<svelte:head
  ><link rel="icon" href={favicon} />
  <title>TechGuessr</title>
</svelte:head>
<div class="h-full flex flex-col">
  <Navbar />
  {@render children()}
</div>

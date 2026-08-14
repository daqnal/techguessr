<script lang="ts">
  let mapContainer: HTMLDivElement;

  let { results } = $props();
</script>

<div class="flex-1">
  <div class="w-full max-w-xl flex flex-col gap-2 bg-base-300">
    <div bind:this={mapContainer}></div>

    <ul class="list bg-base-100 rounded-box shadow-md">
      {#each results as result}
        <li class="list-row"></li>
      {/each}
    </ul>
  </div>
</div>

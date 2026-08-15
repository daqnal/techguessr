<script lang="ts">
  let { name, children } = $props();
</script>

<div class="flex flex-col gap-2">
  <div class="flex place-content-between place-items-center">
    <p class="font-bold flex-1 ml-2">{name}</p>
    <div class="flex-1 flex place-content-end">
      {@render children()}
    </div>
  </div>
</div>

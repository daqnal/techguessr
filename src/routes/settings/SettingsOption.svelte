<script lang="ts">
  let { name, children } = $props();
</script>

<div class="flex flex-col gap-2">
  <div
    class="flex flex-col sm:flex-row place-content-between place-items-center gap-1 sm:gap-0"
  >
    <p class="font-bold flex-1 ml-2">{name}</p>
    <div class="w-full flex-1 flex place-content-end">
      {@render children()}
    </div>
  </div>
</div>

<script lang="ts">
  import { page } from "$app/state";
  import { ArrowLeft, House } from "@lucide/svelte";
</script>

<div
  class="w-full h-full flex flex-col place-content-center place-items-center gap-4"
>
  <h1 class="font-[900] text-7xl">{page.status}</h1>
  <h2 class="font-[700]">{page.error?.message}</h2>
  <div class="flex gap-4">
    <button class="btn min-w-36" onclick={() => history.back()}>
      <ArrowLeft />
      <span>Go back</span>
    </button>

    <a href="/" class="btn btn-primary min-w-36">
      <House />
      <span>Home</span>
    </a>
  </div>
</div>

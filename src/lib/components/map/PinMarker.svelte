<script lang="ts">
  import { MapPin } from "@lucide/svelte";

  interface Props {
    label?: string;
    size?: number;
    strokeWidth?: number;
    colorClass?: string;
    fillClass?: string;
  }

  let {
    label,
    size = 36,
    strokeWidth = 1,
    colorClass,
    fillClass,
  }: Props = $props();
</script>

<div class="flex flex-col items-center pointer-events-auto select-none">
  <div class="{colorClass} drop-shadow-md">
    <MapPin {size} {strokeWidth} class={fillClass} />
  </div>

  {#if label}
    <span
      class="badge badge-slate-800 text-slate-200 badge-xs mt-0.5 shadow-sm whitespace-nowrap"
    >
      {label}
    </span>
  {/if}
</div>

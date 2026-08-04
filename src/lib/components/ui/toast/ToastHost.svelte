<script lang="ts">
  import {
    toastState,
    dismissToast,
    type ToastType,
  } from "$lib/components/ui/toast/toast.svelte";
  import { X } from "@lucide/svelte";

  const alertClass: Record<ToastType, string> = {
    info: "alert-info",
    success: "alert-success",
    warning: "alert-warning",
    error: "alert-error",
  };
</script>

<div class="toast toast-bottom toast-start z-[9999]">
  {#each toastState.toasts as t (t.id)}
    <div
      class="alert {alertClass[
        t.type
      ]} w-72 flex place-content-between shadow-lg"
    >
      <span>{t.message}</span>
      <button
        type="button"
        class="btn btn-xs btn-circle opacity-25"
        onclick={() => dismissToast(t.id)}
        aria-label="Dismiss"
      >
        <X size={16} />
      </button>
    </div>
  {/each}
</div>

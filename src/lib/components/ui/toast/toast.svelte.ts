export type ToastType = "info" | "success" | "warning" | "error";

export type Toast = {
  id: number;
  message: string;
  type: ToastType;
};

let nextId = 0;

/** Single reactive bag — components read `.toasts` from this same object */
export const toastState = $state({
  toasts: [] as Toast[],
});

export function toast(
  message: string,
  type: ToastType = "info",
  duration = 7000,
) {
  const t: Toast = { id: ++nextId, message, type };
  toastState.toasts = [...toastState.toasts, t];

  setTimeout(() => {
    toastState.toasts = toastState.toasts.filter((x) => x.id !== t.id);
  }, duration);
}

export function dismissToast(id: number) {
  toastState.toasts = toastState.toasts.filter((x) => x.id !== id);
}

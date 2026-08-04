import imageCompression from "browser-image-compression";
import exifr from "exifr";
import type { SupabaseClient } from "@supabase/supabase-js";
import { toast } from "$lib/components/ui/toast/toast.svelte";

export type Gps = { lat: number | null; long: number | null } | null;

export async function extractGps(file: File): Promise<Gps> {
  try {
    const gps = await exifr.gps(file);

    if (gps?.latitude != null && gps?.longitude != null) {
      return { lat: gps.latitude, long: gps.longitude };
    } else {
      toast("No GPS data detected — add coordinates in manually", "info");
    }
  } catch (error) {
    toast(
      error instanceof Error ? error.message : "EXIF extraction failed",
      "error",
    );
  }

  return null;
}

export async function compressPhoto(file: File): Promise<File> {
  const blob = await imageCompression(file, {
    maxWidthOrHeight: 1920,
    maxSizeMB: 1.5,
    fileType: "image/webp",
    initialQuality: 0.82,
    useWebWorker: false,
  });
  return new File([blob], file.name.replace(/\.[^.]+$/, ".webp"), {
    type: "image/webp",
  });
}

export async function uploadPhoto(
  supabase: SupabaseClient,
  userId: string,
  original: File,
  coords: Gps,
  comment: string | null,
): Promise<void> {
  const gps = coords ?? (await extractGps(original));
  const compressed = await compressPhoto(original);

  const path = `${userId}/${crypto.randomUUID()}.webp`;

  const { error: upErr } = await supabase.storage
    .from("photos")
    .upload(path, compressed, {
      contentType: "image/webp",
      upsert: false,
    });
  if (upErr) throw upErr;

  const { error: dbErr } = await supabase.from("photos").insert({
    user_id: userId,
    storage_path: path,
    lat: gps?.lat ?? null,
    long: gps?.long ?? null,
    status: "pending",
    comment: comment,
  });
  if (dbErr) throw dbErr;
}

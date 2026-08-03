import imageCompression from "browser-image-compression";
import exifr from "exifr";
import type { SupabaseClient } from "@supabase/supabase-js";

export type Gps = { lat: number; long: number } | null;

export async function extractGps(file: File): Promise<Gps> {
  try {
    const gps = await exifr.gps(file);
    if (gps?.latitude != null && gps?.longitude != null) {
      return { lat: gps.latitude, long: gps.longitude };
    }
  } catch {
    /* no GPS */
  }
  return null;
}

/** Resize long edge to ~1080, WebP ~0.8 — EXIF is dropped by the encoder */
export async function compressPhoto(file: File): Promise<File> {
  const blob = await imageCompression(file, {
    maxWidthOrHeight: 1920, // ~1080p long edge; use 1920 for a bit more zoom room
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

  const { error: dbErr } = await supabase
    .from("photos")
    .insert({
      user_id: userId,
      storage_path: path,
      lat: gps?.lat ?? null,
      long: gps?.long ?? null,
      status: "pending",
    });
  if (dbErr) throw dbErr;
}

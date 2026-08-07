export type Gps = { lat: number; lng: number } | null;

export type Photo = {
  id: string;
  storage_path: string;
  lat: number | null;
  lng: number | null;
  comment?: string;
  status: "pending" | "approved" | "rejected";
  created_at: string;
  thumbUrl?: string | null;
};

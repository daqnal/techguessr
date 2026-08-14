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

export type Theme = {
  id: string;
  name: string;
};

export const themes: Theme[] = [
  { id: "tokyonight", name: "Tokyo Night" },
  { id: "emerald", name: "Emerald" },
];

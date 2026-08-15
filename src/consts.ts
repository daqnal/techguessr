import type { LngLat } from "maplibre-gl";

export type Photo = {
  id: string;
  storage_path: string;
  lat: number | null;
  lng: number | null;
  comment?: string;
  status: "pending" | "approved" | "rejected";
  created_at?: string;
  publicUrl?: string | null;
};

export type RoundState = {
  photo: Photo;
  guess: LngLat | null;
  score: number;
  dist: number | undefined;
};

export type GameState = {
  rounds: RoundState[];
  currIndex: number;
  totalScore: number;
};

export type Theme = {
  id: string;
  name: string;
};

export const themes: Theme[] = [
  { id: "tokyonight", name: "Tokyo Night" },
  { id: "emerald", name: "Emerald" },
  { id: "dracula", name: "Dracula" },
  { id: "synthwave", name: "Synthwave" },
  { id: "andromeda", name: "Andromeda" },
  { id: "ayudark", name: "Ayu Dark " },
  { id: "catppuccin", name: "Catppuccin" },
  { id: "everforest", name: "Everforest" },
  { id: "flexoki", name: "Flexoki" },
  { id: "gruvbox", name: "Gruvbox" },
  { id: "kanagawa", name: "Kanagawa" },
  { id: "monokai", name: "Monokai" },
  { id: "nightfox", name: "Nightfox" },
  { id: "nightowl", name: "Nightowl" },
  { id: "onedarkpro", name: "One Dark Pro" },
  { id: "rosepine", name: "Rose Pine" },
  { id: "solarized", name: "Solarized" },
];

import { LngLat, LngLatBounds } from "maplibre-gl";

export const IMAGE_COUNT = 5;

export const MAP_STYLE_URL: string =
  "https://tiles.openfreemap.org/styles/bright";

export const CAMPUS_CENTER: LngLat = new LngLat(-84.398815, 33.776099);

const CAMPUS_NE_BOUND: LngLat = new LngLat(
  -84.37423642627746,
  33.79079208919991,
);
const CAMPUS_SW_BOUND: LngLat = new LngLat(
  -84.41752206057956,
  33.759767990481066,
);
export const CAMPUS_BOUNDS: LngLatBounds = new LngLatBounds(
  CAMPUS_SW_BOUND,
  CAMPUS_NE_BOUND,
);

export const mapBorder: string = "#81a9ff";
export const mapFill: string = "#45556c";

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
  id: string;
  photo: Photo;
  guess: LngLat | null;
  score: number;
  dist: number | undefined;
};

export type GameState = {
  id: string;
  rounds: RoundState[];
  currIndex: number;
  totalScore: number;
};

export type Theme = {
  id: string;
  name: string;
};

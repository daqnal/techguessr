import { LngLat } from "maplibre-gl";
import type { Gps } from "../../consts";

type Result = {
  dist: number;
  midpoint: LngLat;
  score: number;
};

export default function calculateResults(guess: Gps, ans: Gps): Result {
  if (!guess || !ans) {
    throw Error("Invalid GPS arguments");
  }

  // Calculate distance and midpoint
  //
  // https://www.movable-type.co.uk/scripts/latlong.html

  const toRad = (d: number) => (d * Math.PI) / 180;
  const toDeg = (r: number) => (r * 180) / Math.PI;

  const φ1 = toRad(guess.lat);
  const λ1 = toRad(guess.lng);
  const φ2 = toRad(ans.lat);
  const λ2 = toRad(ans.lng);

  const Δφ = φ2 - φ1;
  const Δλ = λ2 - λ1;

  // Haversine formula
  const R = 6371e3;
  const a =
    Math.sin(Δφ / 2) ** 2 + Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) ** 2;
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const dist = R * c;

  // Calculate midpoint
  const Bx = Math.cos(φ2) * Math.cos(Δλ);
  const By = Math.cos(φ2) * Math.sin(Δλ);

  const φ3 = Math.atan2(
    Math.sin(φ1) + Math.sin(φ2),
    Math.sqrt((Math.cos(φ1) + Bx) ** 2 + By ** 2),
  );
  const λ3 = λ1 + Math.atan2(By, Math.cos(φ1) + Bx);

  const midpoint = new LngLat(toDeg(λ3), toDeg(φ3));

  // Calculate score
  const fivek = 5; // 5m and under should be a 5K
  const zero = 1000; // 1000m and over should be 0
  const worst = 2000; // Basically worst guess is 2000m
  const m = -5000 / (worst - zero);
  const b = -m * zero;

  let score = Math.round(m * dist + b);
  if (dist <= fivek) {
    score = 5000;
  } else if (dist >= zero) {
    score = 0;
  }

  console.log(midpoint);

  return { dist, midpoint, score };
}

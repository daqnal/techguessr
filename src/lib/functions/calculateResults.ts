import { LngLat } from "maplibre-gl";

type Result = {
  dist: number;
  midpoint: LngLat;
  score: number;
};

export default function calculateResults(guess: LngLat, ans: LngLat): Result {
  if (!guess || !ans) {
    throw Error("Invalid GPS arguments");
  }

  // Calculate distance and midpoint
  //
  // https://www.movable-type.co.uk/scripts/latlong.html

  const toRad = (d: number) => (d * Math.PI) / 180;
  const toDeg = (r: number) => (r * 180) / Math.PI;

  const phi1 = toRad(guess.lat);
  const lambda1 = toRad(guess.lng);
  const phi2 = toRad(ans.lat);
  const lambda2 = toRad(ans.lng);

  const deltaPhi = phi2 - phi1;
  const deltaLambda = lambda2 - lambda1;

  // Haversine formula
  const R = 6371e3;
  const a =
    Math.sin(deltaPhi / 2) ** 2 +
    Math.cos(phi1) * Math.cos(phi2) * Math.sin(deltaLambda / 2) ** 2;
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const dist = R * c;

  // Calculate midpoint
  const Bx = Math.cos(phi2) * Math.cos(deltaLambda);
  const By = Math.cos(phi2) * Math.sin(deltaLambda);

  const phi3 = Math.atan2(
    Math.sin(phi1) + Math.sin(phi2),
    Math.sqrt((Math.cos(phi1) + Bx) ** 2 + By ** 2),
  );
  const lambda3 = lambda1 + Math.atan2(By, Math.cos(phi1) + Bx);

  const midpoint = new LngLat(toDeg(lambda3), toDeg(phi3));

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

  return { dist, midpoint, score };
}

import type { Gps } from "../../consts";

type Result = {
  dist: number;
  score: number;
};

export default function calculateResults(guess: Gps, ans: Gps): Result {
  if (!guess || !ans) {
    throw Error("Invalid GPS arguments");
  }

  // Haversine formula https://www.movable-type.co.uk/scripts/latlong.html
  const earthRadius = 6371e3;
  const phiGuess = (guess.lat * Math.PI) / 180;
  const phiAns = (ans.lat * Math.PI) / 180;
  const deltaPhi = ((ans.lat - guess.lat) * Math.PI) / 180;
  const deltaLambda = ((ans.lng - guess.lng) * Math.PI) / 180;

  const a =
    Math.sin(deltaPhi / 2) * Math.sin(deltaPhi / 2) +
    Math.cos(phiGuess) *
      Math.cos(phiAns) *
      Math.sin(deltaLambda / 2) *
      Math.sin(deltaLambda / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

  const dist = earthRadius * c;

  // Under 100m should be a 5K
  // 1500m and over should be 0
  // Very very bad guess is 2000m
  // m = -5000/1900
  const m = -2.63157894737;
  // b = -2000 * m
  const b = 5263.15789474;
  let score = Math.round(m * dist + b);

  if (dist <= 100) {
    score = 5000;
  } else if (dist >= 2000) {
    score = 0;
  }

  return { dist, score };
}

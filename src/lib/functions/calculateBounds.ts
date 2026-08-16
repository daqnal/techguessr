import { LngLat, LngLatBounds } from "maplibre-gl";

export const calculateBounds = (coords: LngLat[]): LngLatBounds => {
  if (coords.length === 0)
    throw Error("Cannot call function with empty coordinate list");

  let minLat = 90;
  let maxLat = -90;
  let minLng = 180;
  let maxLng = -180;

  for (let i = 0; i < coords.length; i++) {
    if (coords[i].lat < minLat) minLat = coords[i].lat;
    if (coords[i].lat > maxLat) maxLat = coords[i].lat;
    if (coords[i].lng < minLng) minLng = coords[i].lng;
    if (coords[i].lng > maxLng) maxLng = coords[i].lng;
  }

  let sw = new LngLat(minLng, minLat);
  let ne = new LngLat(maxLng, maxLat);

  return new LngLatBounds(sw, ne);
};

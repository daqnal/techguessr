import type { Map, Marker } from "maplibre-gl";

export const destroyMap = (
  map: Map | undefined,
  guessMarker?: Marker | undefined,
) => {
  map?.remove();
  map = undefined;
  if (guessMarker) guessMarker = undefined;
};

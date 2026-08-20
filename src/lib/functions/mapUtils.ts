import { mapDarkBlue, mapLightBlue, mapDarkYellow } from "../../consts";
import { LngLatBounds, Marker, type LngLat, type Map } from "maplibre-gl";
import { calculateBounds } from "./calculateBounds";
import { mount } from "svelte";
import PinMarker from "$lib/components/map/PinMarker.svelte";

export const setGuessMarker = (
  lngLat: LngLat,
  map: Map | undefined,
  avatarUrl: string | null,
  guessMarker?: Marker,
  removeOld = true,
) => {
  if (!map) return;

  if (removeOld && guessMarker) {
    guessMarker.remove();
  }
  const el = document.createElement("div");
  el.classList.add(
    "w-8",
    "h-8",
    "rounded-full",
    "border-3",
    "flex",
    "place-content-center",
    "place-items-center",
  );
  el.style.borderColor = mapDarkBlue;

  if (avatarUrl) {
    const img = document.createElement("img");
    img.src = avatarUrl;
    img.alt = "Your guess";
    img.draggable = false;
    img.classList.add("w-7", "h-7", "rounded-full");
    el.appendChild(img);
  } else {
    el.style.backgroundColor = `${mapLightBlue}cc`;
  }

  const marker = new Marker({
    element: el,
    anchor: "center",
  })
    .setLngLat(lngLat)
    .addTo(map!);

  return marker;
};

export const setAnswerMarker = (
  lngLat: LngLat,
  map: Map | undefined,
  answerMarker?: Marker | undefined,
  removeOld = true,
  label?: string,
  colorClass?: string,
  fillClass?: string,
) => {
  if (!map) return;

  if (removeOld) answerMarker?.remove();

  const el = document.createElement("div");

  mount(PinMarker, {
    target: el,
    props: {
      label,
      size: 36,
      colorClass,
      fillClass,
    },
  });

  const marker = new Marker({
    element: el,
    anchor: "bottom",
    offset: label ? [0, 20] : [0, 0],
  })
    .setLngLat(lngLat)
    .addTo(map!);

  return marker;
};

export const setMapLines = (
  guess: LngLat,
  answer: LngLat,
  map: Map | undefined,
  idSuffix = "",
) => {
  const sourceId = `guess-line${idSuffix}`;
  const layerId = `guess-line-layer${sourceId}`;

  if (map?.getLayer(layerId)) map.removeLayer(layerId);
  if (map?.getSource(sourceId)) map.removeSource(sourceId);

  map!.addSource(sourceId, {
    type: "geojson",
    data: {
      type: "Feature",
      properties: {},
      geometry: {
        type: "LineString",
        coordinates: [
          [guess.lng, guess.lat],
          [answer.lng, answer.lat],
        ],
      },
    },
  });

  map!.addLayer({
    id: layerId,
    type: "line",
    source: sourceId,
    layout: {
      "line-cap": "round",
      "line-join": "round",
    },
    paint: {
      "line-color": mapDarkYellow,
      "line-width": 3,
      "line-opacity": 0.9,
    },
  });
};

export const destroyMap = (
  map: Map | undefined,
  markers: (Marker | undefined)[],
) => {
  markers.map((m) => {
    if (m) m.remove();
    m = undefined;
  });

  if (map) map.remove();
  map = undefined;
};

export const zoomToAllPoints = (map: Map | undefined, points: LngLat[]) => {
  let bounds = calculateBounds(points);

  map!.fitBounds(bounds, {
    padding: { top: 48, bottom: 48, left: 48, right: 48 },
    maxZoom: 17,
    duration: 1000,
  });
};

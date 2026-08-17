<script lang="ts">
  import "./map.css";
  import { LngLat, LngLatBounds, Map, Marker } from "maplibre-gl";
  import {
    CAMPUS_BOUNDS,
    CAMPUS_CENTER,
    IMAGE_COUNT,
    MAP_STYLE_URL,
    type GameState,
    type RoundState,
  } from "../../../consts";
  import { onDestroy, onMount } from "svelte";
  import { loadAvatar } from "$lib/functions/loadAvatar";
  import { destroyMap } from "$lib/functions/destroyMap";
  import { calculateBounds } from "$lib/functions/calculateBounds";
  import { House, RotateCcw } from "@lucide/svelte";
  import { supabase } from "$lib/supabaseClient";
  import { toast } from "$lib/components/toast/toast.svelte";

  let map: Map | undefined;
  let mapContainer: HTMLDivElement;
  let points: LngLat[] = [];

  let selectedRoundIndex: number | undefined = $state(undefined);
  let bounds: LngLatBounds = $state(new LngLatBounds());

  let avatarUrl = $state<string | null>(null);

  let game = $state<GameState | null>(null);
  let rounds = $state<RoundState[]>([]);
  let totalScore = $state(0);

  const createResultsMap = () => {
    destroyMap(map);

    map = new Map({
      container: mapContainer,
      style: MAP_STYLE_URL,
      center: CAMPUS_CENTER,
      zoom: 15,
      minZoom: 12,
      maxZoom: 20,
      maxBounds: CAMPUS_BOUNDS,
    });

    map.on("load", async () => {
      avatarUrl = await loadAvatar();

      for (let i = 0; i < IMAGE_COUNT; i++) {
        const answerCoords = new LngLat(
          rounds[i].photo.lng ?? 0,
          rounds[i].photo.lat ?? 0,
        );
        const guessCoords = new LngLat(
          rounds[i].guess?.lng ?? 0,
          rounds[i].guess?.lat ?? 0,
        );

        map!.addSource(`guess-${i}-line`, {
          type: "geojson",
          data: {
            type: "Feature",
            properties: {},
            geometry: {
              type: "LineString",
              coordinates: [
                [guessCoords.lng, guessCoords.lat],
                [answerCoords.lng, answerCoords.lat],
              ],
            },
          },
        });

        map!.addLayer({
          id: `guess-${i}-line-layer`,
          type: "line",
          source: `guess-${i}-line`,
          layout: {
            "line-cap": "round",
            "line-join": "round",
          },
          paint: {
            "line-color": "#7aa2f7",
            "line-width": 3,
            "line-opacity": 1,
          },
        });
      }
    });

    map?.once("idle", () => {
      for (let i = 0; i < IMAGE_COUNT; i++) {
        const answerCoords = new LngLat(
          rounds[i].photo.lng ?? 0,
          rounds[i].photo.lat ?? 0,
        );
        const guessCoords = new LngLat(
          rounds[i].guess?.lng ?? 0,
          rounds[i].guess?.lat ?? 0,
        );

        const guessMarkerEl = document.createElement("div");
        guessMarkerEl.classList.add(
          "w-8",
          "h-8",
          "rounded-full",
          "border-primary",
          "border-3",
          "flex",
          "place-content-center",
          "place-items-center",
        );

        if (avatarUrl) {
          const img = document.createElement("img");
          img.src = avatarUrl;
          img.alt = "Your guess";
          img.draggable = false;
          img.classList.add("w-7", "h-7", "rounded-full");
          guessMarkerEl.appendChild(img);
        } else {
          guessMarkerEl.classList.add("bg-primary/75");
        }

        let guessMarker = new Marker({
          element: guessMarkerEl,
          anchor: "center",
        })
          .setLngLat(guessCoords)
          .addTo(map!);

        const answerMarkerEl = document.createElement("div");
        answerMarkerEl.classList.add(
          "w-8",
          "h-8",
          "rounded-full",
          "border-primary",
          "bg-primary/25",
          "backdrop-blur-md",
          "text-primary-content/60",
          "font-black",
          "border-3",
          "flex",
          "place-content-center",
          "place-items-center",
        );
        answerMarkerEl.textContent = String(i + 1);

        let answerMarker = new Marker({
          element: answerMarkerEl,
          anchor: "center",
        })
          .setLngLat(answerCoords)
          .addTo(map!);
      }
    });

    zoomToAllPoints();
  };

  const zoomToAllPoints = () => {
    bounds = calculateBounds(points);

    map!.fitBounds(bounds, {
      padding: { top: 48, bottom: 48, left: 48, right: 48 },
      maxZoom: 17,
      duration: 1000,
    });
  };

  const focusGuess = (i: number | undefined) => {
    if (selectedRoundIndex === i || i === undefined) {
      selectedRoundIndex = undefined;
      zoomToAllPoints();
    } else {
      selectedRoundIndex = i;

      let answerCoords = new LngLat(
        rounds[i].photo.lng ?? 0,
        rounds[i].photo.lat ?? 0,
      );
      let guessCoords = new LngLat(
        rounds[i].guess?.lng ?? 0,
        rounds[i].guess?.lat ?? 0,
      );

      bounds = new LngLatBounds();
      bounds.extend(answerCoords);
      bounds.extend(guessCoords);
    }

    map!.fitBounds(bounds, {
      padding: { top: 48, bottom: 48, left: 48, right: 48 },
      maxZoom: 17,
      duration: 1000,
    });
  };

  // Get user and upload the game data to the backend
  const uploadGame = async () => {
    if (!game) return;

    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      toast("You are viewing this game while logged out", "info");
      return;
    }

    const { error } = await supabase.from("games").upsert({
      id: game.id,
      user_id: user.id,
      total_score: totalScore,
      round_ids: rounds.map((r) => r.id),
    });

    if (error) toast(error.message, "error");
  };

  onMount(async () => {
    const rawGameData = localStorage.getItem("game");
    if (!rawGameData) {
      toast("No game data found", "error");
      return;
    }

    game = JSON.parse(rawGameData);
    if (game?.rounds && game.totalScore) {
      rounds = game.rounds;
      totalScore = game.totalScore;
    } else {
      toast("Invalid game data", "error");
    }

    // Create an array of all of the guess and answer locations to use for resizing the map
    points = [];
    for (let i = 0; i < IMAGE_COUNT; i++) {
      const answerCoords = new LngLat(
        rounds[i].photo.lng ?? 0,
        rounds[i].photo.lat ?? 0,
      );
      const guessCoords = new LngLat(
        rounds[i].guess?.lng ?? 0,
        rounds[i].guess?.lat ?? 0,
      );

      points.push(guessCoords, answerCoords);
    }

    createResultsMap();

    await uploadGame();
  });
</script>

<div class="flex-1 flex place-content-center place-items-center">
  <div class="w-full max-w-xl flex flex-col gap-2">
    <h1 class="tracking-wide text-4xl font-bold text-center">Results</h1>

    <div class="w-full h-84 border-8 border-base-200 rounded-box overflow-clip">
      <div
        id="map-results-container"
        bind:this={mapContainer}
        class="w-full h-full rounded-box"
      ></div>
    </div>

    <div class="h-24 flex flex-col place-content-center place-items-center">
      {#if selectedRoundIndex === undefined}
        <h3>Total Score</h3>
        <h2 class="text-6xl text-center font-black">{totalScore}</h2>
      {:else}
        <h3>Round {selectedRoundIndex + 1}</h3>
        <h2 class="text-6xl text-center font-black">
          {rounds[selectedRoundIndex].score === 5000
            ? "5K"
            : rounds[selectedRoundIndex].score}
        </h2>
      {/if}
    </div>

    <table class="table bg-base-200 rounded-box shadow-md overflow-hidden">
      <thead>
        <tr>
          <th>Round</th>
          <th>Distance</th>
          <th>Score</th>
        </tr>
      </thead>
      <tbody>
        {#each rounds as round, i}
          <tr
            class="list-row hover:cursor-pointer hover:bg-base-300 {selectedRoundIndex ===
              i && 'bg-base-300'} {round.score === 5000 &&
              'text-yellow-500 font-bold'}"
            onclick={() => focusGuess(i)}
          >
            <th>{i + 1}</th>
            <td>{round.dist}</td>
            <td>{round.score}</td>
          </tr>
        {/each}
      </tbody>

      <!-- <tfoot> -->
      <!--   <tr -->
      <!--     class={selectedRoundIndex !== undefined ? "hover:cursor-pointer" : ""} -->
      <!--     onclick={() => focusGuess(undefined)} -->
      <!--   > -->
      <!--     <th>Total</th> -->
      <!--     <td></td> -->
      <!--     <td class="font-black">{totalScore}</td> -->
      <!--   </tr> -->
      <!-- </tfoot> -->
    </table>

    <div class="flex place-content-between mt-4">
      <a href="/" class="btn btn-primary">
        <House />
        <span>Home</span>
      </a>

      <a href="/play" class="btn btn-success">
        <RotateCcw />
        <span>Run it back</span>
      </a>
    </div>
  </div>
</div>

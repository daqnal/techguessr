<script lang="ts">
  import type { RoundState } from "../../consts";

  let mapContainer: HTMLDivElement;

  interface Props {
    open: boolean;
    rounds: RoundState[];
    totalScore: number;
    onClose?: () => void;
    onPlayAgain?: () => void;
  }

  let { open, rounds, totalScore, onClose, onPlayAgain }: Props = $props();
</script>

<div class="flex-1 flex place-content-center place-items-center">
  <div class="w-full max-w-xl flex flex-col gap-2">
    <div bind:this={mapContainer}></div>

    <table class="table bg-base-200 rounded-box shadow-md">
      <thead>
        <tr>
          <th>Round</th>
          <th>Distance</th>
          <th>Score</th>
        </tr>
      </thead>
      <tbody>
        {#each rounds as round, i}
          <tr class="list-row">
            <th>{i + 1}</th>
            <td>{round.dist}</td>
            <td>{round.score}</td>
          </tr>
        {/each}
      </tbody>
    </table>
  </div>
</div>

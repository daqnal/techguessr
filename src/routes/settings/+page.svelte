<script lang="ts">
  import SettingsOption from "./SettingsOption.svelte";

  const settings = {
    theme: "tokyonight",
    unitSystem: "metric",
  };
</script>

<div class="flex-1 flex place-content-center p-2">
  <div
    class="w-full flex-1 max-w-xl flex flex-col p-2 gap-4 overflow-y-auto rounded-box"
  >
    <h1 class="tracking-wider text-4xl font-bold text-center mt-4">Settings</h1>

    <SettingsOption name="Theme">
      <select class="select">
        <option value="tokyonight">Tokyo Night</option>
      </select>
    </SettingsOption>
  </div>
</div>

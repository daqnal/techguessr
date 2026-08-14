<script lang="ts">
  import { ChevronDown } from "@lucide/svelte";
  import { themes, type Theme } from "../../consts";
  import SettingsOption from "./SettingsOption.svelte";
  import { onMount } from "svelte";

  const defaultSettings = {
    theme: "tokyonight",
    unitSystem: "metric",
  };

  let currTheme: Theme = $state({ id: "loading", name: "Loading" });

  const handleThemeChange = (newTheme: Theme) => {
    localStorage.setItem("themeId", newTheme.id);
    localStorage.setItem("themeName", newTheme.name);
    currTheme = newTheme;
  };

  onMount(() => {
    currTheme.id = localStorage.getItem("themeId")!;
    currTheme.name = localStorage.getItem("themeName")!;
  });
</script>

<div class="flex-1 flex place-content-center place-items-center p-2">
  <div class="w-full max-w-xl flex flex-col gap-4">
    <h1 class="tracking-wider text-4xl font-bold text-center mt-4">Settings</h1>

    <div
      class="flex max-h-4/5 flex-col gap-4 bg-base-200 rounded-box overflow-y-auto"
    >
      <SettingsOption name="Theme">
        <div class="dropdown dropdown-end">
          <div tabindex="0" role="button" class="btn btn-soft">
            <span>{currTheme.name}</span>
            <ChevronDown size={12} />
          </div>

          <ul
            tabindex="-1"
            class="dropdown-content bg-base-300 rounded-box z-1 w-52 p-2 shadow-2xl flex flex-col gap-1"
          >
            {#each themes as theme}
              <li>
                <input
                  type="radio"
                  name="theme-dropdown"
                  class="theme-controller w-full btn btn-sm btn-block btn-ghost justify-start"
                  aria-label={theme.name}
                  value={theme.id}
                  onclick={() => handleThemeChange(theme)}
                  checked={currTheme.id === theme.id}
                />
              </li>
            {/each}
          </ul>
        </div>
      </SettingsOption>

      <SettingsOption name="Unit System">
        <div class="join">
          <input
            type="radio"
            name="unit-join"
            class="join-item btn btn-soft"
            aria-label="Metric"
          />
          <input
            type="radio"
            name="unit-join"
            class="join-item btn btn-soft"
            aria-label="Imperial"
          />
        </div>
      </SettingsOption>

      <div class="text-center text-sm mb-4">
        <p>Looking for <a href="/auth" class="link">Account Settings</a>?</p>
      </div>
    </div>
  </div>
</div>

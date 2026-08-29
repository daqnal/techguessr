<script lang="ts">
  import { toast } from "$lib/components/toast/toast.svelte";
  import { supabase } from "$lib/supabaseClient";
  import SettingsOption from "./SettingsOption.svelte";
  import { useTheme } from "svelte-themes";
  import { userState } from "$lib/state.svelte";

  const theme = useTheme();

  const handleSaveSettings = async () => {
    const {
      data: { user },
    } = await supabase.auth.getUser();
    if (!user) {
      toast("User is not logged in", "error");
      return;
    }

    const { error } = await supabase.from("settings").upsert({
      user_id: user.id,
      theme: theme.theme,
      unit_system: userState.unitSystem,
      grid_enabled: userState.gridEnabled,
      grid_speed: userState.gridSpeed,
      updated_at: new Date().toISOString(),
    });

    if (error) {
      toast(error.message, "error");
      return;
    } else {
      toast("Settings saved successfully", "success");
    }
  };
</script>

<div class="flex-1 flex place-content-center place-items-center p-2">
  <div class="w-full max-w-xl flex flex-col gap-4">
    <h1
      class="tracking-wider text-4xl font-bold text-center mt-4 text-shadow-lg"
    >
      Settings
    </h1>

    <div
      class="flex max-h-4/5 flex-col gap-4 bg-base-200 border-2 border-primary/50 rounded-box overflow-y-auto p-4 shadow-2xl"
    >
      <SettingsOption name="Theme">
        <div
          class="w-full max-h-48 overflow-y-scroll join join-vertical rounded-box"
        >
          {#each theme.themes as name (name)}
            <input
              type="radio"
              name="theme-controller"
              class="btn btn-soft join-item"
              aria-label={name.charAt(0).toUpperCase() + name.substring(1)}
              checked={theme.theme === name}
              onclick={() => (theme.theme = name)}
            />
          {/each}
        </div>
      </SettingsOption>

      <hr class="text-primary-content/20" />

      <SettingsOption name="Unit System">
        <div class="w-full join">
          <input
            type="radio"
            name="unit-join"
            class="w-1/2 join-item btn btn-soft"
            aria-label="Metric"
            checked={userState.unitSystem === "metric"}
            onclick={() => (userState.unitSystem = "metric")}
          />
          <input
            type="radio"
            name="unit-join"
            class="w-1/2 join-item btn btn-soft"
            aria-label="Imperial"
            checked={userState.unitSystem === "imperial"}
            onclick={() => (userState.unitSystem = "imperial")}
          />
        </div>
      </SettingsOption>

      <hr class="text-primary-content/20" />

      <SettingsOption name="Grid Background">
        <label class="label">
          <span>{userState.gridEnabled ? "Enabled" : "Disabled"}</span>
          <input
            type="checkbox"
            class="toggle toggle-primary"
            bind:checked={userState.gridEnabled}
          />
        </label>
      </SettingsOption>

      <SettingsOption name="Grid Speed">
        <div class="w-full">
          <input
            type="range"
            min={0}
            max={0.6}
            step={0.15}
            class="range range-primary"
            disabled={!userState.gridEnabled}
            bind:value={userState.gridSpeed}
            onchange={() => console.log(userState.loggedIn)}
          />
          <div class="flex justify-between mt-2 text-xs opacity-60">
            <span>Static</span>
            <span>Slow</span>
            <span>Medium</span>
            <span>Fast</span>
            <span>Zoom</span>
          </div>
        </div>
      </SettingsOption>

      {#if userState.loggedIn}
        <div class="flex place-content-end mt-4">
          <button class="btn btn-success" onclick={handleSaveSettings}
            >Save settings</button
          >
        </div>
      {/if}
    </div>
  </div>
</div>

<script lang="ts">
  import { toast } from "$lib/components/toast/toast.svelte";
  import { supabase } from "$lib/supabaseClient";
  import { themes, type Theme } from "../../consts";
  import SettingsOption from "./SettingsOption.svelte";
  import { onMount } from "svelte";

  let loggedIn = $state(false);

  let currTheme: Theme = $state({ id: "tokyonight", name: "Tokyo Night" });
  let currUnitSystem: string = $state("metric");

  const handleThemeChange = (newTheme: Theme) => {
    localStorage.setItem("themeId", newTheme.id);
    localStorage.setItem("themeName", newTheme.name);
    currTheme = newTheme;
  };

  const handleUnitSystemChange = (newUnitSystem: string) => {
    localStorage.setItem("unitSystem", newUnitSystem);
    currUnitSystem = newUnitSystem;
  };

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
      theme: currTheme.id,
      unit_system: currUnitSystem,
      updated_at: new Date().toISOString(),
    });

    if (error) {
      toast(error.message, "error");
      return;
    } else {
      toast("Settings saved successfully", "success");
    }
  };

  onMount(async () => {
    // Check if logged in
    const localStorageLoggedIn = localStorage.getItem("loggedIn");
    loggedIn = localStorageLoggedIn === "true";

    // Only load from backend if logged in, else load from localStorage
    if (loggedIn) {
      const {
        data: { user },
      } = await supabase.auth.getUser();
      if (!user) {
        toast("User is not logged in", "error");
        return;
      }

      const { error, data } = await supabase
        .from("settings")
        .select("theme, unit_system")
        .eq("user_id", user.id)
        .single();

      if (error) {
        toast(error.message, "error");
        return;
      }

      // Set theme
      const matchedTheme: Theme | undefined = themes.find((el) => {
        if (el.id == data.theme) return el;
      });

      currTheme.id = matchedTheme?.id ?? currTheme.id;
      currTheme.name = matchedTheme?.name ?? currTheme.name;

      localStorage.setItem("themeId", currTheme.id);
      localStorage.setItem("themeName", currTheme.name);

      // Set unit system
      currUnitSystem = data.unit_system;
      localStorage.setItem("unitSystem", currUnitSystem);
    } else {
      // Load theme
      const themeId = localStorage.getItem("themeId")!;
      const themeName = localStorage.getItem("themeName")!;
      if (!themeId || !themeName) {
        localStorage.setItem("themeId", themes[0].id);
        localStorage.setItem("themeName", themes[0].name);
      }

      currTheme.id = themes[0].id;
      currTheme.name = themes[0].name;

      // Load unit system
      const unitSystem = localStorage.getItem("unitSystem");
      if (unitSystem) {
        currUnitSystem = unitSystem;
      } else {
        currUnitSystem = "metric";
        localStorage.setItem("unitSystem", "metric");
      }
    }
  });
</script>

<div class="flex-1 flex place-content-center place-items-center p-2">
  <div class="w-full max-w-xl flex flex-col gap-4">
    <h1 class="tracking-wider text-4xl font-bold text-center mt-4">Settings</h1>

    <div
      class="flex max-h-4/5 flex-col gap-4 bg-base-200 rounded-box overflow-y-auto p-4"
    >
      <SettingsOption name="Theme">
        <div
          class="w-full max-h-48 overflow-y-scroll join join-vertical rounded-box"
        >
          {#each themes as theme}
            <input
              type="radio"
              name="theme-controller"
              class="btn btn-soft theme-controller join-item"
              aria-label={theme.name}
              value={theme.id}
              checked={theme.id === currTheme.id}
              onclick={() => handleThemeChange(theme)}
            />
          {/each}
        </div>
      </SettingsOption>

      <SettingsOption name="Unit System">
        <div class="w-full join">
          <input
            type="radio"
            name="unit-join"
            class="w-1/2 join-item btn btn-soft"
            aria-label="Metric"
            checked={currUnitSystem === "metric"}
            onclick={() => handleUnitSystemChange("metric")}
          />
          <input
            type="radio"
            name="unit-join"
            class="w-1/2 join-item btn btn-soft"
            aria-label="Imperial"
            checked={currUnitSystem === "imperial"}
            onclick={() => handleUnitSystemChange("imperial")}
          />
        </div>
      </SettingsOption>

      {#if loggedIn}
        <div class="flex place-content-end mt-4">
          <button class="btn btn-success" onclick={handleSaveSettings}
            >Save settings</button
          >
        </div>
      {/if}
    </div>
  </div>
</div>

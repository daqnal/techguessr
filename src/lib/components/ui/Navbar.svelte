<script lang="ts">
  import { supabase } from "../../supabaseClient";
  import { Settings, User } from "@lucide/svelte";
  import Avatar from "../auth/Avatar.svelte";
  import { onMount } from "svelte";
  import { page } from "$app/state";

  let loggedIn: boolean = $state(false);
  let avatarPath = $state<string | null>(null);

  async function loadProfile() {
    const {
      data: { user },
    } = await supabase.auth.getUser();
    loggedIn = !!user;
    if (!user) {
      avatarPath = null;
      return;
    }

    const { data } = await supabase
      .from("profiles")
      .select("avatar_url")
      .eq("id", user.id)
      .single();

    avatarPath = data?.avatar_url ?? null;
  }

  onMount(() => {
    loadProfile();

    const { data } = supabase.auth.onAuthStateChange(() => {
      loadProfile();
    });

    return () => data.subscription.unsubscribe();
  });
</script>

<nav class="flex justify-between place-items-center p-2 bg-base-300">
  <div class="h-fit">
    <a href="/" class="btn btn-ghost text-lg font-black">TechGuessr</a>
  </div>
  <div>
    <ul class="menu menu-horizontal bg-base-200 rounded-box p-0">
      <li class={page.url.pathname === "/" ? "menu-disabled" : ""}>
        <a href="/">Home</a>
      </li>
      <li class={page.url.pathname === "/play" ? "menu-disabled" : ""}>
        <a href="/play">Play</a>
      </li>
    </ul>
  </div>
  <div class="flex gap-2 pr-2">
    <a href="/settings" class="btn btn-primary btn-circle btn-sm">
      <Settings size={16} />
    </a>

    {#if loggedIn}
      <Avatar {supabase} upload={false} url={avatarPath ?? undefined} />
    {:else}
      <a href="/auth" class="btn btn-primary btn-circle btn-sm">
        <User size={16} />
      </a>
    {/if}
  </div>
</nav>

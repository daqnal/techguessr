<script lang="ts">
  import { onMount } from "svelte";
  import type { AuthSession } from "@supabase/supabase-js";
  import { supabase } from "../../supabaseClient";

  interface Props {
    session: AuthSession;
  }

  let { session }: Props = $props();

  let loading = $state(false);
  let email = $state<string | null>(null);
  let username = $state<string | null>(null);

  onMount(() => {
    getProfile();
  });

  const getProfile = async () => {
    try {
      loading = true;
      const { user } = session;

      const { data, error, status } = await supabase
        .from("profiles")
        .select("username, avatar_url")
        .eq("id", user.id)
        .single();

      console.log(error);

      if (error && status !== 406) throw error;

      if (data) {
        username = data.username;
      }
    } catch (error) {
      if (error instanceof Error) {
        alert(error.message);
      }
    } finally {
      loading = false;
    }
  };

  const updateProfile = async () => {
    try {
      loading = true;
      const { user } = session;

      const updates = {
        id: user.id,
        username,
        updated_at: new Date().toISOString(),
      };

      const { error } = await supabase.from("profiles").upsert(updates);

      if (error) {
        throw error;
      }
    } catch (error) {
      if (error instanceof Error) {
        alert(error.message);
      }
    } finally {
      loading = false;
    }
  };

  const handleSignout = async () => {
    loading = true;
    const { error } = await supabase.auth.signOut();
    loading = false;
  };
</script>

<svelte:head>
  <title>TechGuessr - Account</title>
</svelte:head>

<div class="w-full h-full flex place-content-center place-items-center">
  <div
    class="card w-full max-w-84 bg-base-200 shadow-lg flex flex-col gap-4 p-4"
    aria-live="polite"
  >
    <h1 class="text-xl text-center">Account Settings</h1>
    {#if loading}
      <div class="w-full flex-1 flex place-content-center place-items-center">
        <span class="loading loading-spinner loading-lg"></span>
      </div>
    {:else}
      <form
        class="flex flex-col gap-4"
        onsubmit={(e) => {
          e.preventDefault();
          updateProfile();
        }}
      >
        <p class="font-bold text-center">{session.user.email}</p>

        <div class="flex gap-2 place-items-center">
          <label for="username"> Username</label>
          <input
            id="username"
            class="input"
            type="text"
            placeholder="Username"
            bind:value={username}
          />
        </div>

        <div class="flex gap-2">
          <button
            type="submit"
            class="btn btn-primary flex-1/2"
            disabled={loading}
          >
            Update
          </button>
          <button
            type="button"
            class="btn btn-error flex-1/2"
            onclick={() => handleSignout()}
          >
            Sign Out
          </button>
        </div>
      </form>
    {/if}
  </div>
</div>

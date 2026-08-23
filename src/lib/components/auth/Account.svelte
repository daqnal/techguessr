<script lang="ts">
  import { onMount } from "svelte";
  import type { AuthSession } from "@supabase/supabase-js";
  import { supabase } from "../../supabaseClient";
  import Avatar from "./Avatar.svelte";
  import { toast } from "../toast/toast.svelte";

  interface Props {
    session: AuthSession;
  }

  let { session }: Props = $props();

  let loading = $state(false);
  let username = $state<string | null>(null);
  let avatarUrl: string = $state("");

  onMount(() => {
    getProfile();
  });

  const getProfile = async () => {
    loading = true;
    const { user } = session;

    const { data, error } = await supabase
      .from("profiles")
      .select("username, avatar_url")
      .eq("id", user.id)
      .single();

    if (error) {
      toast(error.message, "error");
      loading = false;
      return;
    }

    if (data) {
      username = data.username;
      avatarUrl = data.avatar_url;
    }

    loading = false;
  };

  const updateProfile = async () => {
    loading = true;
    const { user } = session;

    const updates = {
      id: user.id,
      username,
      updated_at: new Date().toISOString(),
    };

    const { error } = await supabase.from("profiles").upsert(updates);

    if (error) {
      toast(error.message, "error");
    } else {
      toast("Profile updated successfully", "success");
    }
    loading = false;
  };

  const handleSignout = async () => {
    loading = true;
    const { error } = await supabase.auth.signOut();
    loading = false;
    if (error) {
      toast("Error signing out", "error");
    } else {
      toast("Signed out successfully", "success");
      localStorage.setItem("loggedIn", "false");
    }
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
    <h1 class="text-2xl font-bold text-center">Account</h1>
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
        <Avatar
          {supabase}
          bind:url={avatarUrl}
          onupload={() => {
            updateProfile();
          }}
        />

        <div class="flex flex-col gap-2 place-items-center">
          <label for="email" class="floating-label w-full">
            <input
              id="email"
              class="input"
              disabled
              type="text"
              value={session.user.email}
            />
            <span>Email</span>
          </label>

          <label for="username" class="floating-label w-full">
            <input
              id="username"
              class="input"
              type="text"
              placeholder="Username"
              pattern="[A-Za-z][A-Za-z0-9\-]*"
              bind:value={username}
            />
            <span>Username</span>
          </label>
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

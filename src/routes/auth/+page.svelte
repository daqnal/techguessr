<script lang="ts">
  import { onMount } from "svelte";
  import { supabase } from "$lib/supabaseClient";
  import type { AuthSession } from "@supabase/supabase-js";
  import Auth from "$lib/components/auth/Auth.svelte";
  import Account from "$lib/components/auth/Account.svelte";

  let session = $state<AuthSession | null>(null);
  let loading: boolean = $state(true);

  onMount(() => {
    loading = true;
    supabase.auth.getSession().then(({ data }) => {
      session = data.session;
    });

    supabase.auth.onAuthStateChange((_event, _session) => {
      session = _session;
    });

    loading = false;
  });
</script>

<div class="w-full flex-1 px-4">
  {#if loading}
    <div class="w-full h-full flex place-content-center place-items-center">
      <span class="loading loading-spinner loading-md"></span>
    </div>
  {:else if !session}
    <Auth />
  {:else}
    <Account {session} />
  {/if}
</div>

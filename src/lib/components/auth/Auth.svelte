<script lang="ts">
  import { supabase } from "../../supabaseClient";

  let loading = $state(false);
  let email = $state("");

  const handleLogin = async () => {
    try {
      loading = true;
      const { error } = await supabase.auth.signInWithOtp({ email });
      if (error) throw error;
      alert("Check your email for login link!");
    } catch (error) {
      if (error instanceof Error) {
        alert(error.message);
      }
    } finally {
      loading = false;
    }
  };
</script>

<div class="card">
  <div class="" aria-live="polite">
    <h1 class="">Supabase + Svelte</h1>
    <p class="">Sign in via magic link with your email below</p>
    <form
      class=""
      onsubmit={(e) => {
        e.preventDefault();
        handleLogin();
      }}
    >
      <div>
        <label for="email">Email</label>
        <input
          id="email"
          class="input validator"
          type="email"
          placeholder="Your email"
          bind:value={email}
        />
      </div>
      <div>
        <button
          type="submit"
          class="button block"
          aria-live="polite"
          disabled={loading}
        >
          <span>{loading ? "Loading" : "Send magic link"}</span>
        </button>
      </div>
    </form>
  </div>
</div>

<script lang="ts">
  import { supabase } from "../../supabaseClient";

  let authType: string = $state("login");
  let loginLoading = $state(false);
  let signupLoading = $state(false);
  let email = $state("");
  let password = $state("");

  const handleLogin = async () => {
    try {
      loginLoading = true;
      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });
      if (error) throw error;
      alert("Check your email for login link!");
    } catch (error) {
      if (error instanceof Error) {
        alert(error.message);
      }
    } finally {
      loginLoading = false;
    }
  };

  const handleSignup = async () => {
    try {
      signupLoading = true;
      const { error } = await supabase.auth.signUp({ email, password });
      if (error) throw error;
    } catch (error) {
      if (error instanceof Error) {
        alert(error.message);
      }
    } finally {
      signupLoading = false;
    }
  };
</script>

<div class="w-full h-full flex place-content-center place-items-center">
  <div
    class="card w-full max-w-84 bg-base-200 shadow-lg flex flex-col gap-4 p-4"
    aria-live="polite"
  >
    <h1 class="text-xl text-center">Login or Signup</h1>
    <form
      class="flex flex-col gap-4"
      onsubmit={(e) => {
        e.preventDefault();
        if (authType === "login") {
          handleLogin();
        } else {
          handleSignup();
        }
      }}
    >
      <div class="w-full flex tabs tabs-sm tabs-box">
        <input
          defaultChecked
          type="radio"
          name="auth_tabs"
          class="tab flex-1/2"
          aria-label="Login"
          onclick={() => (authType = "login")}
        />
        <input
          type="radio"
          name="auth_tabs"
          class="tab flex-1/2"
          aria-label="Signup"
          onclick={() => (authType = "signup")}
        />
      </div>
      <input
        required
        id="email"
        class="input validator w-full"
        type="email"
        placeholder="Email"
        bind:value={email}
      />
      <input
        required
        id="password"
        class="input validator w-full"
        type="password"
        placeholder="Password"
        minlength="8"
        bind:value={password}
      />

      {#if authType === "login"}
        <button
          type="submit"
          class="btn btn-primary w-full"
          aria-live="polite"
          disabled={loginLoading}
        >
          {#if loginLoading}
            <span class="loading loading-spinner loading-md"></span>
          {:else}
            <span>Login</span>
          {/if}
        </button>
      {:else}
        <button
          type="submit"
          class="btn btn-primary w-full"
          aria-live="polite"
          disabled={signupLoading}
        >
          {#if signupLoading}
            <span class="loading loading-spinner loading-md"></span>
          {:else}
            <span>Signup</span>
          {/if}
        </button>
      {/if}
    </form>
  </div>
</div>

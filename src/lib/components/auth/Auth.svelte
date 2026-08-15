<script lang="ts">
  import { supabase } from "../../supabaseClient";

  let authType: string = $state("login");
  let loginLoading = $state(false);
  let signupLoading = $state(false);
  let email = $state("");
  let password = $state("");
  let authError: string | null = $state(null);

  const handleLogin = async () => {
    try {
      loginLoading = true;
      authError = null;

      const { error } = await supabase.auth.signInWithPassword({
        email,
        password,
      });
      if (error) throw error;
      localStorage.setItem("loggedIn", "true");
    } catch (error) {
      if (error instanceof Error) {
        authError = error.message;
      }
    } finally {
      loginLoading = false;
    }
  };

  const handleSignup = async () => {
    try {
      signupLoading = true;
      authError = null;

      const { error } = await supabase.auth.signUp({ email, password });
      if (error) throw error;
    } catch (error) {
      if (error instanceof Error) {
        authError = error.message;
      }
    } finally {
      signupLoading = false;
    }
  };
</script>

<svelte:head>
  <title>TechGuessr - Login</title>
</svelte:head>

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
        name="email"
        class="input validator w-full"
        type="email"
        placeholder="Email"
        bind:value={email}
      />
      <input
        required
        id="password"
        name="password"
        class="input validator w-full"
        type="password"
        placeholder="Password"
        minlength="8"
        bind:value={password}
      />

      {#if authError}
        <div role="alert" class="alert alert-error">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-6 w-6 shrink-0 stroke-current"
            fill="none"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
            />
          </svg>
          <span>{authError}</span>
        </div>
      {/if}

      {#if authType === "login"}
        <button
          type="submit"
          name="login"
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
          name="signup"
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

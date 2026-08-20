<script lang="ts">
  import { supabase } from "../../supabaseClient";
  import { toast } from "../toast/toast.svelte";

  let authType: string = $state("login");
  let loginLoading = $state(false);
  let signupLoading = $state(false);
  let email = $state("");
  let username = $state("");
  let password = $state("");

  const handleLogin = async () => {
    loginLoading = true;

    const { error } = await supabase.auth.signInWithPassword({
      email,
      password,
    });

    if (error) {
      toast(error.message, "error");
      return;
    }

    localStorage.setItem("loggedIn", "true");
    loginLoading = false;
  };

  const handleSignup = async () => {
    signupLoading = true;

    const { data, error } = await supabase.auth.signUp({ email, password });

    if (error) {
      toast(error.message, "error");
      signupLoading = false;
      return;
    } else if (!data.user?.id) {
      toast("Failed to retrieve id of new user", "error");
      signupLoading = false;
      return;
    }

    const { error: usernameError } = await supabase
      .from("profiles")
      .update({ username: username })
      .eq("id", data.user.id);

    if (usernameError) {
      toast(usernameError.message, "error");
    } else {
      toast("Account created successfully", "success");
    }
    signupLoading = false;
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

      {#if authType === "signup"}
        <input
          required
          id="username"
          name="username"
          class="input validator w-full"
          type="text"
          placeholder="Username"
          bind:value={username}
        />
      {/if}
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

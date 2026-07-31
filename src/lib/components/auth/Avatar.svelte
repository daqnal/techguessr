<script lang="ts">
  import { User } from "@lucide/svelte";
  import type { SupabaseClient } from "@supabase/supabase-js";

  interface Props {
    size?: number;
    url?: string;
    supabase: SupabaseClient;
    upload?: boolean;
    onupload?: () => void;
  }
  let {
    size = 32,
    url = $bindable(),
    supabase,
    upload = true,
    onupload,
  }: Props = $props();

  let avatarUrl: string | null = $state(null);
  let uploading = $state(false);
  let files: FileList | undefined = $state();

  const downloadImage = async (path: string) => {
    try {
      const { data, error } = await supabase.storage
        .from("avatars")
        .download(path);

      if (error) {
        throw error;
      }

      const url = URL.createObjectURL(data);
      avatarUrl = url;
    } catch (error) {
      if (error instanceof Error) {
        console.log("Error downloading image: ", error.message);
      }
    }
  };

  const uploadAvatar = async () => {
    try {
      uploading = true;

      const {
        data: { user },
      } = await supabase.auth.getUser();

      if (!user) throw new Error("Not logged in");

      if (!files || files.length === 0) {
        throw new Error("You must select an image to upload.");
      }

      const file = files[0];
      const fileExt = file.name.split(".").pop();
      const filePath = `${user.id}/${Date.now()}.${fileExt}`;

      const { error: uploadError } = await supabase.storage
        .from("avatars")
        .upload(filePath, file, { upsert: true });

      if (uploadError) {
        throw uploadError;
      }

      const { error: dbError } = await supabase.from("profiles").upsert({
        id: user.id,
        avatar_url: filePath,
        updated_at: new Date().toISOString(),
      });

      if (dbError) {
        throw dbError;
      }

      url = filePath;
      setTimeout(() => {
        onupload?.();
      }, 100);
    } catch (error) {
      if (error instanceof Error) {
        alert(error.message);
      }
    } finally {
      uploading = false;
    }
  };

  $effect(() => {
    if (url) downloadImage(url);
  });
</script>

<div class="flex flex-col place-content-center place-items-center gap-4">
  {#if upload}
    {#if avatarUrl}
      <img
        src={avatarUrl}
        alt={avatarUrl ? "Avatar" : "No image"}
        class={`w-${size} h-${size}`}
      />
    {:else}
      <div
        class={`bg-primary-content w-${size} h-${size} rounded-full flex place-content-center place-items-center`}
      >
        <span class="text-primary cursor-default pointer-events-none">
          <User {size} />
        </span>
      </div>
    {/if}
  {:else}
    <a href="/auth" class="btn btn-primary btn-sm btn-circle">
      <User {size} />
    </a>
  {/if}

  {#if upload}
    <input type="hidden" name="avatarUrl" value={url} />

    <div>
      <label class="btn btn-xs btn-outline" for="single">
        {uploading ? "Uploading ..." : "Upload"}
      </label>
      <input
        style="visibility: hidden; position:absolute;"
        type="file"
        id="single"
        accept="image/*"
        bind:files
        onchange={uploadAvatar}
        disabled={uploading}
      />
    </div>
  {/if}
</div>

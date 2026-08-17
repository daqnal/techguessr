<script lang="ts">
  import { User } from "@lucide/svelte";
  import type { SupabaseClient } from "@supabase/supabase-js";

  interface Props {
    url?: string;
    supabase: SupabaseClient;
    upload?: boolean;
    onupload?: () => void;
  }
  let {
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
      <img src={avatarUrl} alt="User's avatar" class="w-40 h-40 rounded-full" />
    {:else}
      <div
        class="bg-primary-content w-32 h-32 rounded-full flex place-content-center place-items-center"
      >
        <span class="text-primary cursor-default pointer-events-none">
          <User size={16} />
        </span>
      </div>
    {/if}
  {:else if avatarUrl}
    <a
      href="/auth"
      class="btn btn-primary btn-circle w-8 h-8 rounded-full p-0.5"
    >
      <img
        src={avatarUrl}
        alt="User's avatar"
        class="w-full h-full rounded-full"
      />
    </a>
  {:else}
    <a href="/auth" class="btn btn-primary btn-sm btn-circle tooltip">
      <User size={16} />
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

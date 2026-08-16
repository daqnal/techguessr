import { toast } from "$lib/components/toast/toast.svelte";
import { supabase } from "$lib/supabaseClient";

export const loadAvatar = async () => {
  const {
    data: { user },
  } = await supabase.auth.getUser();
  if (!user) {
    return null;
  }

  const { data: profile } = await supabase
    .from("profiles")
    .select("avatar_url")
    .eq("id", user.id)
    .single();

  const { data, error } = await supabase.storage
    .from("avatars")
    .download(profile?.avatar_url);

  if (error) {
    toast(error.message, "error");
    return null;
  } else {
    const url = URL.createObjectURL(data);
    return url;
  }
};

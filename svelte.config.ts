import adapter from "@sveltejs/adapter-cloudflare";

/** @type {import('@sveltejs/kit').Config} */
const config = {
  kit: {
    adapter: adapter(),
    csp: {
      mode: "auto",
      directives: {
        "worker-src": ["self", "blob:"],
      },
    },
  },
};

export default config;

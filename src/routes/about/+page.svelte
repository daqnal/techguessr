<script>
  import SplitText from "$lib/components/sveltebits/SplitText.svelte";
</script>

<svelte:head>
  <title>TechGuessr - About</title>
</svelte:head>

<div class="flex-1 flex flex-col place-items-center overflow-y-auto px-4">
  <div class="max-w-200 h-full">
    <article class="prose mt-8 lg:mt-16 p-4 rounded-box bg-base-300">
      <h1 class="text-5xl text-center -mb-12">
        <SplitText text="About" delay={100} />
        <SplitText text="TechGuessr 🗺️" delay={100} />
      </h1>

      <h2>What is TechGuessr?</h2>
      <p>
        TechGuessr is a map game similar to GeoGuessr, but localized to the
        Georgia Tech campus in Atlanta.
      </p>
      <p>
        Each game you receive 5 photos taken by someone on campus, and you have
        to guess where each one is by selecting a location on the map.
      </p>
      <p>
        The closer you are, the more points you are awarded. A perfect round
        gives you 5,000 points, so a perfect game is 25,000 points. Do you dare
        to become the top campus knower?
      </p>

      <h2>Can I submit photos to the game?</h2>
      <p>
        Yes, please submit photos of locations you've taken on campus. However,
        to upload photos you must create an account first. Click <a href="/auth"
          >here</a
        > to create an account or login.
      </p>
      <p>
        Ensure that the photos you upload comply with the rules, as described
        below.
      </p>

      <h2>What are the rules for submitting images?</h2>

      <ul>
        <li>The photo must have been taken on campus</li>
        <li>
          There must be a recognizable feature that is theoretically
          pinpointable (don't submit a close-up of a white wall)
        </li>
        <li>
          Coordinates must be set to <b>where the photographer was standing</b>,
          not where the focus of the photo is
        </li>
        <li>
          The following types of photos are not allowed and will be removed:
          <ul>
            <li>Edited photos that obscure the location</li>
            <li>Photos with inaccurate or unknown coordinates</li>
            <li>NSFW content (instant ban)</li>
          </ul>
        </li>
      </ul>

      <p>
        Remember that <b>every photo submitted can be viewed publicly.</b> All photos
        will be reviewed by an admin prior to inclusion in the game. Any photo can
        be denied or deleted for no reason.
      </p>

      <h2>Can I contribute to development?</h2>

      <p>
        TechGuessr is free and open source, and we are always accepting
        non-vibed PR's.
      </p>
      <p>
        You can find the source code and contribution guidelines at the <a
          href="https://github.com/daqnal/techguessr"
          target="_blank">GitHub</a
        >.
      </p>
    </article>
    <div class="w-full h-16"></div>
  </div>
</div>

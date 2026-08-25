# Todo List

## Features

- [ ] Give games a url so that results can be shared
- [ ] Make usernames unique
- [x] Unit system functionality
- [ ] Report images
- [x] View location on upload

## UI/UX

- [x] Round counter
- [ ] **Media Queries**
- [x] Redo home page
- [x] Make image preview fill available space
- [x] Close round score modal to see photo again
- [x] Make map opening less annoying
- [ ] Confetti on 5K
- [ ] More confetti on 25K
- [ ] Animations 🤩
- [ ] Show building names on map

## Bugs

- [x] Refresh on results messes up map markers
- [x] Theme switch requires refresh
- [ ] Drag and zoom outside of image
- [x] Don't show images that the same user uploaded
- [x] Use preset home page photos at optimized resolution
- [x] Map doesn't show up when logged in
- [x] Profile not created on account creation
- [ ] Username does not show up on signup until refresh
- [x] Failed login attempt loads infinitely
- [x] Settings and profile rows are not created on signup
- [x] Marker not placed if image does have GPS data
- [x] Buggy on first map click
- [x] Neither map nor image loads on refresh

## Security

- [ ] Limit uploads per user
- [x] Limit account creations per hour (done by default)
- [x] Show submission rules on first upload

## Refactoring

- [ ] Make the zoomable and pannable photo on /play its own component
- [ ] Consolidate map.css files into one file
- [ ] Use `const funcName = () => {...}` notation consistently across codebase
- [ ] Move independent function files to the route that they are used in, unless used in multiple places
- [ ] Totally redo the Avatar component
- [ ] Move bulky functions outside of big components like `/game`, `/game/results`, and `/submit`
- [ ] Have a user "session" stored so not making a bunch of calls to backend to check user's details
- [x] Theme constants are obsolete

## Future Release

- Difficulty rating for each image
- Timer on each round
- Leaderboard

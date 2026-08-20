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
- [ ] Don't show images that the same user uploaded

## Security

- [ ] Limit uploads per user
- [x] Limit account creations per hour (done by default)
- [x] Show submission rules on first upload

## Refactoring

- [ ] Use `const funcName = () => {...}` notation consistently across codebase
- [ ] Move independent function files to the route that they are used in, unless used in multiple places
- [ ] Totally redo the Avatar component
- [ ] Move bulky functions outside of big components like `/game`, `/game/results`, and `/submit`
- [ ] Have a user "session" stored so not making a bunch of calls to backend to check user's details
- [ ] Theme constants are obsolete

## Future Release

- Difficulty rating for each image
- Timer on each round
- Leaderboard

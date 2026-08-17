# Todo List

## Features

- [ ] Give games a url so that results can be shared
- [ ] Make usernames unique
- [ ] Unit system functionality

## UI/UX

- [x] Round counter
- [ ] **Media Queries**
- [ ] Redo home page
- [ ] Close round score modal to see photo again
- [ ] Make map opening less annoying
- [ ] Confetti on 5K
- [ ] More confetti on 25K

## Bugs

- [ ] Refresh on results messes up map markers
- [ ] Theme switch requires refresh
- [ ] Drag and zoom outside of image

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

## Future Release

- Difficulty rating for each image
- Animations 🤩
- Timer on each round
- Leaderboard

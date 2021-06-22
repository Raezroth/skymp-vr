# skymp5-front

This repo contains GUI demo for Skyrim Multiplayer. Original chat interface by **davinchi59** has been ported.

* `npm run build` is used to build the project.
* `npm run watch` is used to start live-reload server.

If you start a live-reload server and Skyrim Multiplayer server on the same machine, then live-reload would work in the game.

## How To Use This 

Create `config.js` and specify an output folder.
```js
module.exports = {
  ui: {
    /* TIP: Change to '<your_server_path>/data/ui' */
    outputPath: "./dist",
  },
};
```

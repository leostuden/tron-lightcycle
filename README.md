# TRON Inspired Lightcycle

A grid-based arcade game written in Lua with the LÖVE framework. Steer a lightcycle while a computer-controlled opponent chooses safe moves toward your position.

## Features

- An 800 × 600 arena with a neon grid and colored trails.
- Arrow-key steering with immediate reverse-direction prevention.
- A rule-based opponent that checks adjacent cells and uses Manhattan distance to choose a move.
- Collision detection against arena boundaries and occupied trail cells.
- A game-over screen and one-key restart.

## Controls

| Key | Action |
| --- | --- |
| Arrow keys | Steer the player lightcycle |
| R | Restart after game over |

## Run locally

Install LÖVE from its official website: https://love2d.org/. Open this project folder with LÖVE, or run:

```sh
love .
```

On macOS, drag the folder onto the LÖVE application, or run:

```sh
/Applications/love.app/Contents/MacOS/love .
```

## Implementation notes

`main.lua` contains the game loop, movement, opponent decisions, collision checks, and rendering. The active version renders both bikes as colored cells. The supplied PNG bike images are retained as artwork; the earlier image-loading `love.load` definition is overridden by a later definition and is not used during gameplay.

Trails visually fade but remain occupied in the collision grid. Both riders move sequentially in each update, and either collision ends the round. Possible improvements include winner announcements, simultaneous movement resolution, and difficulty settings.

## Skills demonstrated

Lua · LÖVE · Game loops · Grid-based movement · Collision detection · Rule-based AI · Manhattan distance · Keyboard input · 2D rendering

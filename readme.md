# Godot Reversi
Reversi game created in Godot game engine

## Goals
* Single player game
* Multiplayer game
* Dynamic AI and configuration pulled from remote server
* Statistic tracking on remote server
* Remembering local statistics
* Integration to Steam
* Create custom UI
* Save game
* Replay game

### Additional goals
* Mark valid moves on the board by mutating models
* Mark board positions/grid
* Animate moves
* Improve AI

## Bugs
* When AI player has no moves Human player has to click to establish that both have no moves and end the game. Should be established without additional human click.
* Board out of center when its size is not 8x8
* 0,0 coordinates of the board are bottom right instead of top left
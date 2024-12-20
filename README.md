# README
# UWB CSS 385 A Au 24: Introduction To Game Development. Sumitted Dec 11th 2024.

The following incldes: game code information, changelog, and assignment writeups.

## Dodge the Creeps 2D assets
Used by the "[Your first 2D game](https://docs.godotengine.org/en/latest/getting_started/first_2d_game/index.html)" tutorial.

Assets:
- Audio and tutorial: [https://docs.godotengine.org/en/latest/getting_started/first_2d_game/index.html](https://docs.godotengine.org/en/latest/getting_started/first_2d_game/index.html)

## Changelog (from original.)

- Uploaded and used different art assets.
- PROGRAM 1 - Hello World: change to splash screen: Added text "Go!" for one second after "Get Ready!" splash screen, Starting line 24 in `hud.gd`.
- PROGRAM 2 - Basic Interaction Model: Change in player movement. When space bar is pressed down, player's movement speed increases, while mobs' decreases. Speed reverts to original when space bar is released. Changes starting from line 42, AND from line 52, in `player.gd`and starting from line 8, AND from line 22, in `Mob.gd`
- Saved and show highscore.
- Added info screen to home screen.
Other:
- Added notes and comments to scripts and methods.
- Added READMENOT text file: This text file contains changes unused, irrelevant to, or not useful to the class assignments, but personal notes or things I may want to go back to.

## Write Ups

### PROGRAM 2 - Basic Interaction Model: Change in player movement

#### Overall Game Objective:
Dodge the creeps, and reach for a high score of highest time survived without getting hit!

#### Objective of the Interaction: Evasion
The objective of these interactions are for players to navigate through a field of moving enemy mobs. If the player hits a mob, it's game over. Additionally, the player can hold the spacebar to activate a speed boost, which increases their own movement speed while decreasing the speed of the mobs, adding more player movement options. If a cooldown timer and a limited time were added to the boost, it would add a strategic element to the game.

#### Two Examples of the Interaction Implemented:
1. **Move player to dodge mobs (game over on collision):**
   The player can move in four directions using the arrow keys to avoid the approaching mobs. If the player collides with a mob, a signal is emitted, triggering the game-over sequence. This interaction highlights basic movement and collision detection, where the player must continuously adjust their position to avoid enemies.
2. **Hold spacebar for speed power-up (affects both player and mob speed):**
   When the player holds the spacebar, their speed increases. Pro: can move faster across the screen. Con: less control over player can lead to collision. At the same time, the speed of the mobs decreases, giving the player a temporary advantage to escape tricky situations. This dual effect of the spacebar power-up is like when the Flash goes fast, his surroundings seem slow. Removing the slowing down of mobs would make decrease player control, making it easier to crash, thus making player use it more carefully.

#### Use of Interaction Model in Other Parts of the Game:
This interaction model can be expanded to include:
1. Collecting randomly spawned coins, to add a game objective or encourage player to strategically get to locations.
2. Varied Mobs reactions. Some might slow down, while others could become faster.
3. Adding environmental traps or walls, making the player more strategic about where they move.

#### How This Interaction Model may be Used in my Game:
- When a monster begins moving closer from the closet towards the player, if the player fails to "dodge" the monster in time, it could result in a game over or losing a life. Player must *hold down a key* to *"dodge"* the monster mob. The monster mob also reacts to the player holding down the space, by retreating until it's gone.
- I could also consider creating a boost of some kind that the player can use, but one that fits the game.

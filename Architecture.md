# Solarium Planned Code Architecture and Order of Execution



## Scenario
![Scenario](https://github.com/ParthCv/Solarium/assets/11040014/51c09eef-7c49-4e65-a9ec-fe8f66854c80)
> :bulb: **This image describes the scenario that will be described through code, it provides a 3D context
> to the following structure and entities.**

In the scene (Large box extents), tehre exist two 3D Modeled rooms that are made up of SCN_Nodes. The two rooms are <br>
abstracted as 'Puzzle' objects. Each 'Puzzle' has entities like power spheres and pedestals and buttons that <br>
determine if a puzzle is completed based on certain conditions being met. The logic of how these puzzles are solved <br>
using these entities will be elaborated on in the text below. <br>

### Major Classes, member variables and Structure

- GameInstance
  - Scene
    - [Nodes]: The Scene's nodes
    - [Puzzles]: List of Puzzles in the scene in order of gameplay
      - [Tracked_Entities]: A collection of entities the puzzle needs to know about to complete itself
      
### Order Of Execution
The following is the logic and order of a scene running from start to puzzle completion.

1. Game Starts, Scene loads.
2. Init: We assign tracked entities to puzzles based on prefix naming inside the scene's nodes. Reset Scene's puzzle index <br>
This looks like this. If there are two buttons and they belong to seperate puzzles, they are prefixed by the puzzle
they belong to. Example: 0_Button, 1_Button, 2_Button. <br> This is parsed and passed to the appropriate index of the puzzle linkedlist.
<br> Puzzles themselves are signaled by external objects or are continuously ticking to check for success conditions.
3. Game Sim Runs
4. Interactable Objects have trigger volumes around them. When entered by the player, the highest priority triggger volume subscribes to the player's interact handler
5. Player Presses interact button and consumes interact, calling the interactable object's DoInteract() function (Part of <Interactable> interface)
6. Interactable object performs its respective game logic
7. The game logic that has ran some checks and communicates up to puzzle if puzzle win conditions met
8. Puzzle triggers win if conditions met, puzzle triggers scripted environmental interaction, currentpuzzle is iterated to next in the scene's puzzle list. <br>
If no puzzles remain, player is expected to have access to a volume that will move to the next scene.



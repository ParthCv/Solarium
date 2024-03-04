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

- GameInstance: Wrapper class for the entire application, concerned with lifetime logic of game.
  - Scene: The Game Scene
    - PlayerController: The class issuing control events to the "pawn" PlayerCharacter object
    - PlayerCharacter: The actual physical entity representing the player, with animation logic.
      - PlayerAnimationController: Member of PlayerCharacter responsible for controlling/ blending animations.
    - [Nodes]: The Scene's nodes of Objects
    - [Puzzles]: List of Puzzles in the scene in order of gameplay
      - [Tracked_Entities]: A collection of entities the puzzle needs to know about to complete itself
      
### Order Of Execution
The following is the logic and order of a scene running from start to puzzle completion.

1. Game Starts, Scene loads.
2. Init: We assign tracked entities to puzzles based on prefix naming inside the scene's nodes. <br> "Tracked Entities" are items in the puzzle level that we require some kind of information from, such as on or off state, whether they were interacted with, etc. <br>
Case Example: If there are two buttons and they belong to seperate puzzles, they are prefixed by the puzzle
they belong to. Example: 0_Button, 1_Button, 2_Button. <br> This is parsed and passed to the appropriate index of the puzzle linkedlist.
<br> Puzzles themselves are signaled by external objects or are continuously ticking to check for success conditions.
3. Reset Scene's puzzle index (The current puzzle the player is playing) to 0.
4. Game Sim Runs
5. Interactable Objects implement the interface <Interactable>. <br> Interactables have trigger volumes around them. When trigger volumes are entered into by the player, the highest priority trigger volume subscribes to the player's interact handler.
6. Player Presses interact button and consumes the interact, unsubscribing the interactable and calling the interactable object's DoInteract() function (Part of <Interactable> interface)
7. Interactable object performs its game logic in DoInteract()
8. The game logic runs some checks and communicates up to puzzle if puzzle win conditions met
9. Puzzle triggers win if conditions met, puzzle triggers scripted environmental interaction, currentpuzzle is iterated to next in the scene's puzzle list. <br>
If no puzzles remain, player is expected to have access to a volume that will move to the next scene.



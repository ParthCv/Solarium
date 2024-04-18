import SceneKit

class Puzzle {
    
    /*
     Naming Convention for each puzzleID trackedEntities
     */

    // ID for the puzzle
    var puzzleID: Int
    // Bool to check if the puzzle is solved
    var solved: Bool = false
    // Dictionary of track entities
    var trackedEntities: [Int: Interactable]
    // Scene the puzzle is part of
    var sceneTemplate: SceneTemplate
    
    init (puzzleID: Int, trackedEntities: [Int: Interactable], sceneTemplate: SceneTemplate) {
        self.puzzleID = puzzleID
        self.trackedEntities = trackedEntities
        self.sceneTemplate = sceneTemplate
    }
    
    // Function called when entities assigned
    func linkEntitiesToPuzzleLogic(){}
    
    // Per Puzzle Check for Win condition
    func checkPuzzleWinCon(){}
    
}

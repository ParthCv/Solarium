import SceneKit

class Puzzle {
    
    /*
        Naming Convention for each puzzleID trackedEntities
     */
    var puzzleID: Int
    var solved: Bool = false
    var trackedEntities: [Int: Interactable]
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

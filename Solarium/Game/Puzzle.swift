import SceneKit

class Puzzle {
    
    /*
        Naming Convention for each puzzleID trackedEntities
     */
    var puzzleID: Int
    var solved: Bool = false
    var trackedEntities: [Int: Interactable]
    
    init (puzzleID: Int, trackedEntities: [Int: Interactable]) {
        self.puzzleID = puzzleID
        self.trackedEntities = trackedEntities
    }
    
    // Function called when entities assigned
    func linkEntitiesToPuzzleLogic(){}
    
    // Per Puzzle Check for Win condition
    func checkPuzzleWinCon(){}
}

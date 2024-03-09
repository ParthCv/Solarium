import SceneKit

class Puzzle {
    
    /*
        Naming Convention for each puzzleID trackedEntities
     */
    var puzzleID: Int
    var solved: Bool
    var trackedEntities: [Interactable]
    
    init( puzzleID: Int, solved: Bool, checkpoint: Int, trackedEntities: [Interactable] ) {
        self.puzzleID = puzzleID
        self.solved = solved
        self.trackedEntities = trackedEntities
    }
}

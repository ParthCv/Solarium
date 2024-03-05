////
////  Puzzle.swift
////  Solarium
////
////  Created by Norman Lim on 2024-03-04.
////
//
//import SceneKit
//
//protocol Interactable {
//    func interact();
//}
//
//class InteractableNode: SCNNode, Interactable {
//    func interact() {
//        // Define interaction behavior here
//    }
//}
//
///*
//     Parent Puzzle Function For Children to implement to create their instance of Puzzle
// 
//     let interactableItems: [Interactable] = [/* Add your Interactable items here */]
//     let puzzle = Puzzle(interactableItems: interactableItems)
// */
//class Puzzle {
//    
//    /*
//        Naming Convention for each puzzleID trackedEntities
//     */
//    var puzzleID: Int
//    var solved: Bool
//    var trackedEntities: [InteractableNode]
//    
//    init( puzzleID: Int, solved: Bool, checkpoint: Int, trackedEntities: [InteractableNode] ) {
//        self.puzzleID = puzzleID
//        self.solved = solved
//        self.trackedEntities = trackedEntities
//    }
//    
//    func interactWithItems() {
//        for item in trackedEntities {
//            item.interact()
//        }
//    }
//    
//}

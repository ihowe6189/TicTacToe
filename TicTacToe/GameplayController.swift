//
//  ViewController.swift
//  TicTacToe
//
//  Created by Ian Howe on 2/20/16.
//  Copyright © 2016 Ian Howe. All rights reserved.
//
//
//
//
//
//
import UIKit

class GameplayController: UIViewController {

    @IBOutlet var cellOutlets: [UIView]!
    @IBOutlet var imageViews: [UIImageView]!
    @IBOutlet weak var playerOneImage: UIImageView!
    @IBOutlet weak var playerTwoImage: UIImageView!
    @IBOutlet weak var playerOneName: UILabel!
    @IBOutlet weak var playerTwoName: UILabel!
    @IBOutlet weak var tileOneView: UIView!
    @IBOutlet weak var tileTwoView: UIView!
    @IBOutlet weak var tileOneImage: UIImageView!
    @IBOutlet weak var tileTwoImage: UIImageView!
    @IBOutlet weak var placeholderOne: UIImageView!
    @IBOutlet weak var placeholderTwo: UIImageView!

    let winningCombos = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    var cellStatus = [0,0,0,0,0,0,0,0,0]
    var playerOneTurn = true
    var cpuPlayer = [false,false]
    var cpuDifficulty = [0,0]
    var playerNames = ["Player 1","Player 2",]
    var tileStartingFrames = [CGRect(),CGRect()]
    var tileDisplayFrames = [CGRect(),CGRect()]
    var imageResources = [UIImage(),UIImage()]
    var animationInProgress = false
    var firstRun = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerOneName.text = playerNames[0]
        playerTwoName.text = playerNames[1]
        tileStartingFrames[0] = tileOneView.frame
        tileStartingFrames[1] = tileTwoView.frame
        tileDisplayFrames[0] = tileOneView.frame
        tileDisplayFrames[1] = tileTwoView.frame
        tileDisplayFrames[0].origin.y += 80
        tileDisplayFrames[1].origin.y += 80
        tileOneImage.image = imageResources[0]
        tileTwoImage.image = imageResources[1]
        tileOneView.frame = tileStartingFrames[0]
        tileTwoView.frame = tileStartingFrames[1]
        playerOneImage.alpha = 0
        playerTwoImage.alpha = 0
        chooseStartingPlayer(0)
    }

    @IBAction func tileMoved(sender: UIPanGestureRecognizer) {
        if !animationInProgress {
            if(sender.view!.tag == 0 && playerOneTurn || sender.view!.tag == 1 && !playerOneTurn) {
                let point = sender.locationInView(view)
                if playerOneTurn {
                    sender.view?.center = CGPointMake(point.x - 63, point.y - 371)
                }
                else {
                    sender.view?.center = CGPointMake(point.x - 575, point.y - 371)
                }
                if sender.state == UIGestureRecognizerState.Ended {
                    for cellView in cellOutlets {
                        let cellFrame = cellView.frame
                        let newCenter = CGPoint(x: (sender.locationInView(view).x - 235), y: (sender.locationInView(view).y - 311))
                            print(newCenter)

                        if cellFrame.contains(newCenter) {
                            print("Tile stopped pan at Cell #\(cellView.tag + 1)") /*DEBUG*/
                            processTurn(cellView.tag, animateTile: false)
                        }
                    }
                }
            }
        }
    }

    @IBAction func cellTapped(sender: UITapGestureRecognizer) {
        if !animationInProgress {
            processTurn(sender.view!.tag)
        }
    }
    
    //Randomly chooses a player to start the game
    func chooseStartingPlayer(player: Int) {
        var starter = player
        if starter == 0 {
            starter = Int(arc4random_uniform(2))
        }
        if starter == 1 {
            playerOneTurn = true
            placeholderOne.image = imageResources[0]
            animateTileReset()
        }
        else {
            playerOneTurn = false
            placeholderTwo.image = imageResources[1]
            animateTileReset()
        }
    }
    //Places image in cell and changes turns
    func processTurn(cell: Int) {
        processTurn(cell, animateTile: true)
    }
    func processTurn(cell: Int, animateTile: Bool) {
        if cellStatus[cell] == 0 {
            if playerOneTurn {
                cellStatus[cell] = 1
                print("\(playerNames[0]) chose Cell #\(cell + 1)") /* DEBUG */
                if animateTile {
                    animateTileMove(cell)
                }
                else {
                    for image in imageViews {
                        if image.tag == cell {
                            image.image = imageResources[0]
                        }
                    }
                    playerOneTurn = false
                    if !checkForWinner() {
                        tileOneView.frame = self.tileStartingFrames[0]
                        tileTwoView.frame = self.tileStartingFrames[1]
                        animateTileReset()
                        
                    }
                }

            }
            else {
                cellStatus[cell] = 2
                print("\(playerNames[1]) chose Cell #\(cell + 1)") /* DEBUG */
                if animateTile {
                    animateTileMove(cell)
                }
                else {
                    for image in imageViews {
                        if image.tag == cell {
                            image.image = imageResources[1]
                        }
                    }
                    playerOneTurn = true
                    if !checkForWinner() {
                        tileOneView.frame = self.tileStartingFrames[0]
                        tileTwoView.frame = self.tileStartingFrames[1]
                        animateTileReset()
                    }
                }
                
//                playerTwoImage.image = nil
//                playerOneTurn = true
//                checkForWinner()
//                if(cpuPlayer[0] && !checkForWinner()) {
//                    cpuMove(1)
//                }
            }
        }
    }
    
    func animateTileMove(tile: Int) {
        animationInProgress = true
        placeholderOne.alpha = 0
        placeholderTwo.alpha = 0
        for image in imageViews {
            if image.tag == tile {
                var newImage = UIImage()
                if self.playerOneTurn {
                    newImage = self.imageResources[0]
                    if self.firstRun {
                        tileOneView.frame.origin.y += 80
                        firstRun = false
                    }
                }
                else {
                    newImage = self.imageResources[1]
                    if self.firstRun {
                        tileTwoView.frame.origin.y += 80
                        firstRun = false
                    }
                }
                
                UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
 
                    if self.playerOneTurn {
                        let newX = self.tileOneView.frame.origin.x + 146 + image.superview!.frame.origin.x
                        let newY = self.tileOneView.frame.origin.y - 150 + image.superview!.frame.origin.y
                        self.tileOneView.frame.origin = CGPoint(x: newX, y: newY)
                    }
                    else {
                        let newX = self.tileTwoView.frame.origin.x - 366 + image.superview!.frame.origin.x
                        let newY = self.tileTwoView.frame.origin.y - 152 + image.superview!.frame.origin.y
                        self.tileTwoView.frame.origin = CGPoint(x: newX, y: newY)
                    }


                    }, completion: { finished in
                        image.image = newImage
                        self.animationInProgress = false
                        if !self.checkForWinner() {
                            self.playerOneTurn = !self.playerOneTurn
                            self.tileOneView.frame = self.tileStartingFrames[0]
                            self.tileTwoView.frame = self.tileStartingFrames[1]
                            self.animateTileReset()
                            
                        }
                        
                })
            }
        }
    }
    
    func animateTileReset() {
        if playerOneTurn {
            UIView.animateWithDuration(0.3, animations: {
                self.playerOneImage.alpha = 1
                self.playerTwoImage.alpha = 0
            })
            tileOneView.frame = tileStartingFrames[0]
            tileOneImage.image = imageResources[0]
            
            UIView.animateWithDuration(0.3, delay: 0.3, options: .CurveEaseIn, animations: {
                self.tileOneView.frame = self.tileDisplayFrames[0]
                }, completion: { finished in
                    if(self.cpuPlayer[0] && !self.checkForWinner()) {
                        self.cpuMove(1)
                    }
            })
            
            
        }
        else {
            UIView.animateWithDuration(0.3, animations: {
                self.playerOneImage.alpha = 0
                self.playerTwoImage.alpha = 1
            })
            tileTwoView.frame = tileStartingFrames[1]
            tileTwoImage.image = imageResources[1]
            UIView.animateWithDuration(0.3, delay: 0.3, options: .CurveEaseIn, animations: {
                self.tileTwoView.frame = self.tileDisplayFrames[1]
                }, completion: { finished in
                    if(self.cpuPlayer[1] && !self.checkForWinner()) {
                        self.cpuMove(2)
                    }
                    
            })

        }
    }
    //Checks to see if a winning move has been made on the board
    func checkForWinner() -> Bool {
        var noWinner = true
        for player in 1...2 {
            for combo in winningCombos {
                var sum = 0
                for cell in combo {
                     if cellStatus[cell] == player {
                        sum++
                    }
                }
                if sum == 3 {
                    createAlert(player)
                    noWinner = false
                    return true
                }
            }
        }
        if noWinner {
            var noEmptyCells = true
            for value in cellStatus {
                if value == 0 {
                    noEmptyCells = false
                }
            }
            if noEmptyCells {
                createAlert(0)
                return true
            }
        }
        return false
    }
    
    //Creates an AlertController at the end of the game
    func createAlert(winner: Int) {
        var alertController = UIAlertController()
        if winner == 0 {
        alertController = UIAlertController(title: "The game has resulted in a draw!", message: "Would you like to play again?", preferredStyle: .Alert)
        }
        else {
        alertController = UIAlertController(title: "\(playerNames[winner - 1]) has won the Game!", message: "Would you like to play again?", preferredStyle: .Alert)
        }
        let cancelAction = UIAlertAction(title: "End Game", style: .Cancel, handler:
            {
                (action) -> Void in
                self.performSegueWithIdentifier("gameplayToSetup", sender: self)
        })
        let okAction = UIAlertAction(title: "Rematch!", style: .Default, handler:
            {
                (action) -> Void in
                self.cellStatus = [0,0,0,0,0,0,0,0,0]
                self.animationInProgress = false
                for image in self.imageViews {
                    image.image = nil
                }
                self.tileOneView.frame = self.tileStartingFrames[0]
                self.tileTwoView.frame = self.tileStartingFrames[1]
                
                if winner == 1 {
                    self.chooseStartingPlayer(2)
                }
                else {
                    self.chooseStartingPlayer(1)
                }
                
        })
        alertController.addAction(cancelAction)
        alertController.addAction((okAction))
        self.presentViewController(alertController, animated: true, completion: nil)
        print(cellStatus) /*DEBUG*/
    }
    //Computes the move for the cpu
    func cpuMove(player: Int) {
        var moveNotMade = true
        //Smart algorithm, chooses a location that would prevent the opponent from winning
        if cpuDifficulty[player - 1] >= 1 {
            print("Calculating smart move...") /*DEBUG*/
            var opponent = 0
            if player == 1 {
                opponent = 2
            }
            else {
                opponent = 1
            }
            for combo in winningCombos {
                var sum = 0
                var oppSum = 0
                var targetCell = -1
                for cell in combo {
                    if cellStatus[cell] == player {
                        sum++
                    }
                    else if cellStatus[cell] == opponent {
                        oppSum++
                    }
                    else if cellStatus[cell] == 0 {
                        targetCell = cell
                    }
                }
                if sum == 2 && targetCell != -1{
                    moveNotMade = false
                    processTurn(targetCell)
                }
                else if oppSum == 2 && targetCell != -1{
                    moveNotMade = false
                    processTurn(targetCell)
                }
                if !moveNotMade {
                    break
                }
            }
        }
        //Basic algorithm, chooses a random open spot
        if cpuDifficulty[player - 1] >= 0 && moveNotMade{
            print("Calculating basic move...") /*DEBUG*/
            var randomNumber = 0
            var emptyCells = [Int]()
            var counter = 0
            for value in cellStatus {
                if value == 0 {
                    emptyCells.append(counter)
                }
                counter++
            }
            print(emptyCells)  /*DEBUG*/
            randomNumber = Int(arc4random_uniform(UInt32(emptyCells.count)))
            if emptyCells.count != 0 {
                processTurn(emptyCells[randomNumber])
            }
            else {
                createAlert(0)
            }
        }
    }
}


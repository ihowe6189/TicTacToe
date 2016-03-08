/*
    SetupController.swift
    TicTacToe

    Created by Ian Howe on 2/22/16.
    Copyright © 2016 Ian Howe. All rights reserved.

    Animation code adapted from a reddit submission: https://www.reddit.com/r/swift/comments/2m4av0/adding_animated_transitions_to_images_in_swift/
*/
//TODO: Setup animation for selected player box in gameplay, animate label change for theme
import Foundation
import UIKit

class SetupController: UIViewController {

    @IBOutlet weak var imageSelectOne: UIView!
    @IBOutlet weak var imageSelectTwo: UIView!
    @IBOutlet weak var chosenImageOne: UIImageView!
    @IBOutlet weak var chosenImageTwo: UIImageView!
    @IBOutlet weak var playerOneTextField: UITextField!
    @IBOutlet weak var playerTwoTextField: UITextField!
    @IBOutlet weak var playerOneSwitch: UISwitch!
    @IBOutlet weak var playerTwoSwitch: UISwitch!
    @IBOutlet weak var playerOneSegmentedController: UISegmentedControl!
    @IBOutlet weak var playerTwoSegmentedController: UISegmentedControl!
    @IBOutlet weak var beginButton: UIButton!
    @IBOutlet var arrows: [UIImageView]!
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet var imageSelectButtons: [UIButton]!
    
    
    
    let playerImages = [[UIImage(named: "Theme0X"),UIImage(named: "Theme0O")],
                        [UIImage(named: "Theme1X"),UIImage(named: "Theme1O")],
                        [UIImage(named: "Theme2X"),UIImage(named: "Theme2O")],
                        [UIImage(named: "Theme3X"),UIImage(named: "Theme3O")],
                        [UIImage(named: "Theme4BG"),UIImage(named: "Theme4EG"),UIImage(named: "Theme4H"),UIImage(named: "Theme4P"),UIImage(named: "Theme4RM"),UIImage(named: "Theme4W")]]
    
    //let boardImages = [UIImage(named: "Theme0Board.png"), UIImage(), UIImage(named: "Theme2Board.png"), UIImage(), UIImage()]
    let enabledArrows = [UIImage(named: "arrowBlueUp"), UIImage(named: "arrowBlueDown"), UIImage(named: "arrowRedUp"),UIImage(named: "arrowRedDown")]
    let disabledArrows = [UIImage(named: "arrowLBlueUp"), UIImage(named: "arrowLBlueDown"), UIImage(named: "arrowLRedUp"),UIImage(named: "arrowLRedDown")]
    let themeTitles = ["Classic","Woodburned","Retroactive","Pet Project","School Spirit"]
    var cpuPlayer = [false,false]
    var cpuDifficulty = [0,0]
    var playerNames = ["Player 1","Player 2",]
    var theme = 0
    var imageOne = 0
    var imageTwo = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "setupToGameplay"
        {
            let gameplayController = segue.destinationViewController as! GameplayController
            gameplayController.cpuPlayer = cpuPlayer
            gameplayController.cpuDifficulty = cpuDifficulty
            gameplayController.playerNames = playerNames
            gameplayController.imageResources = [playerImages[theme][imageOne]!, playerImages[theme][imageTwo]!]
        }
    }
    @IBAction func textFieldEditingChanged(sender: UITextField) {
        playerNames[sender.tag] = sender.text!
    }
    @IBAction func switchValueChanged(sender: UISwitch) {
        cpuPlayer[sender.tag] = sender.on
        if sender.on {
            if sender.tag == 0 {
                playerOneSegmentedController.enabled = true
            }
            else {
                playerTwoSegmentedController.enabled = true
            }
        }
        else {
            if sender.tag == 0 {
                playerOneSegmentedController.enabled = false
            }
            else {
                playerTwoSegmentedController.enabled = false
            }
        }
    }
    @IBAction func segmentedControllerValueChanged(sender: UISegmentedControl) {
        cpuDifficulty[sender.tag] = sender.selectedSegmentIndex
    }
    @IBAction func arrowPressed(sender: UILongPressGestureRecognizer) {
        let tagValue = (sender.view?.superview?.tag)!
        if sender.state.rawValue == 1 {
            for imageView in arrows {
                if imageView.tag == tagValue {
                    imageView.image = enabledArrows[tagValue]
                }
            }
        }
        else if sender.state.rawValue == 3 {
            for imageView in arrows {
                if imageView.tag == tagValue {
                    imageView.image = disabledArrows[tagValue]
                }
            }
            for button in imageSelectButtons {
                if button.superview?.tag == tagValue {
                    imageChanged(button)
                    break
                }
            }
            
            
        }
    }
    
    @IBAction func imageChanged(sender: UIButton) {
        var newImage = UIImage()
        if sender.superview?.tag == 0 || sender.superview?.tag == 1 {
            if imageOne == 0 && sender.tag == -1 {
                print("condition A")
                imageOne = playerImages[theme].count - 1
                newImage = playerImages[theme].last!!
            }
            else if imageOne == playerImages[theme].count - 1 && sender.tag == 1 {
                print("condition B")
                imageOne = 0
                newImage = playerImages[theme].first!!
            }
            else {
                print("condition C")
                imageOne += sender.tag
                newImage = playerImages[theme][imageOne]!
                print(imageOne)
            }
            animateChosenImage(chosenImageOne, counter: sender.tag, newImage: newImage)
        }
        else {
            if imageTwo == 0 && sender.tag == -1 {
                print("condition A")
                imageTwo = playerImages[theme].count - 1
                newImage = playerImages[theme].last!!
            }
            else if imageTwo == playerImages[theme].count - 1 && sender.tag == 1 {
                print("condition B")
                imageTwo = 0
                newImage = playerImages[theme].first!!
            }
            else {
                print("condition C")
                imageTwo += sender.tag
                newImage = playerImages[theme][imageTwo]!
                print(imageTwo)
            }
            animateChosenImage(chosenImageTwo, counter: sender.tag, newImage: newImage)

        }
        beginButton.enabled = !(imageOne == imageTwo)
    }
    
    func animateChosenImage(imageToChange: UIImageView, counter: Int, newImage: UIImage){
        let transition = CATransition()
        transition.type = kCATransitionPush
        if counter > 0 {
            transition.subtype = kCATransitionFromBottom
        }
        else {
            transition.subtype = kCATransitionFromTop
        }
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.5)
        imageToChange.layer.addAnimation(transition, forKey: kCATransition)
        imageToChange.image = newImage
        CATransaction.commit()
    }
    
    
    @IBAction func themeChanged(sender: UIButton) {
        theme += sender.tag
        if theme == -1 {
            theme = themeTitles.count - 1
        }
        else if theme == themeTitles.count {
            theme = 0
        }
        if imageOne > 1 {
            imageOne = 0
        }
        if imageTwo > 1 {
            imageTwo = 1
        }
        var direction = -1
        if sender.tag == 1 {
            direction = 1
        }
        animateChosenImage(chosenImageOne, counter: direction, newImage: playerImages[theme][imageOne]!)
        animateChosenImage(chosenImageTwo, counter: direction, newImage: playerImages[theme][imageTwo]!)
        beginButton.enabled = !(imageOne == imageTwo)
        themeLabel.text = themeTitles[theme]
    }
    
    
}

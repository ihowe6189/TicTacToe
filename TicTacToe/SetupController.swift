//
//  SetupController.swift
//  TicTacToe
//
//  Created by Ian Howe on 2/22/16.
//  Copyright © 2016 Ian Howe. All rights reserved.
//
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
    @IBOutlet weak var themePlateImage: UIImageView!
    
    //TODO: Set numbers in image options to actual values
    let numberOfImageOptions = [2,2,2,2]
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
    
    @IBAction func imageChanged(sender: UIButton) {
        //TODO: Animate image changing
        var counter = sender.tag
        if imageOne == 0 && counter == -1 {
            counter = numberOfImageOptions[theme]
        }
        else if imageOne == numberOfImageOptions[theme] && counter == 1 {
            counter = imageOne * -1
        }
        if sender.superview?.tag == 0 {
            chosenImageOne.image = UIImage(named: "Theme\(theme)\(imageOne + counter).png")
        }
        else {
            chosenImageTwo.image = UIImage(named: "Theme\(theme)\(imageTwo + counter).png")
        }
        
        
        
        
        
        beginButton.enabled = !(imageOne == imageTwo)
    }
    @IBAction func themeChanged(sender: UIButton) {
        theme += sender.tag
        if theme == -1 {
            theme = numberOfImageOptions.count - 1
        }
        else if theme == numberOfImageOptions.count {
            theme = 0
        }
        themePlateImage.image = UIImage(named: "Theme\(theme)")
    }
    
    
}

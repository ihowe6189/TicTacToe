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

    @IBOutlet weak var playerOneTextField: UITextField!
    @IBOutlet weak var playerTwoTextField: UITextField!
    @IBOutlet weak var playerOneSwitch: UISwitch!
    @IBOutlet weak var playerTwoSwitch: UISwitch!
    @IBOutlet weak var playerOneSegmentedController: UISegmentedControl!
    @IBOutlet weak var playerTwoSegmentedController: UISegmentedControl!
    
    var cpuPlayer = [false,false]
    var cpuDifficulty = [0,0]
    var playerNames = ["Player 1","Player 2",]
    
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
}

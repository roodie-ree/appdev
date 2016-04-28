//
//  ViewController.swift
//  DogYears
//
//  Created by David Falk on 04/04/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet var ageInput: UITextField!
    @IBAction func calcButton(sender: UIButton) {
        displayDogAge()
        ageInput.endEditing(false)
    }
    @IBOutlet var resultLabel: UILabel!
    
    func displayDogAge() {
        if ageInput.text != nil {
            if let humanAge = UInt(ageInput.text!) {
                self.resultLabel.text = "Your dog is \(humanAge * 7) years old"
            } else {
                self.resultLabel.text = ""
            }
        }
    }
}


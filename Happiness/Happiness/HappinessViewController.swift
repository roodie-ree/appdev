//
//  HappinessViewController.swift
//  Happiness
//
//  Created by Stephan Gimbel on 13/04/16.
//  Copyright © 2016 Hochschule Darmstadt. All rights reserved.
//

import UIKit

class HappinessViewController: UIViewController, FaceViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateUI() {
        faceView.setNeedsDisplay()
    }
    
    var happiness = 50 {
        didSet {
            if happiness < 0 {
                happiness = 0
            } else if happiness > 100 {
                happiness = 100
            }
            updateUI()
            print("happiness = \(happiness)")
        }
    }
    @IBAction func changeHappiness(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .Ended:
            fallthrough
        case .Changed:
            let change = Int(gesture.translationInView(faceView).y) / 4
            if change != 0 {
                happiness += change
                gesture.setTranslation(CGPointZero, inView: faceView)
            }
        default:
            break
        }
    }
    
    @IBAction func changeScale(gesture: UIPinchGestureRecognizer) {
        faceView.scale(gesture)
    }

    func happinessForFaceView(sender: FaceView) -> Double? {
        return Double(happiness) / 50.0 - 1.0
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.dataSource = self
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.scale)))
            faceView.addGestureRecognizer(UILongPressGestureRecognizer(target: faceView, action: #selector(FaceView.changeColor)))
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  NMR-Spec
//
//  Created by David Falk on 02/06/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lineChartView: Chart!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func MoleculeTapped(sender: UITapGestureRecognizer) {
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return lineChartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.5
        scrollView.maximumZoomScale = 2.0
        // Do any additional setup after loading the view, typically from a nib.
        let file = NSBundle.mainBundle().pathForResource("Data", ofType: "csv")
        let data = try! CSV(name: file!)
        let (x, y) = (data.header[0], data.header[1])
        let chartData = data.rows.map() {row in
            return (x: Float(row[x]!)!, y: Float(row[y]!)!)
        }
        lineChartView.addSeries(ChartSeries(data: chartData))
        //scrollView.contentSize = lineChartView.bounds.size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


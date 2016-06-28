//
//  ViewController.swift
//  NMR
//
//  Created by David Falk on 08/06/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, HighlightDataProvider {

    @IBOutlet weak var moleculeImageView: UIImageView!
    @IBOutlet weak var colorView: ColorView!
    @IBOutlet weak var barChartView: NmrBarChartView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    let model = CoreDataModel()!
    
    /// relative parts of the picture to color and tap on
    private let couplingsInPicture = [0.0...0.25, 0.5...0.749, 0.75...1]
    /// relative parts of the diagram to color tap on
    private let couplingsInDiagram = [0.514...0.554, 0.361...0.415, 0.565...0.617]
    @IBInspectable
    private var couplingColors = ChartColorTemplates.material()[0...2]
    @IBInspectable
    private let chartColor = ChartColorTemplates.material()[3]
    /// state of the highlighted couplings
    private var highlights = [false, false, false] {
        didSet {
            colorView.setNeedsDisplay()
            barChartView.setNeedsDisplay()
        }
    }
    
    func isHighlighted(atIndex index: Int) -> Bool {
        return highlights[index]
    }
    
    func toggleHighlight(atIndex index: Int) {
        highlights[index] = !(highlights[index])
    }
    
    func highlightColor(index: Int) -> NSUIColor {
        return couplingColors[index]
    }
    
    func highlightFromBarIndex(barIndex: Int) -> Int? {
        guard let countBars = barChartView.data?._xVals.count else { return nil }
        let relativeX = Double(barIndex) / Double(countBars)
        for (index, coupling) in couplingsInDiagram.enumerate() {
            if coupling.contains(relativeX) && isHighlighted(atIndex: index){
                return index
            }
        }
        return nil
    }
    
    @IBAction func tapGestureRecognized(sender: UITapGestureRecognizer) {
        guard sender.state == .Ended else {
            return
        }
        // check in which view the touch happened
        let location = sender.locationInView(moleculeImageView)
        // image view
        if location.x <= moleculeImageView.bounds.width &&
            location.y <= moleculeImageView.bounds.height {
            let relativeX = Double(location.x / moleculeImageView.bounds.size.width)
            for (index, coupling) in couplingsInPicture.enumerate() {
                if coupling.contains(relativeX) {
                    toggleHighlight(atIndex: index)
                    return
                }
            }
        // bar chart view
        } else {
            let location = sender.locationInView(barChartView)
            guard let barIndex = barChartView.getHighlightByTouchPoint(location)?.xIndex,
                      countBars = barChartView.data?._xVals.count
                else { return }
            let relativeX = Double(barIndex) / Double(countBars)
            for (index, coupling) in couplingsInDiagram.enumerate() {
                if coupling.contains(relativeX) {
                    toggleHighlight(atIndex: index)
                }
            }
        }
    }
    
    /// load fallback data from a csv file
    func loadFallbackData() {
        let file = NSBundle.mainBundle().pathForResource("Data", ofType: "csv")
        let data = try! CSV(name: file!)
        let (x, y) = (data.header[0], data.header[1])
        let xVals = data.columns[x]!.reverse().enumerate().filter { element in
            element.index % 3 == 0
            }.map { element in
                return element.element
        }
        var yVals = [String]()
        for (index, element) in data.columns[y]!.reverse().enumerate() {
            if index % 3 == 0 {
                yVals.append(element)
            }
        }
        let dataSet = BarChartDataSet(yVals: nil, label: "Ethyl Acetate")
        dataSet.colors = [chartColor]
        dataSet.barBorderWidth = 0.0
        dataSet.barSpace = 0.2
        for (index, yVal) in yVals.enumerate() {
            let entry = BarChartDataEntry(value: Double(yVal)!, xIndex: index)
            dataSet.addEntry(entry)
        }
        let chartData = BarChartData(xVals: xVals, dataSets: [dataSet])
        
        dispatch_async(dispatch_get_main_queue()) {
            self.barChartView.animate(yAxisDuration: 2.0)
            self.barChartView.data = chartData
            self.activityIndicatorView.hidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    /// load data from the database
    func loadData() {
        if let savedHighlights = model.highlights {
            for highlight in savedHighlights {
                highlights[Int(highlight.index!)] = Bool(highlight.active!)
            }
        }
        guard let dataPoints = model.dataPoints
            else { return loadFallbackData() }
        guard dataPoints.count > 0
            else { return loadFallbackData() }
        var xVals = [String]()
        for (index, value) in dataPoints.enumerate() {
            guard let xVal = value.x?.stringValue
                else {
                    print("Found nil for x-value at index \(index)")
                    return loadFallbackData()
            }
            xVals.append(xVal)
        }
        var yVals = [BarChartDataEntry]()
        for (index, value) in dataPoints.enumerate() {
            guard let yVal = value.y?.doubleValue
                else {
                    print ("Found nil for y-value at index \(index)")
                    return loadFallbackData() }
            yVals.append(BarChartDataEntry(value: yVal, xIndex: index))
        }
        let dataSet = BarChartDataSet(yVals: yVals, label: "Ethyl Acetate")
        dataSet.colors = [chartColor]
        dataSet.barBorderWidth = 0.0
        dataSet.barSpace = 0.2
        let chartData = BarChartData(xVals: xVals, dataSets: [dataSet])
        
        dispatch_async(dispatch_get_main_queue()) {
            self.barChartView.animate(yAxisDuration: 2.0)
            self.barChartView.data = chartData
            self.activityIndicatorView.hidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorView.dataProvider = self
        guard let chartRenderer =  barChartView.renderer as? BarChartRenderer
            else { return }
        chartRenderer.highlightDataProvider = self
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidden = false
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), loadData)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        for highlight in model.highlights! {
            highlight.active = highlights[Int(highlight.index!)]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


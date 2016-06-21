//
//  NMRBarChartView.swift
//  NMR
//
//  Created by David Falk on 20/06/2016.
//  Copyright © 2016 David Falk. All rights reserved.
//

import Foundation

class NmrBarChartView: BarChartView, ChartXAxisValueFormatter {
    
    override internal func initialize() {
        super.initialize()
        noDataText = "Loading data..."
        descriptionText = "Ethyl Acetate"
        leftAxis.enabled = false
        pinchZoomEnabled = true
        doubleTapToZoomEnabled = false
        legend.enabled = false
        drawGridBackgroundEnabled = false
        xAxis.labelPosition = ChartXAxis.LabelPosition.Bottom
        xAxis.valueFormatter = self
        setExtraOffsets(left: 5, top: 0, right: 0, bottom: 0)
        rightAxis.valueFormatter = formatterForYValues()
        _tapGestureRecognizer.cancelsTouchesInView = false
        highlightPerTapEnabled = false
        
    }
    
    internal func stringForXValue(index: Int, original: String, viewPortHandler: ChartViewPortHandler) -> String {
        return String(format: "%.2f", Double(original)!)
    }
    
    private func formatterForYValues() -> NSNumberFormatter {
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.decimalSeparator = "."
        return formatter
    }

}
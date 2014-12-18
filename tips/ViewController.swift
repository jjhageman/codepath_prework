//
//  ViewController.swift
//  tips
//
//  Created by Jeremy Hageman on 12/14/14.
//  Copyright (c) 2014 Jeremy Hageman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var tipTitleLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var resultsView: UIView!
    @IBOutlet weak var billView: UIView!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    let tipPercentages = [0.18, 0.2, 0.22]
    let formatter = NSNumberFormatter()
    
    var tipPercentSelected: Bool = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !tipPercentSelected {
            loadDefaultTipPercentage()
        }
        initializeDisplay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeDisplay() {
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale.currentLocale()
        
        dollarLabel.text = formatter.currencySymbol
        tipLabel.text = formatter.stringFromNumber(0)
        totalLabel.text = formatter.stringFromNumber(0)
        billField.text = "0"
        billField.becomeFirstResponder()
        
        toggleResultsDisplay(false)
        billAmountCacheMaintenance()
    }
    
    func billAmountCacheMaintenance(){
        var firstLaunchDate = defaults.objectForKey("last_bill_amount_time") as NSDate!
        if firstLaunchDate != nil {
            var timeDiff = -firstLaunchDate.timeIntervalSinceNow
            var minutes = timeDiff / 60
            println(">> bill cache cleared in \(10-minutes) minutes")
            if minutes > 10 {
                clearBillAmountCache()
            } else {
                var billAmountCache: Double? = defaults.doubleForKey("bill_amount_cache")
                if billAmountCache != nil {
                    billField.text = String(format: "%.2f", billAmountCache!)
                    updateTipDisplayAmount(billAmountCache!)
                    showResults()
                }
            }
        }
        
    }
    
    func updateBillAmountCache(billAmount: Double) {
        defaults.setDouble(billAmount, forKey: "bill_amount_cache")
        defaults.setObject(NSDate(), forKey: "last_bill_amount_time")
        println("set billAmountCache to: \(billAmount)")
        defaults.synchronize()
    }
    
    func clearBillAmountCache() {
        defaults.removeObjectForKey("last_bill_amount_time")
        defaults.removeObjectForKey("bill_amount_cache")
    }
    
    func loadDefaultTipPercentage(){
        var defaultTipIndex = defaults.integerForKey("default_tip_index")
        println("updating tip index: \(defaultTipIndex)")
        tipControl.selectedSegmentIndex = defaultTipIndex
    }
    
    func toggleResultsDisplay(showStatus: Bool) {
        resultsView.hidden = !showStatus
    }
    
    func showResults() {
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {
            
            var billFrame = self.billView.frame
            billFrame.origin.y = 84
            self.billView.frame = billFrame
            
            }, completion: { finished in
                self.toggleResultsDisplay(true)
                
        })
    }
    
    func hideResults() {
        toggleResultsDisplay(false)
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {
            
            var billFrame = self.billView.frame
            billFrame.origin.y = 164
            self.billView.frame = billFrame
            
            }, completion: { finished in
                
        })
    }
    
    func stripBillAmountLeadingZero() {
        var billText = billField.text
        if let match = billText.rangeOfString("^0", options: .RegularExpressionSearch) {
            var strippedAmount = billText.substringFromIndex(billText.startIndex.successor())
            billField.text = strippedAmount
        }
    }
    
    func updateTipDisplayAmount(billAmount: Double) {
        var tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        var tip = billAmount * tipPercentage
        var total = billAmount + tip

        tipLabel.text = formatter.stringFromNumber(tip)
        totalLabel.text = formatter.stringFromNumber(total)
    }

    @IBAction func tipPercentageSelected(sender: AnyObject) {
        tipPercentSelected = true
    }
    
    @IBAction func onEditingChanged(sender: AnyObject) {
        if billField.text == "" {
            billField.text = "0"
            clearBillAmountCache()
            hideResults()
        } else {
            stripBillAmountLeadingZero()
            showResults()
            var billAmount = (billField.text as NSString).doubleValue
            updateBillAmountCache(billAmount)
            updateTipDisplayAmount(billAmount)
        }
    }

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
}


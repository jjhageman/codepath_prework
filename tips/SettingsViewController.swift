//
//  SettingsViewController.swift
//  tips
//
//  Created by Jeremy Hageman on 12/14/14.
//  Copyright (c) 2014 Jeremy Hageman. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadDefaultTipPercentage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func defaultTipChanged(sender: AnyObject) {
        setDefaultTipPercentag(sender.selectedSegmentIndex)

        println("Default tip changed \(sender.selectedSegmentIndex)")
    }
    
    func loadDefaultTipPercentage(){
        var defaultTipIndex = defaults.integerForKey("default_tip_index")
        defaultTipControl.selectedSegmentIndex = defaultTipIndex
    }
    
    func setDefaultTipPercentag(tipIndex: Int) {
        defaults.setInteger(tipIndex, forKey: "default_tip_index")
        defaults.synchronize()
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

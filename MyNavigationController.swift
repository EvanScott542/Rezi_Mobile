//
//  MyNavigationController.swift
//  Rezi_Mobile
//
//  Created by Evan Scott on 10/9/14.
//  Copyright (c) 2014 Evan Scott. All rights reserved.
//

import UIKit

class MyNavigationController: SideMenuNavigationController, SideMenuDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()

		navigationBar.barTintColor = hexStringToUIColor("#31c1a7")
		sideMenu = SideMenu(sourceView: self.view, menuTableViewController: MyMenuTableViewController())
		sideMenu?.delegate = self //optional
		sideMenu?.menuWidth = 180.0 // optional, default is 160
		
		// set up navigation bar
		navigationBar.tintColor = hexStringToUIColor("#31c1a7")
		view.bringSubviewToFront(navigationBar)
		
        
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch1.0")){
            //Put any code here and it will be executed only once.
            println("Is a first launch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstlaunch1.0")
            NSUserDefaults.standardUserDefaults().synchronize();
            
            //this should open the home screen on the first launch
            //let vc = HomeViewController(nibName: "HomeViewController", bundle: nil)
            //navigationController?.pushViewController(vc, animated: true)
            //let nextViewController: HomeViewController = HomeViewController()
            //self.presentViewController(nextViewController, animated: true,completion: nil)
            /*
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("HOME") as HomeViewController
            self.presentViewController(vc,animated: true, completion: nil)  
            */

        }

	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
    /************************************************
	* hexStringToColor - function that converts a 
	*                    hex string to a UIColor 
	*					 value. Used for compliance
    *                    to UI Guide.
	* Params:  String (hex: #ffffff or ffffff)
	* Returns: UIColor
	************************************************/
	func hexStringToUIColor (hex:String) -> UIColor {
		var cString:String = hex.stringByTrimmingCharactersInSet(
			NSCharacterSet.whitespaceAndNewlineCharacterSet() as
			NSCharacterSet).uppercaseString
		
		if (cString.hasPrefix("#")) {
			cString = cString.substringFromIndex(advance(cString.startIndex, 1))
		}
		
		if (countElements(cString) != 6) {
			return UIColor.grayColor()
		}
		
		var rgbValue:UInt32 = 0
		NSScanner(string: cString).scanHexInt(&rgbValue)
		
		return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
			alpha: CGFloat(1.0))
	}
	
	// MARK: - SideMenu Delegate
	func sideMenuWillOpen() {
		println("sideMenuWillOpen")
	}
	
	func sideMenuWillClose() {
		println("sideMenuWillClose")
	}
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
	// Get the new view controller using segue.destinationViewController.
	// Pass the selected object to the new view controller.
	}
	*/
	
}


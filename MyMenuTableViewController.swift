//
//  MyMenuTableViewController.swift
//  Rezi_Mobile
//
//  Created by Evan Scott on 10/9/14.
//  Copyright (c) 2014 Evan Scott. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UITableViewController {
	
	var selectedMenuItem : Int = 0	// Index for currently selected menu item
	
	/*****************************************************************************************
	* viewDidLoad
	*
	* Overrides:   UITableViewController.viewDidLoad()
	* Description: Performs additional initialization on the MenuTableView once loaded from
	*				Main.storyboard. Sets the table view/menu's insets, separator style,
	*				background color, & scrolling variables/capabilities among other
	*				UITableView attributes and styles.
	*****************************************************************************************/
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Customize apperance of table view
		tableView.contentInset = UIEdgeInsetsMake(44.0, 0, 0, 0) //
		tableView.contentOffset.y = CGFloat(0)
		tableView.separatorStyle = .None
		tableView.backgroundColor = UIColor.whiteColor()
		tableView.scrollsToTop = false
		
		// Preserve selection between presentations
		self.clearsSelectionOnViewWillAppear = false
		
		tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
	}
	
	/*****************************************************************************************
	* didRecieveMemoryWarning
	*
	* Overrides:   UITableViewController.didRecieveMemoryWarning()
	* Description: Disposes of any resources that can be recreated.
	*****************************************************************************************/
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// MARK: - Table view data source
	
	/*****************************************************************************************
	* numberOfSectionsInTableView
	*
	* Parameters
	* Local:	   tableView (UITableView)
	*
	* Overrides:   UITableViewController.numberOfSectionsInTableView()
	* Returns:	   Int Value
	* Description: Returns the number of sections that are in the table view. Each section
	*              contains the same number of rows.
	*****************************************************************************************/
	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	/*****************************************************************************************
	* tableView:numberOfRowsInSection
	*
	* Parameters
	* Local:		 tableView (UITableView)
	*				 section (Int)
	* External:	 numberOfRowsInSection (Int - external)
	*
	* Overrides:	 UITableViewController.numberOfRowsInSection()
	* Returns:		 Int Value
	* Description:	 Returns the number of rows (i.e. UITableViewCells) per section that are
	*				 in the table view.
	****************************************************************************************/
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	
	/*****************************************************************************************
	* tableView:cellForRowAtIndexPath
	*
	*
	* Local:		tableView (UITableView)
	*				indexPath (NSIndexPath)
	* External:     cellForRowAtIndexPath (NSIndexPath)
	*
	* Overrides:	UITableViewController.cellForRowAtIndexPath()
	* Returns:		cell! (UITableViewCell)
	* Description:	Sets and returns UITableViewCells and their content for each row in the
	*				view.
	*****************************************************************************************/
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		var cell = tableView.dequeueReusableCellWithIdentifier("CELL") as? UITableViewCell
		
		if (cell == nil) {
			cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CELL")
			cell!.backgroundColor = UIColor.clearColor()
			cell!.textLabel?.textColor = UIColor(red:0.00, green: 0.82, blue: 0.63, alpha: 1.0)
			let selectedBackgroundView = UIView(frame: CGRectMake(0, 0, cell!.frame.size.width, cell!.frame.size.height))
			selectedBackgroundView.backgroundColor = UIColor.grayColor().colorWithAlphaComponent(0.2)
			cell!.selectedBackgroundView = selectedBackgroundView
		}
		
		//simply names each table row item, indexed at 0
		if (indexPath.row == 0){
			cell!.textLabel?.text = "Home"
		} else if (indexPath.row == 1) {
            cell!.textLabel?.text = "Profile"
        } else if (indexPath.row == 2) {
            cell!.textLabel?.text = "Change School"
        } /* else if (indexPath.row == 3) {
			cell!.textLabel.text = "Help Tips"
		} else if (indexPath.row == 4) {
			cell!.textLabel.text = "FAQ's"
		} else if (indexPath.row == 5) {
			cell!.textLabel.text = "Send Feedback"
		} */
		
		return cell!
	}
	
	
	/*****************************************************************************************
	* tableView: heightForRowAtIndexPath
	*
	*
	* Local:		tableView (UITableView)
	*				indexPath (NSIndexPath)
	* External:    heightForRowAtIndexPath (NSIndexPath)
	*
	* Overrides:	UITableViewController.cellForRowAtIndexPath()
	* Returns:		CGFloat Value
	* Description:	Returns the height of a row (UITableViewCell)
	*****************************************************************************************/
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		return 55.0
	}
	
	
	/*****************************************************************************************
	* tableView:didSelectRowAtIndexPath
	*
	*
	* Local:		tableView (UITableView)
	*				indexPath (NSIndexPath)
	* External:    didSelectRowAtIndexPath (NSIndexPath)
	*
	* Overrides:	UITableViewController.didSelectRowAtIndexPath()
	* Description:	If the cell at indexPath 0 is selected, the menu is hidden. Otherwise the
	*				appropriate view controller is instantiated when its respective cell is
	*              selected.
	*****************************************************************************************/
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		
		println("did select row: \(indexPath.row)")
		
		selectedMenuItem = indexPath.row
		
		//Present new view controller
		let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
		var destViewController : UIViewController
		
		switch (indexPath.row) {
		case 0:
			destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HOME") as UIViewController
			break
		case 1:
			destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("EditStudent") as UIViewController
			break
		case 2:
			destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("EditSchoolInfoViewController") as UIViewController
			break
        /*case 3:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HELP TIPS") as UIViewController
            break
        case 4:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FAQ'S") as UIViewController
            break
		default:
			destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SEND FEEDBACK") as UIViewController
			break
        */
        default:
            destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("HOME") as UIViewController
            break
		}
		
		sideMenuController()?.setContentViewController(destViewController)
	}
	
	
	/*
	// MARK: - Navigation
	
	// In a storyboard-based application, you will often want to do a little preparation before navigation
	override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
	// Get the new view controller using [segue destinationViewController].
	// Pass the selected object to the new view controller.
	}
	*/
	
}

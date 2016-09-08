//
//  ReportingViewController.swift
//  Rezi_Mobile
//
//  Created by Evan Scott on 11/14/14.
//  Copyright (c) 2014 Evan Scott. All rights reserved.
//

import Foundation
import CoreData
import SystemConfiguration
import UIKit

class ReportingViewController: UITableViewController, UITableViewDataSource {
	
	//core data implementation
	let managedContext : NSManagedObjectContext = ContextManager.sharedInstance.getContext()
    lazy var report : NSManagedObject? = {
        var id = ContextManager.sharedInstance.getReportID()
        
        let object = self.managedContext.objectWithID(id)
        
        return object
    }()

    lazy var school : NSManagedObject? = {
        let fetchRequest = NSFetchRequest(entityName:"School")
        
        //error pointer
        var error: NSError?
        
        //results of fetch
        let fetchedResults =
        self.managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?
        
        //put results in array
        if let results = fetchedResults {
            if (results.count > 0) {
                println("\nschool array count: \(results.count)")
                println("results: \(results)")
                
                return results[0]
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            println("ERROR COULD NOT SET SCHOOL")
            //possibly add the code to delete all schools here
            //possibly add the logic to open the school selection screen if student does not exist
        }
        
        return nil
	}()
	
	lazy var student : NSManagedObject? = {
		let fetchRequest = NSFetchRequest(entityName:"Student")
		
		//error pointer
		var error: NSError?
		
		//results of fetch
		let fetchedResults =
		self.managedContext.executeFetchRequest(fetchRequest,
			error: &error) as [NSManagedObject]?
		
		//put results in array
		if let results = fetchedResults {
			if (results.count > 0) {
                println("student set")
                println("student: \(results[0])")
				return results[0]
			}
		} else {
			println("Could not fetch \(error), \(error!.userInfo)")
			println("ERROR COULD NOT SET STUDENT")
		}
		
		return nil
    }()
	
	//End core data
		
	//custom cells for report items
	var introCell: UITableViewCell!
	var introCell2: UITableViewCell!
	var locationCell: AccordionTableViewCell!
	var dateCell: AccordionTableViewCell!
	var severityCell: SeverityTableViewCell!
	var gradeCell: GradeTableViewCell!
	var lengthCell: LengthTableViewCell!
	var staffNotifiedCell: StaffNotifiedTableViewCell!
	var nextScreenCell: UITableViewCell!
	var descriptionCell: descriptionTableViewCell!
	var anonymousCell: anonymousTableViewCell!
	var submitCell: SubmitTableViewCell!
	
	//vars for handling cell selection
	//	var selectedCell: UITableViewCell!
	//var selectedRowIndex: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
	//var cellTapped: Bool = false
	
	//array of report questions/prompts
	var prompts: [String] = ["Please provide below information, then press next", "1. How severe is this incident?", "2. Where is the location of this incident?", "3. Date and time of incident?", "4. What grade are the students in?", "5. How long has this been going on?", "6. Have any school staff been notified of this school incident, if so who?"]
	
	//prompt 2 vars
	var locationPicker: UIPickerView = UIPickerView(frame:CGRectMake(50, 60, 200, 100))
	let pickerData = ["Choose location...", "Bus Stop","Cafeteria","Playground","Classroom","Recess","After School"]
	
	//prompt 3 vars
	var datePicker: UIDatePicker!
	var dateChosen: String!
	
	//prompt 4 vars
	
	override func viewDidLoad() {
		super.viewDidLoad()
		println("super viewdidload")
		//Navigation item appearance setup
		let navLogo = UIImage(named:"title.png")
		var navLogoView = UIImageView() as UIImageView!
		
		navLogoView.frame.size.width = 63
		navLogoView.frame.size.height = 33
		
		navLogoView.contentMode = .ScaleAspectFit
		navLogoView.image = navLogo
		
		self.navigationItem.titleView = navLogoView

	}
	

	// MARK: UITableViewDataSource
	//table view will have as many rows as the school names array has strings
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		println("num rows in sect")
		return 0
	}
	
	
	/*********************************************************
	* Overriden Function -- cellForRowAtIndexPath
	*
	* Params:	   indexPath (NSIndexPath)
	* Returns:
	* Description: Instantiates a CustomTableViewCell object
	*			   at the row obtained from the received
	*			   indexPath and sets the appropriate
	*			   attributes, label, content, and subviews.
	*********************************************************/
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		println("cell for row at indexpath")
		return UITableViewCell()
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		println("did sel row at index path")
		//selectedRowIndex = indexPath
		//cellTapped = true
		
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		println("height for row at index path")
		
		//only allow cells with pickers to expand upon selection
		return 90
	}
    
    //THIS IS THE FUNCTION CALL THAT WORKS
    func congrats() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("SuccessfulSubmission") as ViewController
        self.showViewController(vc, sender: self)
    }
    
    //THIS IS THE FUNCTION CALL THAT WORKS
    func failureScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("FailedSubmissionViewController") as ViewController
        self.showViewController(vc, sender: self)
    }

    func isConnectedToNetwork() -> Bool {
		
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
			SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
		}
		
		var flags: SCNetworkReachabilityFlags = 0
		if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
			return false
		}
		
		let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		
		return (isReachable && !needsConnection) ? true : false
	}
	
	func sync_with_parse() {
		
		//get required fields
        println("here in sync_with_parse: \(self.report!)")
		var anonymous_val: AnyObject? = self.report!.valueForKey("anonymous") // as NSString
        var category_val: AnyObject? = self.report!.valueForKey("category") // as NSString
        var creator_email_val: AnyObject? = self.report!.valueForKey("creator_email") // as NSString
        var grade_val: AnyObject? = self.report!.valueForKey("grade") // as NSNumber
        var location_val: AnyObject? = self.report!.valueForKey("location") // as NSString
        var report_description_val: AnyObject? = self.report!.valueForKey("report_description") // as NSString
		//var school_id_val: AnyObject? = self.report!.valueForKey("school_id") // as NSString
		var staff_notified_val: AnyObject? = self.report!.valueForKey("staff_notified") // as NSNumber
		var staff_name_val: AnyObject? = self.report!.valueForKey("staff_name") // as NSString
		var student_created_val: AnyObject? = self.report!.valueForKey("student_created") // as NSNumber
		var creator_gender_val: AnyObject? = self.report!.valueForKey("creator_gender") // as NSString
		var creator_grade_val: AnyObject? = self.report!.valueForKey("creator_grade") // as NSNumber
		var creator_name_first_val: AnyObject? = self.report!.valueForKey("creator_name_first") // as NSString
		var creator_name_last_val: AnyObject? = self.report!.valueForKey("creator_name_last") // as NSString
        var time_val: AnyObject? = self.report!.valueForKey("time") // as NSString
        var frequency_val: AnyObject? = self.report!.valueForKey("frequency") // as NSString
        var severity_val: AnyObject? = self.report!.valueForKey("severity") // as NSString
		
		println("about to submit")
		
		var id: AnyObject? = self.school!.valueForKey("school_id") // as NSString
        
        println("school: \(self.school!)")
        println("iidddddd: \(id)")
        
        var classPath : String = "Incidents" + (id! as String)
        var object = PFObject(className: classPath )
    
        
    println("before object definition")
    println(id)
        object["school_id"] = id!
    println(anonymous_val)
		object["anonymous"] = anonymous_val!
    println(frequency_val)
        object["frequency"] = frequency_val!
    println(time_val)
        object["time"] = time_val!
    println(category_val)
		object["category"] = category_val!
    println(grade_val)
		object["grade"] = grade_val!
    println(location_val)
		object["location"] = location_val!
    println(report_description_val)
		object["report_description"] = report_description_val!
    println(staff_notified_val)
		object["staff_notified"] = staff_notified_val!
    println(staff_name_val)
		object["staff_name"] = staff_name_val!
    println(student_created_val)
		object["student_created"] = student_created_val!
    println(creator_email_val)
		object["creator_email"] = creator_email_val!
    println(creator_gender_val)
		object["student_gender"] = creator_gender_val!
    println(creator_grade_val)
		object["creator_grade"] = creator_grade_val!
    println(creator_name_first_val)
		object["creator_name_first"] = creator_name_first_val!
    println(creator_name_last_val)
		object["creator_name_last"] = creator_name_last_val!
		
        //check internet connection
        if (isConnectedToNetwork()) {
            object.saveInBackgroundWithBlock({
                (succeeded: Bool!, error: NSError!) -> Void in
                if(succeeded == true){
                    //it was a success so we need to add this to the conditional
                    println("success: \(succeeded)")
                    
                    //go to success page
                    self.congrats()
                    
                    //delete local reports
                    //self.delete_local_objects()
                } else {
                    
                    self.doFailure()
                    println(error)
                }
            })
        
        } else {
            doFailure()
        }
	}

    func doFailure() {
        
        //go to failure screen
        self.failureScreen()
        
        var failureAlert = UIAlertController(title: "Report Send Error", message: "Failed to send report. Please check your internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
        
        failureAlert.addAction(UIAlertAction(title: "Retry", style: .Default, handler: { (action: UIAlertAction!) in
            self.sync_with_parse()
        }))
        
        failureAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            // cancel logic here
            //delete local reports
            //self.delete_local_objects()
            //go home
            var here = self.navigationController!.popToRootViewControllerAnimated(true)
        }))
        
        self.presentViewController(failureAlert, animated: true, completion: nil)

    }
    
}

class ReportingViewControllerOne: ReportingViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	
	//variables for referencing/interacting w/ table view and cells
	@IBOutlet var reportTableView: UITableView!
	var selectedCell: UITableViewCell!
	var selectedRowIndex: NSIndexPath = NSIndexPath(forRow: -1, inSection: 0)
	var cellTapped: Bool = false
    var location_selected = ""
    var location_label: UILabel = UILabel(frame: CGRectMake(125, 20, 200, 50))
    var date_label: UILabel = UILabel(frame: CGRectMake(90, 15, 200, 50))
	
	//Attempt to collapse cell
	var toggle_expansion = false
	var location_expansion = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		println("view did load 1")
		locationPicker.delegate = self
		locationPicker.dataSource = self
        
        var backImage = UIImage(named: "backbutton")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        var back = UIBarButtonItem(image: backImage, style: .Plain, target: self, action:"pop:")
        self.navigationItem.leftBarButtonItem = back
		
		datePicker = UIDatePicker(frame:CGRectMake(0, 40, 200, 100))
		datePicker.addTarget(self, action: Selector("dateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        /*
		severitySlider.setTranslatesAutoresizingMaskIntoConstraints(false)
		severityLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
		severityViewsDict["severitySlider"] = severitySlider
		severityViewsDict["severityLabel"] = severityLabel
		*/
		tableView.registerNib(UINib(nibName: "ReportIntroTableViewCell", bundle:nil), forCellReuseIdentifier: "ReportIntroTableViewCell")
		tableView.registerNib(UINib(nibName :"SeverityTableViewCell", bundle: nil), forCellReuseIdentifier: "SeverityTableViewCell")
		tableView.registerNib(UINib(nibName: "AccordionTableViewCell", bundle: nil), forCellReuseIdentifier: "AccordionTableViewCell")
		tableView.registerNib(UINib(nibName: "GradeTableViewCell", bundle: nil), forCellReuseIdentifier: "GradeTableViewCell")
		tableView.registerNib(UINib(nibName: "LengthTableViewCell", bundle: nil), forCellReuseIdentifier: "LengthTableViewCell")
		tableView.registerNib(UINib(nibName: "StaffNotifiedTableViewCell", bundle: nil), forCellReuseIdentifier: "StaffNotifiedTableViewCell")
		tableView.registerNib(UINib(nibName: "NextScreenTableViewCell", bundle:nil), forCellReuseIdentifier: "NextScreenTableViewCell")
        
        //Initialize date to current date no matter what
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        //dateChosen = strDate
        self.report!.setValue(strDate, forKey: "time")
        
        //save report in context
        var error: NSError?
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
		
		println("Registered NIBs for custom cells 1")
	}
	
	// MARK: UITableViewDataSource
	//table view will have as many rows as the school names array has strings
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		println("num rows in sect 1")
		return prompts.count + 1
	}
	
	
	/*********************************************************
	* Overriden Function -- cellForRowAtIndexPath
	*
	* Params:	   indexPath (NSIndexPath)
	* Returns:
	* Description: Instantiates a CustomTableViewCell object
	*			   at the row obtained from the received
	*			   indexPath and sets the appropriate
	*			   attributes, label, content, and subviews.
	*********************************************************/
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		println("populating first report screen")
		if (indexPath.row == 0) {
			introCell = tableView.dequeueReusableCellWithIdentifier("ReportIntroTableViewCell") as UITableViewCell
			return introCell
		} else if (indexPath.row == 1) {
			severityCell = tableView.dequeueReusableCellWithIdentifier("SeverityTableViewCell") as SeverityTableViewCell
			severityCell.promptOne.text = prompts[indexPath.row]
			severityCell.contentView.clipsToBounds = true
			return severityCell
		} else if (indexPath.row == 2) {
			locationCell = tableView.dequeueReusableCellWithIdentifier("AccordionTableViewCell") as AccordionTableViewCell
			locationCell.promptTwo.text = prompts[indexPath.row]
			locationCell.contentView.addSubview(locationPicker)
			locationPicker.hidden = true
            locationCell.addSubview(location_label)
			locationCell.clipsToBounds = true
			return locationCell
		} else if (indexPath.row == 3) {
			dateCell = tableView.dequeueReusableCellWithIdentifier("AccordionTableViewCell") as AccordionTableViewCell
			dateCell.promptTwo.text = prompts[indexPath.row]
			dateCell.contentView.addSubview(datePicker)
			datePicker.hidden = true
            dateCell.addSubview(date_label)
			dateCell.clipsToBounds = true
			return dateCell
		} else if (indexPath.row == 4) {
			gradeCell = tableView.dequeueReusableCellWithIdentifier("GradeTableViewCell") as GradeTableViewCell
			gradeCell.promptThree.text = prompts[indexPath.row]
			return gradeCell
		} else if (indexPath.row == 5) {
			lengthCell = tableView.dequeueReusableCellWithIdentifier("LengthTableViewCell") as LengthTableViewCell
			lengthCell.lengthLabel.text = prompts[indexPath.row]
			return lengthCell
		} else if (indexPath.row == 6){
			staffNotifiedCell = tableView.dequeueReusableCellWithIdentifier("StaffNotifiedTableViewCell") as StaffNotifiedTableViewCell
			staffNotifiedCell.staffNotifiedPrompt.text = prompts[indexPath.row]
			return staffNotifiedCell
		} else {
			nextScreenCell = tableView.dequeueReusableCellWithIdentifier("NextScreenTableViewCell") as NextScreenTableViewCell
			
			let nextButton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
			nextButton.frame = CGRectMake(265, 33, 33, 16)
			nextButton.setTitle("Next", forState: UIControlState.Normal)
			nextButton.addTarget(self, action: "nextScreen:", forControlEvents: UIControlEvents.TouchUpInside)
			self.nextScreenCell.addSubview(nextButton)
			
			return nextScreenCell
		}
		
	}
	
	func nextScreen(sender: UIButton!) {
        
        /* UI input validation for report screen 1 questions */
        let location_val : AnyObject? = self.report!.valueForKey("location")
        let grade_val : AnyObject? = self.report!.valueForKey("grade")
        let frequency_val : AnyObject? = self.report!.valueForKey("frequency")
        let staff_bool_val : AnyObject? = self.report!.valueForKey("staff_notified")
        let staff_name_val : AnyObject? = self.report!.valueForKey("staff_name")
        
        // location validation
        if (location_val! as String == "Choose location..." ||
            location_val! as String == "undefined") {
            
            //show location alert
            let alert = UIAlertView()
            alert.title = "Location"
            alert.message = "Please select a location"
            alert.addButtonWithTitle("Ok")
            alert.show()
        
        // grade validation
        } else if (grade_val as Int == 0) {
            
            //show grade alert
            let alert = UIAlertView()
            alert.title = "Grade"
            alert.message = "Please select grade"
            alert.addButtonWithTitle("Ok")
            alert.show()

        // length validation
        } else if (frequency_val as String == "undefined" || frequency_val as String == "") {
            
            //show length alert
            let alert = UIAlertView()
            alert.title = "How Long?"
            alert.message = "Please enter how long this has been going on"
            alert.addButtonWithTitle("Ok")
            alert.show()

        // staff notified validation
        } else if (staff_bool_val as NSNumber == true &&
                    ( staff_name_val as String == "" || staff_name_val as String == "undefined" ) ) {
                
                //show staff notified alert
                let alert = UIAlertView()
                alert.title = "Staff Notified"
                alert.message = "Please indicate who was notified of the incident. If no staff was notified, uncheck that option in order to continue"
                alert.addButtonWithTitle("Ok")
                alert.show()
            
        // else go to next screen
        } else {
            println("next")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            println("inst vc")
            let vc = storyboard.instantiateViewControllerWithIdentifier("ReportScreenTwo") as ReportingViewControllerTwo
            println("show new vc")
            
            self.showViewController(vc, sender: self)
        }
	}
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		println("DID SELECT")
		
		selectedRowIndex = indexPath
		
		//begin and end updates
		reportTableView.beginUpdates()
		reportTableView.endUpdates()
		
		print("index: \(indexPath.row)")
		
		if (indexPath.row == 2) {
			println("LOCATION - TRYING TO EXPAND CELL")
			if(location_expansion == false){
				locationPicker.hidden = false
				datePicker.hidden = true
				location_expansion = true
			}
			else{
				println("no in here")
				locationPicker.hidden = true
				datePicker.hidden = true
				location_expansion = false
			}
			
		} else if (indexPath.row == 3) {
			println("LOCATION - TRYING TO EXPAND CELL")
			if(toggle_expansion == false){
				datePicker.hidden = false
				locationPicker.hidden = true
				toggle_expansion = true
			}
			else{
				datePicker.hidden = true
				toggle_expansion = false
			}
			
		} else {
			println("hide all")
			locationPicker.hidden = true
			datePicker.hidden = true
		}
		
		
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		println("PICKER TIME")
		//pertains to the datepicker
		if ((indexPath.row == selectedRowIndex.row) && (indexPath.row == 3)) {
			if(toggle_expansion == true){
				println("collapse datepicker")
				return 60
			}
			else{
				println("expand datepicker")
				cellTapped = false
				return 270
			}
			//pertains to the location picker
		}
		if( (indexPath.row == selectedRowIndex.row) && (indexPath.row == 2)){
			if(location_expansion == true){
				println("collapse locationpicker")
				return 60
			}
			else{
				println("expand locationpicker")
				return 270
			}
		}
		else if ((indexPath.row != selectedRowIndex.row) && (indexPath.row == 2 || indexPath.row == 3)) {
			return 45
		} else if ((indexPath.row != selectedRowIndex.row) && (indexPath.row == 7)) {
			return 60
		} else if ((indexPath.row != selectedRowIndex.row) && (indexPath.row == 0)){
			return 56
		} else {
			return 80
		}
	}
	
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
		println("num components in picker view")
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		println("number of rows in component")
		return pickerData.count
	}
	
	//MARK: Delegates
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
		return pickerData[row]
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		println("\(pickerData[row])")
        
        //Added in order to display selection
		//locationChosen = pickerData[row]
        location_selected = pickerData[row]
        location_label.text = location_selected
        
        self.report!.setValue(pickerData[row], forKey: "location")
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
	}
	
	
	
	//size the components of the UIPickerView
	func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 30.0
	}
	
	func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
		return 225
	}
	
	//Function which displays date from DatePicker as a string
	func datePickerChanged() {
        println("Pow Pow")
		var dateFormatter = NSDateFormatter()
		
		dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
		dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
		
		var strDate = dateFormatter.stringFromDate(datePicker.date)
		//dateChosen = strDate
        date_label.text = strDate
        
        
        self.report!.setValue(strDate, forKey: "time")
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
	}
	
	func dateChanged(sender: UIPickerView!) {
		datePickerChanged()
	}
    
    func pop(sender: UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let vc = storyboard.instantiateViewControllerWithIdentifier("HOME") as ViewController
        //self.showViewController(vc,sender: true)
    }
	
}

/**********************************************************
* class -- ReportingViewControllerTwo
*********************************************************/
class ReportingViewControllerTwo: ReportingViewController {
	
	@IBOutlet var tableView2: UITableView!
	var prompts2: [String] = ["Please provide below information, then press next", "7. Description - Tell us what happened.", "8. Do you want to report anonymously?"]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		println("view did load 2")
		tableView2.registerNib(UINib(nibName: "ReportIntroTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportIntroTableViewCell")
		tableView2.registerNib(UINib(nibName: "descriptionTableViewCell", bundle:nil), forCellReuseIdentifier: "descriptionTableViewCell")
		tableView2.registerNib(UINib(nibName: "anonymousTableViewCell", bundle:nil), forCellReuseIdentifier: "anonymousTableViewCell")
		tableView2.registerNib(UINib(nibName: "SubmitTableViewCell", bundle:nil), forCellReuseIdentifier: "SubmitTableViewCell")
		
		println("Registered NIBs for custom cells 2")
		
	}
	
	// MARK: UITableViewDataSource
	//table view will have as many rows as the school names array has strings
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		println("num rows in sect 2")
		return prompts2.count + 1
	}
	
	
	/*********************************************************
	* Overriden Function -- cellForRowAtIndexPath
	*
	* Params:	   indexPath (NSIndexPath)
	* Returns:
	* Description: Instantiates a CustomTableViewCell object
	*			   at the row obtained from the received
	*			   indexPath and sets the appropriate
	*			   attributes, label, content, and subviews.
	*********************************************************/
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

			println("populating next report screen")
			if (indexPath.row == 0){
				println("INTRO")
				introCell2 = tableView2.dequeueReusableCellWithIdentifier("ReportIntroTableViewCell") as ReportIntroTableViewCell
				//introCell2.textLabel.text = prompts2[indexPath.row]
				println("success")
				return introCell2
			} else if (indexPath.row == 1){
				println("DESCRIPTION")
				descriptionCell = tableView2.dequeueReusableCellWithIdentifier("descriptionTableViewCell") as descriptionTableViewCell
				println("success")
				descriptionCell.descriptionLabel.text = prompts2[indexPath.row]
				return descriptionCell
			} else if (indexPath.row == 2) {
				println("ANONYMOUSLY?")
				anonymousCell = tableView2.dequeueReusableCellWithIdentifier("anonymousTableViewCell") as anonymousTableViewCell
				println("success")
				anonymousCell.anonymousLabel.text = prompts2[indexPath.row]
				return anonymousCell
			} else {
				println("SUBMIT")
				submitCell = tableView2.dequeueReusableCellWithIdentifier("SubmitTableViewCell") as SubmitTableViewCell
				
				let submitButton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
				submitButton.frame = CGRectMake(265, 65, 50, 35)
				submitButton.setTitle("Submit", forState: UIControlState.Normal)
                println("here")
				submitButton.addTarget(self, action: "saveIncidentInCoreData:", forControlEvents: UIControlEvents.TouchUpInside)
                //submitButton.addTarget(self, action: "next_screen:", forControlEvents:UIControlEvents.TouchUpInside)
				
				self.submitCell.addSubview(submitButton)

				
				return submitCell
				
			}
		
		/*
		//println("populating next report screen")
		if (indexPath.row == 0){
			println("INTRO")
			introCell2 = tableView2.dequeueReusableCellWithIdentifier("ReportIntroTableViewCell") as ReportIntroTableViewCell
			//introCell2.textLabel.text = prompts2[indexPath.row]
			println("success")
			return introCell2
		} else if (indexPath.row == 1){
			println("DESCRIPTION")
			descriptionCell = tableView2.dequeueReusableCellWithIdentifier("descriptionTableViewCell") as descriptionTableViewCell
			println("success")
			descriptionCell.descriptionLabel.text = prompts2[indexPath.row]
			return descriptionCell
		} else if (indexPath.row == 2) {
			println("ANONYMOUSLY?")
			anonymousCell = tableView2.dequeueReusableCellWithIdentifier("anonymousTableViewCell") as anonymousTableViewCell
			println("success")
			anonymousCell.anonymousLabel.text = prompts2[indexPath.row]
			return anonymousCell
		} else {
			println("SUBMIT")
			submitCell = tableView2.dequeueReusableCellWithIdentifier("SubmitTableViewCell") as SubmitTableViewCell
			
			let submitButton   = UIButton.buttonWithType(UIButtonType.System) as UIButton
			submitButton.frame = CGRectMake(265, 65, 50, 35)
			submitButton.setTitle("Submit", forState: UIControlState.Normal)
			submitButton.addTarget(self, action: "next_screen", forControlEvents: UIControlEvents.TouchUpInside)
			
			self.submitCell.addSubview(submitButton)
			
			return submitCell
		}
        */
		
		
	}
	
	
	// MARK: - Report completion/submission logic
	
	/*********************************************************
	* func -- isConnectedToNetwork
	*
	* Returns: Bool
	* Description: Tests for reachability i.e. network
	*			   connection. If reachable, ret true, if not
	*			   ret false.
	*********************************************************/
	
	
	
	/*********************************************************
	* func -- success
	*
	* Returns:
	* Description: Pushes to SuccessfulSubmission vc.
	*********************************************************/
	func next_screen(sender: UIButton!) {
		
		if(isConnectedToNetwork() == true){
			success()
		} else {
			
			//failed to send
			failure()
			
			//create the alert dialogue on failure to send screen notifying user to try again
			var not_connected = UIAlertController(title: "Rezi Connectivity", message: "It appear you are currently offline, your report will be unable to be sent immediately. Rezi will recheck for connectivity when you submit your report.", preferredStyle: UIAlertControllerStyle.Alert)
			
			
			
			//add the "Cancel" button ( hopefully this segues the user back to the report 2 screen )
			var storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
			print("1")
			let vc = storyboard.instantiateViewControllerWithIdentifier("ReportScreen2") as ReportingViewControllerTwo
			print("2")
			not_connected.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {action in self.showViewController(vc, sender: self)}))
			print("3")
			self.showViewController(vc, sender: self)
			print(".....liftoffff!!!!!!!!!!")
			
			
			//add the "Call Someone" button
			//not_connected.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {action in self.goToCongrats()}))
			//In theory this will be presented on the failure to send screen
			//self.presentViewController(not_connected , animated: true, completion: nil)
			
		}
	}
	
	
	
	/*********************************************************
	* func -- success
	*
	* Returns:
	* Description: Pushes to SuccessfulSubmission vc.
	*********************************************************/
	func success() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("SuccessfulSubmission") as ViewController
		//self.presentViewController(vc as ViewController, animated: true, completion:nil)
		vc.showViewController(vc, sender: true)
		
		
		//let vc = storyboard.instantiateViewControllerWithIdentifier("SuccessfulSubmission") as ViewController
		//self.showViewController(vc,sender: true)
	}
	
	/*********************************************************
	* func -- failure
	*
	* Returns:
	* Description: Pushes to FailedSubmissionViewController
	*			   vc.
	*********************************************************/
	func failure() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("FailedSubmissionViewController") as ViewController
		//self.presentViewController(vc as ViewController, animated: true, completion:nil)
		vc.showViewController(vc, sender: true)
	}
    
    //THIS IS THE FUNCTION CALL THAT WORKS
    func goToFailureScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("FailedSubmissionViewController") as ViewController
        self.showViewController(vc, sender: self)
    }
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		println("did sel row at index path 2")
		
		
		tableView2.beginUpdates()
		tableView2.endUpdates()
	}
	
	override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
		
		println("height for row at index path 2")
		
		return 140
	}
    
    func saveIncidentInCoreData(sender: UIButton!) {
        
        let description_val : AnyObject? = self.report!.valueForKey("report_description")

        /* input validation for report screen 2 */
        //description textfield validation
        if(description_val as String == "" || description_val as String == "undefined") {
        
            //show description alert
            let alert = UIAlertView()
            alert.title = "Description"
            alert.message = "Please enter a description of the incident"
            alert.addButtonWithTitle("Ok")
            alert.show()
            
        //else continue normally
        } else {
            if (anonymousCell.anonymousSwitch.on) {
                //bundle anonymous contact information in report
                println("user is anonymous")
                self.report!.setValue(true, forKey: "anonymous")
                self.report!.setValue("N/A", forKey: "creator_name_first")
                self.report!.setValue("N/A", forKey: "creator_name_last")
                self.report!.setValue(0, forKey: "creator_grade")
                self.report!.setValue("N/A", forKey: "creator_phone")
                self.report!.setValue("N/A", forKey: "creator_email")
                self.report!.setValue("N/A", forKey: "creator_gender")
            
            } else {
                //retrieve student contact info
                println("user isnt anonymous")
                var stuFirstName: AnyObject? = self.student!.valueForKey("student_first_name")// as String
                var stuLastName: AnyObject? = self.student!.valueForKey("student_last_name")// as String
                var stuGrade: AnyObject? = self.student!.valueForKey("student_grade")// as Int
                var stuPhone: AnyObject? = self.student!.valueForKey("student_phone")// as String
                var stuEmail: AnyObject? = self.student!.valueForKey("student_email")// as String
                
                //bundle contact info in report
                self.report!.setValue(false, forKey: "anonymous")
                self.report!.setValue(stuFirstName, forKey: "creator_name_first")
                self.report!.setValue(stuLastName, forKey: "creator_name_last")
                self.report!.setValue(stuGrade, forKey: "creator_grade")
                self.report!.setValue(stuPhone, forKey: "creator_phone")
                self.report!.setValue(stuEmail, forKey: "creator_email")
            }
            
            var error: NSError?
            //save report in context
            if !self.managedContext.save(&error) {
                //ERROR OCCURED SAVING INCIDENT TO COREDATA
                println("Could not save \(error), \(error?.userInfo)")
            } else {
                sync_with_parse()

                //push the incident to parse
                //check for network connection
                //if (submitCell.isConnectedToNetwork()) {
                    
                    //success()
                    
                    //println("here")
                    //no connection present
                //} else {
                    //goToFailureScreen() //then show popup?
                //}
            }
        }
    }
}


//MARK: - Custom UITableViewCell classes
class ReportIntroTableViewCell: UITableViewCell {
	
	@IBOutlet weak var promptOne: UILabel!
	
	required init(coder aDecoder: NSCoder) {
		println("SEE: ---------------- init custom table view cell")
		super.init(coder: aDecoder)
		//self.contentView.clipsToBounds = true
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		println("SEE: ---------------- override init custom tableviewcell w/ reuse id")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//self.contentView.clipsToBounds = true
	}
	
	override func awakeFromNib() {
		println("awake from nib")
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		println("get selected")
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}

class AccordionTableViewCell: UITableViewCell {
	
	@IBOutlet weak var promptTwo: UILabel!
	
	required init(coder aDecoder: NSCoder) {
		println("SEE: ---------------- init custom table view cell")
		super.init(coder: aDecoder)
		//self.contentView.clipsToBounds = true
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		println("SEE: ---------------- override init custom tableviewcell w/ reuse id")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//self.contentView.clipsToBounds = true
	}
	
	override func awakeFromNib() {
		println("awake from nib")
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		println("get selected")
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}

class SeverityTableViewCell: UITableViewCell {
	
    let managedContext : NSManagedObjectContext = ContextManager.sharedInstance.getContext()
    lazy var report : NSManagedObject? = {
        var id = ContextManager.sharedInstance.getReportID()
        
        let object = self.managedContext.objectWithID(id)
        
        return object
    }()
    
	var severity_val : Int = 0
	
	@IBOutlet weak var promptOne: UILabel!
	@IBOutlet weak var severitySlider: UISlider!
	@IBOutlet weak var severityLabel: UILabel!
	
	required init(coder aDecoder: NSCoder) {
		println("req init")
		super.init(coder: aDecoder)
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		println("init reuse id")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
	}
	
	override func awakeFromNib() {
		println("awaken!!!!!!!!!!!!")
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		println("get selected")
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	//sliders snap to fit logic is included inside this action
	@IBAction func sliderValueChanged(sender: UISlider) {
		
		var currentValue = Int(sender.value)
		severityLabel.text = "\(currentValue)"
		
		//The dragging action has stopped so lets now snap the the closest value
		println("dragging ceased")
		if(currentValue < 1){
			severityLabel.text = "Low"
			severitySlider.value = 0
			severity_val = 0
		}
		else if(currentValue < 2 && currentValue >= 1){
			severityLabel.text = "Medium"
			severitySlider.value = 2
			severity_val = 1
		}
		else if(currentValue < 3 && currentValue >= 2 ){
			severityLabel.text = "Medium"
			severitySlider.value = 2
			severity_val = 1
		}
		else{
			severityLabel.text = "High"
			severitySlider.value = 4
			severity_val = 2
		}
        
        self.report!.setValue(severity_val, forKey: "severity")
        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
		
	}
}

class LengthTableViewCell : UITableViewCell, UITextFieldDelegate {
	
    let managedContext : NSManagedObjectContext = ContextManager.sharedInstance.getContext()
    lazy var report : NSManagedObject? = {
        var id = ContextManager.sharedInstance.getReportID()
        
        let object = self.managedContext.objectWithID(id)
        
        return object
    }()
    
	var frequency_val : String = ""
	
	@IBOutlet weak var lengthTextField : UITextField!
	@IBOutlet weak var lengthLabel : UILabel!
	
	required init(coder aDecoder: NSCoder) {
		println("req init")
		super.init(coder: aDecoder)
		//self.contentView.clipsToBounds = true
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		println("init reuse id")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//self.contentView.clipsToBounds = true
	}
	
	override func awakeFromNib() {
		println("awaken!!!!!!!!!!!!")
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		println("get selected")
		lengthTextField.delegate = self //set delegate to the textfield
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
	{
        self.report!.setValue(lengthTextField.text, forKey: "frequency")
        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
        
		lengthTextField.resignFirstResponder()
		return true;
	}
	
	//Closes the keyboard when touched outside of keyboard region
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.report!.setValue(lengthTextField.text, forKey: "frequency")

        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
        
		lengthTextField.endEditing(true)
	}
	
}

class GradeTableViewCell: UITableViewCell {
	
    let managedContext : NSManagedObjectContext = ContextManager.sharedInstance.getContext()
    lazy var report : NSManagedObject? = {
        var id = ContextManager.sharedInstance.getReportID()
        
        let object = self.managedContext.objectWithID(id)
        
        return object
    }()
    
	var grade_val : Int = 0
	
	@IBOutlet weak var promptThree: UILabel!
	@IBOutlet weak var stepper: UIStepper!
	@IBOutlet weak var gradeLabel: UILabel!
	
	required init(coder aDecoder: NSCoder) {
		println("req init")
		super.init(coder: aDecoder)
		//self.contentView.clipsToBounds = true
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		println("init reuse id")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//self.contentView.clipsToBounds = true
	}
	
	override func awakeFromNib() {
		println("awaken!!!!!!!!!!!!")
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		println("get selected")
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	@IBAction func stepperValueChanged(sender: UIStepper) {
		gradeLabel.text = Int(sender.value).description
        
        self.report!.setValue(Int(sender.value), forKey: "grade")
        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
	}
}

class StaffNotifiedTableViewCell: UITableViewCell, UITextFieldDelegate  {
	
    let managedContext : NSManagedObjectContext = ContextManager.sharedInstance.getContext()
    lazy var report : NSManagedObject? = {
        var id = ContextManager.sharedInstance.getReportID()
        
        let object = self.managedContext.objectWithID(id)
        
        return object
    }()

    
	var staff_name_val : String = ""
	var staff_notified_val : Bool = false
	
	@IBOutlet weak var staffNotifiedPrompt: UILabel!
	@IBOutlet weak var wasNotifiedSwitch: UISwitch!
	@IBOutlet weak var staffNotifiedTextField: UITextField!
	
	
	required init(coder aDecoder: NSCoder) {
		println("req init")
		super.init(coder: aDecoder)
		//self.contentView.clipsToBounds = true
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		println("init reuse id")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//self.contentView.clipsToBounds = true
	}
	
	override func awakeFromNib() {
		println("awaken!!!!!!!!!!!!")
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		println("get selected")
		staffNotifiedTextField.delegate = self //set delegate to the textfield
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	@IBAction func toggle_notified(sender: AnyObject) {
		if(wasNotifiedSwitch.on == true){
			//get user entered value
			staff_notified_val = true
			println("on")
			println("\(wasNotifiedSwitch.on)")
			staffNotifiedTextField.hidden = false
		} else {
			println("off")
			
			//get user entered value
			staff_notified_val = false
			staffNotifiedTextField.hidden = true
            staffNotifiedTextField.text = ""
            self.report!.setValue(staff_name_val, forKey: "staff_name")
		}
        
        self.report!.setValue(staff_notified_val, forKey: "staff_notified")
        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
	}
	
	func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
	{
        self.report!.setValue(staffNotifiedTextField.text, forKey: "staff_name")
        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
        
		staffNotifiedTextField.resignFirstResponder()
		return true;
	}
	
	//Closes the keyboard when touched outside of keyboard region
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.report!.setValue(staffNotifiedTextField.text, forKey: "staff_name")
        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }

		staffNotifiedTextField.endEditing(true)
	}
	
}

// custom cell containing next button that segues to screen two
class NextScreenTableViewCell: UITableViewCell {
	
	required init(coder aDecoder: NSCoder) {
		println("req init")
		super.init(coder: aDecoder)
		//self.contentView.clipsToBounds = true
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		println("init reuse id")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//self.contentView.clipsToBounds = true
	}
	
	override func awakeFromNib() {
		println("awaken!!!!!!!!!!!!")
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		println("get selected")
		super.setSelected(selected, animated: animated)
	}
}

class descriptionTableViewCell: UITableViewCell , UITextFieldDelegate  {
    
    let managedContext : NSManagedObjectContext = ContextManager.sharedInstance.getContext()
    lazy var report : NSManagedObject? = {
        var id = ContextManager.sharedInstance.getReportID()
        
        let object = self.managedContext.objectWithID(id)
        
        return object
    }()
	
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var descriptionTextField: UITextField!
	
	required init(coder aDecoder: NSCoder) {
		println("req init")
		super.init(coder: aDecoder)
		//self.contentView.clipsToBounds = true
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		println("init reuse id")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//self.contentView.clipsToBounds = true
	}
	
	override func awakeFromNib() {
		println("awaken!!!!!!!!!!!!")
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		println("get selected")
		descriptionTextField.delegate = self //set delegate to the textfield
		
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
	{
        self.report!.setValue(descriptionTextField.text, forKey: "report_description")
        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }

		descriptionTextField.resignFirstResponder()
		return true;
	}
	
	//Closes the keyboard when touched outside of keyboard region
	override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.report!.setValue(descriptionTextField.text, forKey: "report_description")
        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
        
		descriptionTextField.endEditing(true)
	}
}


class anonymousTableViewCell: UITableViewCell {
	
	@IBOutlet weak var anonymousLabel: UILabel!
	@IBOutlet weak var anonymousSwitch: UISwitch!
	
	required init(coder aDecoder: NSCoder) {
		println("req init")
		super.init(coder: aDecoder)
		//self.contentView.clipsToBounds = true
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		println("init reuse id")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//self.contentView.clipsToBounds = true
	}
	
	override func awakeFromNib() {
		println("awaken!!!!!!!!!!!!")
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		println("get selected")
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
}

class SubmitTableViewCell: UITableViewCell, UINavigationControllerDelegate {
	
	required init(coder aDecoder: NSCoder) {
		println("req init")
		super.init(coder: aDecoder)
		//self.contentView.clipsToBounds = true
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
		println("init reuse id")
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		//self.contentView.clipsToBounds = true
	}
	
	override func awakeFromNib() {
		println("awaken!!!!!!!!!!!!")
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(selected: Bool, animated: Bool) {
		println("get selected")
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
    
	//checks if user has wifi connection or is using cellular data
	func isConnectedToNetwork() -> Bool {
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
			SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
		}
		var flags: SCNetworkReachabilityFlags = 0
		if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
			return false
		}
		let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		return (isReachable && !needsConnection) ? true : false
	}
	
	
	
	/*
	@IBAction func next_screen(sender: AnyObject) {
	
	//var storyboard : UIStoryboardSegue =
	
	if(isConnectedToNetwork() == true){
	success()
	} else {
	
	//failed to send
	failure()
	
	//create the alert dialogue on failure to send screen notifying user to try again
	var not_connected = UIAlertController(title: "Rezi Connectivity", message: "It appear you are currently offline, your report will be unable to be sent immediately. Rezi will recheck for connectivity when you submit your report.", preferredStyle: UIAlertControllerStyle.Alert)
	
	//add the "Cancel" button ( hopefully this segues the user back to the report 2 screen )
	not_connected.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: {action in ViewController.unwindToSegue()}))
	
	//add the "Call Someone" button
	//not_connected.addAction(UIAlertAction(title: "Retry", style: UIAlertActionStyle.Default, handler: {action in self.goToCongrats()}))
	//In theory this will be presented on the failure to send screen
	//self.presentViewController(not_connected , animated: true, completion: nil)
	
	}
	}
	*/
	
	//This success function segues the user to the congrats screen
	func success() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("SuccessfulSubmission") as ViewController
		//self.presentViewController(vc as ViewController, animated: true, completion:nil)
		vc.showViewController(vc, sender: true)
		
		
		//let vc = storyboard.instantiateViewControllerWithIdentifier("SuccessfulSubmission") as ViewController
		//self.showViewController(vc,sender: true)
	}
	
	//This failure function segues the user to the failed to submit screen
	func failure() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let vc = storyboard.instantiateViewControllerWithIdentifier("FailedSubmissionViewController") as ViewController
		//self.presentViewController(vc as ViewController, animated: true, completion:nil)
		vc.showViewController(vc, sender: true)
	}

	
	
	//checks if the user has wifi connection or is using celluar date and if they do take the user
	//to the congrats screen and commit that request to parse
	/*
	func goToCongrats(){
	if(isConnectedToNetwork() == true){
	success()
	}
	}
	*/
}

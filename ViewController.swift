//
//  ViewController.swift
//  Rezi_Mobile
//
//  Created by Evan Scott on 10/9/14.
//  Copyright (c) 2014 Evan Scott. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import MobileCoreServices
import MediaPlayer
import AVFoundation
import Foundation
import SystemConfiguration

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
	
	
	
    /**
    * CORE DATA IMPLEMENTATION
    */
	
	let managedContext : NSManagedObjectContext = ContextManager.sharedInstance.getContext()
    let entity : NSEntityDescription
    let report : NSManagedObject
    
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
                println("\nstudent array count: \(results.count)")
                println("results: \(results)")
                
                return results[0]
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            println("ERROR COULD NOT SET STUDENT")
            //possibly add the code to delete all students here
            //possibly add the logic to open the registration screen if student does not exist
        }
        
        return nil
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

    required init(coder aDecoder: NSCoder) {
        
        //initial report should be created here
        //this is to be used throughout the class and should only be done a single time
        entity =  NSEntityDescription.entityForName("Report",
            inManagedObjectContext:
            self.managedContext)!
        
        //put new object in correct context
		println("instantiate report entity")
        report = NSManagedObject(entity: self.entity,
            insertIntoManagedObjectContext : self.managedContext)
        
        /* set all default values to avoid crashes on sending to parse with null (nil) values */
        
        //user specific values
        report.setValue(true, forKey: "student_created")
        report.setValue("default", forKey: "creator_email")
        report.setValue("default", forKey: "creator_gender")
        report.setValue("default", forKey: "creator_name_first")
        report.setValue("default", forKey: "creator_name_last")
        report.setValue("default", forKey: "creator_phone")
        report.setValue(-1, forKey: "creator_grade")
        report.setValue("default", forKey: "school_emergency")
        
        //category
        report.setValue(-1, forKey: "category")
        
        //screen 1
        report.setValue(0, forKey: "severity")
        report.setValue("undefined", forKey: "location")
        report.setValue("undefined", forKey: "time")
        report.setValue(0, forKey: "grade")
        report.setValue("undefined", forKey: "frequency")
        report.setValue(false, forKey: "staff_notified")
        report.setValue("undefined", forKey: "staff_name")
        

        //screen 2
        report.setValue("undefined", forKey: "report_description")
        report.setValue(false, forKey: "anonymous")
        
        //not currently used in 1.0
        report.setValue("undefined", forKey: "audio")
        report.setValue("undefined", forKey: "video")
        report.setValue("undefined", forKey: "picture")

        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        } else {
            //set the global report ID so it can be retrieved later
            ContextManager.sharedInstance.setReportID(report.objectID)
            println("OBJECT IDDDDDD: \(report.objectID)")
        }

        super.init(coder: aDecoder)
    }
    
    //Outlets for report type screen
    @IBOutlet weak var language: UIButton!
    @IBOutlet weak var drug_use: UIButton!
    @IBOutlet weak var altercation: UIButton!
    @IBOutlet weak var harassment: UIButton!
    @IBOutlet weak var disrespect: UIButton!
    @IBOutlet weak var disruption: UIButton!
    @IBOutlet weak var theft: UIButton!
    @IBOutlet weak var vandalism: UIButton!
    
    //outlets for report_2 screen
    @IBOutlet weak var what_happend: UITextField!
    @IBOutlet weak var anonymously: UITextField!
    
    //POC of pickers
    @IBOutlet weak var myPicker: UIPickerView!
    @IBOutlet weak var myLabel: UILabel!
    let pickerData = ["Bus Stop","Cafeteria","Playground","Classroom","Recess","After School"]
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Navigation item appearance setup
		let navLogo = UIImage(named:"title.png")
		var navLogoView = UIImageView() as UIImageView!
		
		navLogoView.frame.size.width = 63
		navLogoView.frame.size.height = 33
		
		navLogoView.contentMode = .ScaleAspectFit
		navLogoView.image = navLogo
		
		self.navigationItem.titleView = navLogoView

        //delete_local_objects()
		
        // Do any additional setup after loading the view, typically from a nib.
        //myPicker.delegate = self
       // myPicker.dataSource = self
        //datePicker.addTarget(self, action: Selector("dataPickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
	}
    
    override func viewDidAppear(animated: Bool) {
	
        /*if(!NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch1.0")){
            //Put any code here and it will be executed only once.
            println("Is a first launch")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstlaunch1.0")
            NSUserDefaults.standardUserDefaults().synchronize();
            
        }*/
        
        /*
        println("im Here")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HOME") as HomeViewController
        self.presentViewController(vc,animated: true, completion: nil)
        */
    }

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
		
        return true;
    }
    
    //Closes the keyboard when touched outside of keyboard region
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }

	//The event listener for the navigation menu button
	@IBAction func toggleSideMenu(sender: AnyObject) {
		toggleSideMenuView()
	}

    //Function associated with the emergency button
    func emergency(animated: Bool) {
        var alert = UIAlertController(title: "ATTENTION", message: "911 is for emergency purposes only. False reports or prank calls are punishable by law.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Call 911", style: UIAlertActionStyle.Default, handler: {action in self.emergency_call()})) // ADD ACTUAL IMPLEMENTATION HERE
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //event listener corresponding to emergency button
    @IBAction func emergency_button(sender: UIButton) {
        emergency(true)
    }
    
    //keyboard hides when return key is pressed
    func textViewShouldReturn(textView: UITextView!) -> Bool{
        textView.resignFirstResponder()
        return true;
    }
 
    //This is a hacky way to mimic 'hinttext' for the text view
    @IBOutlet weak var text_view: UITextView!
    @IBAction func viewTapped(sender: AnyObject){
       text_view.text = ""
       text_view.becomeFirstResponder()
    }
    
    //the correct way to navigate back to a previous page
    @IBAction func unwindToSegue (segue : UIStoryboardSegue) {
		//Leave empty
	}
	
    //access number pad for emergency 911 call when selects 'yes' on alert dialog for emergency button
	func emergency_call(){
		
		UIApplication.sharedApplication().openURL(NSURL(string: "tel://8045391940")!) //needs to be 911
	}
    
    //POC for picker
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        myLabel.text = pickerData[row]
    }
    
    //size the components of the UIPickerView
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    
    //Function which displays date from DatePicker as a string
	
	func datePickerChanged() {
        var dateFormatter = NSDateFormatter()
        
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        dateLabel.text = strDate
    }

    
    @IBAction func dateChanged(sender: AnyObject) {
        datePickerChanged()
    }
    
    func delete_local_objects() {
        let fetchRequest = NSFetchRequest(entityName:"Report")
        
        //error pointer
        var error: NSError?
        
        //results of fetch
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as [NSManagedObject]?

        //put results in array
        if let results = fetchedResults {
            if (results.count > 0) {
                println("Reports to delete array count: \(results.count)")
                
                for item in results {
                    
                    //delete the NSManagedObject from the correct context
                    managedContext.deleteObject(item)
                    
                    //MAKE SURE YOU SAVE THE CONTEXT AFTER DELETE
                    managedContext.save(&error)
                }
            }
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
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
	
	//MARK: - Actions for report type screen - set report category
	
	@IBAction func startObsceneLanguageReport(sender: AnyObject) {
		report.setValue(0, forKey: "category")
	}
	
	@IBAction func startDrugUseReport(sender: AnyObject) {
		report.setValue(1, forKey: "category")
	}
	
	@IBAction func startPhysicalAltercationReport(sender: AnyObject) {
		report.setValue(2, forKey: "category")
	}
	
	@IBAction func startSexualHarrassmentReport(sender: AnyObject) {
		report.setValue(3, forKey: "category")
	}
	
	@IBAction func startDisrespectReport(sender: AnyObject) {
		report.setValue(4, forKey: "category")
	}
	
	@IBAction func startDisruptionReport(sender: AnyObject) {
		report.setValue(5, forKey: "category")
	}
	
	@IBAction func startTheftReport(sender: AnyObject) {
		report.setValue(6, forKey: "category")
	}
	
	@IBAction func startVandalismReport(sender: AnyObject) {
		report.setValue(7, forKey: "category")
	}
}

//---------------------------------------------------------------------------------------------


class SchoolSelectionViewController: ViewController, UITableViewDataSource
{
    
	//@IBOutlet weak var navItem: UINavigationItem!
	
	
	@IBOutlet weak var schoolsTableView: UITableView!
	@IBOutlet weak var submitButton: UIButton!
	
	//Insert below the tableView IBOutlet
	var schools = [PFObject]()
	
	// MARK: UITableViewDataSource

	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
			//return schoolNames.count
            return schools.count
	}
 
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
 
		//let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
		//cell.textLabel.text = schoolNames[indexPath.row]
 
		//return cell
        
        let cell =
        tableView.dequeueReusableCellWithIdentifier("Cell")
            as UITableViewCell
        
        let school = schools[indexPath.row] as PFObject
        cell.textLabel?.text = school["school_name"] as String?
        
        return cell
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		schoolsTableView.registerClass(UITableViewCell.self,
			forCellReuseIdentifier: "Cell")
	}
    
    //Snippet of code in here pertains to the first time run logic
    override func viewDidAppear(animated: Bool) {
        
        if isConnectedToNetwork() {
            //populate schools array
            retrieveSchoolsFromParse()
        }

        //lets retrieved the saved number and check it is 1,
        //if it is we will then we have a second launch and 
        //we will present the home view controller
        var userDefault = NSUserDefaults.standardUserDefaults()
        var retrievedNumber = userDefault.integerForKey("number")
        
        var retrieve = NSUserDefaults.standardUserDefaults()
        var retrievedSchool = userDefault.integerForKey("schoolSelected")
        
        var get_registration = NSUserDefaults.standardUserDefaults()
        var registrationComplete = userDefault.integerForKey("registration_done")
        if(retrievedNumber == 1 && retrievedSchool == 2 && registrationComplete == 3){

            //set the correct student user
            //set_student_from_coredata()
            println(student)
            
            //set the correct school
            //set_school_from_coredata()
            println(school)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("HOME") as ViewController
            self.showViewController(vc,sender: true)
            
        }
        
        //lets save the first launch and give it a value of 1
        if(NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch1.0")){
        println("First Launch")
            var userDefault = NSUserDefaults.standardUserDefaults()
            var number:Int = 1
            userDefault.setInteger(number , forKey: "number")
            userDefault.synchronize()
            var storedNumber = userDefault.integerForKey("number")
            println(storedNumber)
        }
    }
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
    

	@IBAction func submitSchool(sender: AnyObject) {
        
		if (schoolsTableView.indexPathForSelectedRow() != nil) {
            
            //lets see if the user has already selected a school previoiusly
            var school_complete = NSUserDefaults.standardUserDefaults()
            var school_selected:Int = 2
            school_complete.setInteger(school_selected , forKey: "schoolSelected")
            school_complete.synchronize()
            var storedSchool = school_complete.integerForKey("schoolSelected")
		
			let school_entity =  NSEntityDescription.entityForName("School", inManagedObjectContext: managedContext)
			println("instantiated school entity")
			let school_obj = NSManagedObject(entity: school_entity!, insertIntoManagedObjectContext:managedContext)
			println("Inserted school entity into managed obj context")
			
			let index = schoolsTableView.indexPathForSelectedRow()
			println("instantiated index")
			//let schoolSelected = schoolNames[index!.row]
			println("got selected school")
			
            
           /**
            * emergency and id should be contained in the PFObject that was retrieved from parse when populating the
            * table with school names
            */
            
            println("school value: \(self.schools[index!.row])")
            var school_name_val: AnyObject? = self.schools[index!.row].valueForKey("school_name")// as String
            var school_emergency_val: AnyObject? = self.schools[index!.row].valueForKey("school_emergency")// as String
            var school_id_val: AnyObject? = self.schools[index!.row].valueForKey("objectId")// as String
            
			school_obj.setValue(school_name_val, forKey: "school_name")
            school_obj.setValue(school_emergency_val, forKey: "school_emergency") //this value should be retrieved from parse
            school_obj.setValue(school_id_val, forKey: "school_id")        //this value should be retrieved from parse
			//println("set school in local db")
			
			
			var error: NSError?
			if !managedContext.save(&error) {
				println("Could not save \(error), \(error?.userInfo)")
			}
			
			//perform segue to register app view controller
			let registerAppViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterAppViewController") as RegisterAppViewController
			self.navigationController?.pushViewController(registerAppViewController, animated: true)
		} // end if
	}
	
    func retrieveSchoolsFromParse() {

        var query = PFQuery(className:"Schools")
        self.schools = query.findObjects() as [PFObject]
        schoolsTableView.reloadData()
    }
	
}

class RegisterAppViewController: ViewController {

    var gender = ""
	
	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	//@IBOutlet weak var gradeTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var gender_control: UISegmentedControl!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var gradeLabel: UILabel!
    var grade_val = 6
    
	override func viewDidLoad() {
		super.viewDidLoad()
        
        //self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.hidesBackButton=true;
	}
	
	override func viewWillAppear(animated: Bool) {
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
    @IBAction func male_female(sender: UISegmentedControl!) {
        switch gender_control.selectedSegmentIndex
        {
        case 0:
            println("Male")
            gender = "male"
        case 1:
            println("Female")
            gender = "female"
        default:
            break; 
        }
    }
    
	@IBAction func submitProfileInfo(sender: AnyObject) {
        
        if(firstNameTextField.hasText() == true && lastNameTextField.hasText() == true  && emailTextField.hasText() == true && phoneTextField.hasText() == true && gender != ""){
            //lets see if the user has already selected a school previoiusly
            var register_complete = NSUserDefaults.standardUserDefaults()
            var register_selected:Int = 3
            register_complete.setInteger(register_selected , forKey: "registration_done")
            register_complete.synchronize()
            var storedSchool = register_complete.integerForKey("registration_done")
            
            println("submit profile info action")
            let student_entity =  NSEntityDescription.entityForName("Student", inManagedObjectContext: managedContext)
            println("instantiated student entity")
            let student_obj = NSManagedObject(entity: student_entity!, insertIntoManagedObjectContext:managedContext)
            println("Inserted student entity into managed obj context")
            
            //var grade_val = gradeTextField.text.toInt()
            
            student_obj.setValue(firstNameTextField.text, forKey: "student_last_name")
            student_obj.setValue(lastNameTextField.text, forKey: "student_first_name")
            student_obj.setValue(grade_val, forKey: "student_grade")
            student_obj.setValue(emailTextField.text, forKey: "student_email")
            student_obj.setValue(phoneTextField.text, forKey: "student_phone")
            student_obj.setValue(gender, forKey: "student_gender")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewControllerWithIdentifier("HOME") as ViewController
            self.showViewController(vc,sender: true)
        }
        else if(firstNameTextField.hasText() == false || lastNameTextField.hasText() == false || emailTextField.hasText() == false || phoneTextField.hasText() == false){
            not_complete(true)
        }
        else{
            no_gender(true)
        }
        
        /*
		println("submit profile info action")
		let student_entity =  NSEntityDescription.entityForName("Student", inManagedObjectContext: managedContext)
		println("instantiated student entity")
		let student_obj = NSManagedObject(entity: student_entity!, insertIntoManagedObjectContext:managedContext)
		println("Inserted student entity into managed obj context")
		
		student_obj.setValue(firstNameTextField.text, forKey: "student_first_name")
		student_obj.setValue(lastNameTextField.text, forKey: "student_last_name")
		student_obj.setValue(gradeLabel.text, forKey: "student_grade")
        student_obj.setValue(gender, forKey: "student_gender")
		student_obj.setValue(emailTextField.text, forKey: "student_email")
		student_obj.setValue(phoneTextField.text, forKey: "student_phone")
        
        var grade = gradeLabel.text
        println("grade: \(grade)")
        //student_obj.setValue(gradeLabel.text, forKey: "student_grade")
		println("set student info in local db1111")
		/*
		var error: NSError?
		
		if !managedContext.save(&error) {
			println("Could not save \(error), \(error?.userInfo)")
		}*/
        */

	}
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        gradeLabel.text = Int(sender.value).description
        grade_val = Int(sender.value)
        
        //self.student!.setValue(Int(sender.value), forKey: "student_grade")
        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func no_gender(animated: Bool) {
        var alert = UIAlertController(title: nil, message: "Please select a gender before proceeding.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func not_complete(animated: Bool) {
        var alert = UIAlertController(title: nil, message: "Please fill out all required fields before proceeding.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
	
}

class EditStudentInfoViewController : ViewController {
    
    //var gender : String = ""
    
    @IBOutlet weak var firstNameTextField : UITextField!
	@IBOutlet weak var lastNameTextField : UITextField!
	@IBOutlet weak var emailTextField : UITextField!
	@IBOutlet weak var phoneTextField : UITextField!
    @IBOutlet weak var gender_control: UISegmentedControl!
    @IBOutlet weak var saveButton : UIButton!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    var student_gender = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        var backImage = UIImage(named: "backbutton")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        var back = UIBarButtonItem(image: backImage, style: .Plain, target: self, action:"pop:")
        self.navigationItem.leftBarButtonItem = back
        //self.view.addSubview(nextButton)
        //self.navigationItem.leftBarButtonItem
        self.navigationItem.hidesBackButton=false;
        
        firstNameTextField.text = self.student!.valueForKey("student_first_name") as String
        lastNameTextField.text = self.student!.valueForKey("student_last_name") as String
        
        //Still need to set the grade label and stepper value
        //gradeLabel.text = self.student!.valueForKey("student_grade") as String
        var grade_val = self.student!.valueForKey("student_grade") as Int
        gradeLabel.text = String(grade_val)
        
        stepper.value = Double(grade_val)
        
        emailTextField.text = self.student!.valueForKey("student_email") as String
        phoneTextField.text = self.student!.valueForKey("student_phone") as String
        
        //Still need to set the gender
        //gender_control.text = self.student!.valueForKey("student_gender") // as String
        var gender = self.student!.valueForKey("student_gender") as String
        println("gender: \(gender)")
        
        if(gender == "male"){
            
            gender_control.selectedSegmentIndex = 0
        }
        else{
            gender_control.selectedSegmentIndex = 1
        }

	}
	
	override func viewWillAppear(animated: Bool) {
		
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	@IBAction func saveProfileInfo(sender: AnyObject) {

        //var grade_val = gradeLabel.text!.toInt()
		
		self.student!.setValue(firstNameTextField.text, forKey: "student_first_name")
		self.student!.setValue(lastNameTextField.text, forKey: "student_last_name")
		self.student!.setValue(emailTextField.text, forKey: "student_email")
		self.student!.setValue(phoneTextField.text, forKey: "student_phone")
        self.student!.setValue(student_gender, forKey: "student_gender")
        
		var error: NSError?
		if !managedContext.save(&error) {
			println("Could not save \(error), \(error?.userInfo)")
        } else {
            updated(true)
        }
	}

    @IBAction func male_female(sender: UISegmentedControl!) {
        switch gender_control.selectedSegmentIndex
        {
        case 0:
            println("Male")
            student_gender = "male"
        case 1:
            println("Female")
            student_gender = "female"
        default:
            break;
        }
    }
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        gradeLabel.text = Int(sender.value).description
        
        self.student!.setValue(Int(sender.value), forKey: "student_grade")
        
        var error: NSError?
        //save report in context
        if !self.managedContext.save(&error) {
            //ERROR OCCURED SAVING INCIDENT TO COREDATA
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func no_gender(animated: Bool) {
        var alert = UIAlertController(title: nil, message: "Please select a gender before proceeding.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func not_complete(animated: Bool) {
        var alert = UIAlertController(title: nil, message: "Please fill out all required fields before proceeding.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func updated(animated: Bool) {
        var alert = UIAlertController(title: nil, message: "Your profile information has been saved.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: {action in self.goHome()}))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func goHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HOME") as ViewController
        self.showViewController(vc,sender: true)
    }
    
    func pop(sender: UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HOME") as ViewController
        self.showViewController(vc,sender: true)
    }
}

class EditSchoolInfoViewController : ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var schoolsTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    //Insert below the tableView IBOutlet
    var schools = [PFObject]()
    
    // MARK: UITableViewDataSource
    //table view will have as many rows as the school names array has strings
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(schools.count)
        return schools.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
        tableView.dequeueReusableCellWithIdentifier("Cell")
            as UITableViewCell
        
        let school = schools[indexPath.row] as PFObject
        cell.textLabel?.text = school["school_name"] as String?
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var backImage = UIImage(named: "backbutton")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        var back = UIBarButtonItem(image: backImage, style: .Plain, target: self, action:"pop:")
        self.navigationItem.leftBarButtonItem = back
        self.navigationItem.hidesBackButton = false;
        
        schoolsTableView.registerClass(UITableViewCell.self,
            forCellReuseIdentifier: "Cell")
    }
    
    //Snippet of code in here pertains to the first time run logic
    override func viewDidAppear(animated: Bool) {
        
        if isConnectedToNetwork() {
            //populate schools array
            retrieveSchoolsFromParse()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitSchool(sender: AnyObject) {
        
        if (schoolsTableView.indexPathForSelectedRow() != nil) {
            
            let index = schoolsTableView.indexPathForSelectedRow()
            
            /**
            * emergency and id should be contained in the PFObject that was retrieved from parse when populating the
            * table with school names
            */
            println("school value: \(self.schools[index!.row])")
            var school_name_val: AnyObject? = self.schools[index!.row].valueForKey("school_name")// as String
            var school_emergency_val: AnyObject? = self.schools[index!.row].valueForKey("school_emergency")// as String
            var school_id_val: AnyObject? = self.schools[index!.row].valueForKey("objectId")// as String
            
            school!.setValue(school_name_val, forKey: "school_name")
            school!.setValue(school_emergency_val, forKey: "school_emergency") //this value should be retrieved from parse
            school!.setValue(school_id_val, forKey: "school_id")        //this value should be retrieved from parse
            
            var error: NSError?
            if !managedContext.save(&error) {
                println("Could not save \(error), \(error?.userInfo)")
            } else {
                updated(true)
            }
        } // end if
    }
    
    func retrieveSchoolsFromParse() {
        var query = PFQuery(className:"Schools")
        self.schools = query.findObjects() as [PFObject]
        schoolsTableView.reloadData()
        println("here")
    }
    
    func updated(animated: Bool) {
        var alert = UIAlertController(title: nil, message: "Your school selection has been saved.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: {action in self.goHome()}))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func goHome(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HOME") as ViewController
        self.showViewController(vc,sender: true)
    }
    
    func pop(sender: UIBarButtonItem){
        self.navigationController?.popViewControllerAnimated(true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HOME") as ViewController
        self.showViewController(vc,sender: true)
    }
}


class MediaViewController: ViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate{
    
    //Video Player Variables
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
	
	//Audio Session Variables
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
	var url:NSURL!
	var timer:NSTimer = NSTimer()
	var startTime = NSTimeInterval()
	
	@IBOutlet weak var recordTimeLabel: UILabel!
	@IBOutlet weak var recordBtn: UIButton!
	@IBOutlet weak var stopRecordingBtn: UIButton!
	@IBOutlet weak var playAudioBtn: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	//Audio capture implementation
	
	/******************************************************
	 * recordAudio: IBAction
	 *
	 * Params: sender
     * Description: IBAction triggered by record button
     *****************************************************/
    @IBOutlet weak var record_inactive: UIButton!
    var record_selected = UIImage(named: "VOICE_activebuttion.png") as UIImage!
    var record_unselected = UIImage(named: "VOICE_inactivebuttion.png") as UIImage!
    var recording = true
    
	@IBAction func recordAudio(sender: AnyObject) {
		println("record method called")
        if( recording == true){
            println("yay")
            self.record()
            record_inactive.setImage(record_selected, forState: UIControlState.Normal)
            recording = false
        }
        else{
            println("nay")
            record_inactive.setImage(record_unselected, forState: UIControlState.Normal)
            recording = true
            stopRecordingAudio(self)
        }
	}
	
	/******************************************************
	* stopRecordingAudio: IBAction
	*
	* Params: sender
	* Description: IBAction triggered by stop button. Stops
    *              recording to .caf file and disables stop
	*			   button.
	*******************************************************/
	func stopRecordingAudio(sender: AnyObject) {
		println("stop method called")
		println("i hate apple")
		recordBtn.enabled = true
		
		if (audioRecorder.recording) {

			audioRecorder.stop()
		} else if (audioPlayer.playing) {
			audioPlayer.stop()
		}
		
		timer.invalidate()
	}
	
	/******************************************************
	* playAudioRecording: IBAction
	*
	* Params: sender
	* Description: IBAction triggered by record button.
	*		       Plays the .caf file that the
	*			   audio was recorded to.
	*****************************************************/
	@IBAction func playAudioRecording(sender: AnyObject) {
		println("play method called")
		if (!audioRecorder.recording) {
			
			
			var error: NSError?
			audioPlayer = AVAudioPlayer(contentsOfURL: url, error: &error)
			//audioPlayer.delegate = self
			
			if let e = error {
				println(e.localizedDescription)
			} else {
				audioPlayer.play()
				if (!timer.valid) {
					let aSelector : Selector = "updateTime"
					//timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
					//startTime = NSDate.timeIntervalSinceReferenceDate()
				}
			}
		}
	}
    
    //delete function for delete button
    @IBAction func delete_audio(sender: AnyObject) {
        println(url)
        //audioRecorder.deleteRecording()
    
    }
	
	/******************************************************
	* record: func
	*
	* Description: record function called by recordAudio
	*			   IBAction. Saves recording to .caf file
	*		       at path var/mobile/Containers/Data/
	*			   Application/7F43B031-1D81-4A6B-8D01-
	*			   62022BF827A3/Documents/recordTest.caf
	*****************************************************/
	func record(){
		
		var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
		audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
		audioSession.setActive(true, error: nil)
		
		var documents: AnyObject = NSSearchPathForDirectoriesInDomains( NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true)[0]
		var str =  documents.stringByAppendingPathComponent("recordTest.caf")
		url = NSURL.fileURLWithPath(str as String)
		
		var recordSettings = [AVFormatIDKey:kAudioFormatAppleIMA4,
			AVSampleRateKey:44100.0,
			AVNumberOfChannelsKey:2,AVEncoderBitRateKey:12800,
			AVLinearPCMBitDepthKey:16,
			AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
		]
		
		println("url : \(url)")
		var error: NSError?
		
		audioRecorder = AVAudioRecorder(URL:url, settings: recordSettings, error: &error)
		if let e = error {
			println(e.localizedDescription)
		} else {
			
			audioRecorder.record()
			
			if (!timer.valid) {
				let aSelector : Selector = "updateTime"
				timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
				startTime = NSDate.timeIntervalSinceReferenceDate()
			}

		}
	}
	
	/******************************************************
	* updateTime: func
	*
	* Description: Used by audio recording functions to 
	*			   make updates to the recordTimeLabel
	*			   so that it may act as a timer.
	*****************************************************/
	func updateTime() {
		var currentTime = NSDate.timeIntervalSinceReferenceDate()
		
		var elapsedTime: NSTimeInterval = currentTime - startTime
		let minutes = UInt8(elapsedTime / 60.0)
		elapsedTime -= (NSTimeInterval(minutes) * 60)
		let seconds = UInt8(elapsedTime)
		elapsedTime -= NSTimeInterval(seconds)
		let fraction = UInt8(elapsedTime * 100)
		let strMinutes = minutes > 9 ? String(minutes):"0" + String(minutes)
		let strSeconds = seconds > 9 ? String(seconds):"0" + String(seconds)
		let strFraction = fraction > 9 ? String(fraction):"0" + String(fraction)
		
		recordTimeLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
	}
	
	
    /******************************************************
    * takeVideo: IBAction
    *
    * Params: sender
    * Description: asks user whether they would like to select
    *              from library, if not then the user is taken
    *              to the native video screen.
    *****************************************************/
    @IBAction func takeVideo(sender: AnyObject) {
        
        var photo_gallery = UIAlertController(title: nil, message: "Would you like to choose and existing video?", preferredStyle: UIAlertControllerStyle.Alert)
        photo_gallery.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action in self.open_photoroll() })) //
        photo_gallery.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {action in self.open_video() }))
        self.presentViewController(photo_gallery , animated: true, completion: nil)
    }
    
    /******************************************************
    * open_video: func
    *
    * Description: helper function to navigate to the
    *              native video screen.
    *****************************************************/
    func open_video(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            
            println("captureVideoPressed and camera available.")
            
            var imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = false
            
            imagePicker.showsCameraControls = true
            
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        } else {
            println("Camera not available.")
        }
    }
    
    /******************************************************
    * imagePickerController: func
    *
    * Description: saves out users video.
    *****************************************************/
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {
        
        let tempImage = info[UIImagePickerControllerMediaURL] as NSURL!
        let pathString = tempImage.relativePath
        self.dismissViewControllerAnimated(true, completion: {})
        
        UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
        
    }
    
    /******************************************************
    * takePhoto: IBAction
    *
    * Params: sender
    * Description: asks user whether they would like to select
    *              from library, if not then the user is taken
    *              to the native Photo screen.
    *****************************************************/
    @IBAction func takePhoto(sender: AnyObject) {
        
        var photo_gallery = UIAlertController(title: nil, message: "Would you like to choose and existing photo?", preferredStyle: UIAlertControllerStyle.Alert)
        photo_gallery.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {action in self.open_photoroll() })) //
        photo_gallery.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: {action in self.open_camera() }))
        self.presentViewController(photo_gallery , animated: true, completion: nil)
    }
    
    /******************************************************
    * open_camera: func
    *
    * Description: helper function to navigate to the
    *              native camera screen.
    *****************************************************/
    func open_camera(){
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            var mediaTypes: Array<AnyObject> = [kUTTypeImage]
            picker.mediaTypes = mediaTypes
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
            
            
        } else {
            NSLog("No Camera.")
        }
    }
    
    /******************************************************
    * open_photoroll: func
    *
    * Description: helper function to navigate to the
    *              users photo Library.
    *****************************************************/
    func open_photoroll(){
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            var picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            var mediaTypes: Array<AnyObject> = [kUTTypeImage]
            picker.mediaTypes = mediaTypes
            picker.allowsEditing = true
            self.presentViewController(picker, animated: true, completion: nil)
            
            
        } else {
            NSLog("No Camera.")
        }
    }
    
    /******************************************************
    * imagePickerController: func
    *
    * Description: saves out users photo.
    *****************************************************/
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: NSDictionary!) {
        NSLog("Did Finish Picking")
        let mediaType = info[UIImagePickerControllerMediaType] as String
        var originalImage:UIImage?, editedImage:UIImage?, imageToSave:UIImage?
        
        // Handle a still image capture
        let compResult:CFComparisonResult = CFStringCompare(mediaType as NSString!, kUTTypeImage, CFStringCompareFlags.CompareCaseInsensitive)
        if ( compResult == CFComparisonResult.CompareEqualTo ) {
            
            editedImage = info[UIImagePickerControllerEditedImage] as UIImage?
            originalImage = info[UIImagePickerControllerOriginalImage] as UIImage?
            
            if ( editedImage == nil ) {
                imageToSave = editedImage
            } else {
                imageToSave = originalImage
            }
            NSLog("Write To Saved Photos")
            //cameraView.image = imageToSave
            //cameraView.reloadInputViews()
            
            // Save the new image (original or edited) to the Camera Roll
            UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil)
            
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
	
	func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, error:NSError!) {
	}
	
	func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!,
		error: NSError!) {
		println("Encode error occured")
	}
	
}
    
// MARK: Delegate Method Overrides
/*********************************************************
* Protocol -- AVAudioPlayerDelegate
*
* Extends: MediaViewController
* Parent:  AVAudioPlayerDelegate
* Description: Contains mplementation of methods
*			   required by AVAudioPlayerDelegate
*			   protocol to allow integration of audio
*			   playback.
********************************************************/
extension MediaViewController : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        println("finished playing \(flag)")
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("\(error.localizedDescription)")
    }
}

//---------------------------------------------------------------------------------------------


/*********************************************************
* Subclass -- HomeViewController
*
* Parent: ViewController
* Description: Subclass for unwinging to the Home View
*			   Controller (i.e. the Emergency/Report 
*			   Screen
********************************************************/
class HomeViewController: ViewController {
	@IBAction func unwindToHome (segue : UIStoryboardSegue) {
		
	}
    
    @IBAction func check_connectivity(sender: AnyObject){
        
        //Perform segue since we do have connectivity, else give user alert dialog
        if(isConnectedToNetwork() == true){
            self.proceed()
        }
        else{
            
            //create the alert dialogue
            var not_connected = UIAlertController(title: "Rezi Connectivity", message: "It appear you are currently offline, your report will be unable to be sent immediately. Rezi will recheck for connectivity when you submit your report.", preferredStyle: UIAlertControllerStyle.Alert)
            
            //add the "Cancel" button ( this leaves the user on the home screen )
            not_connected.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            
            //add the "Call Someone" button
            not_connected.addAction(UIAlertAction(title: "Call Someone", style: UIAlertActionStyle.Default, handler: {action in self.call_someone() }))
            
            //add the "Proceed to Report" button
            not_connected.addAction(UIAlertAction(title: "Proceed To Report", style: UIAlertActionStyle.Default, handler: {action in self.proceed() }))
            
            //lets show the dialogue
            self.presentViewController(not_connected , animated: true, completion: nil)
            
        }
        
    }
    
    //segues the user to the report screen
    func proceed(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("ReportTypeViewController") as ViewController
        self.showViewController(vc,sender: true)
    }
    
    //segues the user to the call screen
    func call_someone(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CallScreen") as ViewController
        self.showViewController(vc,sender: true)
        
    }
}

class failureViewController : ViewController {
    
    
}



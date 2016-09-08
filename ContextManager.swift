//
//  ContextManager.swift
//  Rezi_Mobile
//
//  Created by David Kegley on 11/19/14.
//  Copyright (c) 2014 Evan Scott. All rights reserved.
//

import Foundation
import CoreData

class ContextManager {
    
    var managedContext : NSManagedObjectContext
    var report_id : NSManagedObjectID

    class var sharedInstance: ContextManager {

        struct Static {
            static var instance: ContextManager? = nil
            static var token: dispatch_once_t = 0
        }

        dispatch_once(&Static.token) {
            let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            Static.instance = ContextManager(context: managedContext)
        }

        return Static.instance!
    }
    
    init(context : NSManagedObjectContext) {
        managedContext = context
        report_id = NSManagedObjectID()
    }
    
    func getContext() -> NSManagedObjectContext {
        return managedContext
    }
    
    func setReportID(id : NSManagedObjectID) {
        report_id = id
    }
    
    func getReportID() -> NSManagedObjectID {
        return report_id
    }
}
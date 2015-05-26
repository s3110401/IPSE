//
//  LoginViewController.swift
//  IPSE
//
//  Created by Monster on 25/05/2015.
//  Copyright (c) 2015 rmit. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
	
	@IBOutlet weak var username: UITextField!
	@IBOutlet weak var password: UITextField!
	
	@IBAction func loginButton(sender: AnyObject) {
		// Username empty.
		if(username.text.isEmpty){
			let alert = UIAlertView()
			alert.title = "No Username"
			alert.message = "Please enter a username"
			alert.addButtonWithTitle("OK")
			alert.show()
			// Password empty.
		}else if (password.text.isEmpty) {
			let alert = UIAlertView()
			alert.title = "No Password"
			alert.message = "Please enter a password"
			alert.addButtonWithTitle("OK")
			alert.show()
		}else {
			// Send login credentials to server.
			loginRequest()
		}
		
		
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		for login in LoginModel.sharedInstance.logins {
			println("username: " + login.username + "\t password: " + login.password)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	
	func loginRequest(){
		let urlPath: String = "http://foodorderingsystem.mybluemix.net/login/login.php?username=\(username.text)&password=\(password.text)"
		var url: NSURL = NSURL(string: urlPath)!
		var request1: NSURLRequest = NSURLRequest(URL: url)
		let queue:NSOperationQueue = NSOperationQueue()
		NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
			var err: NSError
			var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
			
			if let jsonDictionary = jsonResult as? NSDictionary {
                if let userID = jsonDictionary["id"] as? NSInteger {
                    Model.sharedInstance.setLoggedInUser(userID)
         //           println(userID)
         //           println("userID is above")
                }
				if let success = jsonDictionary["Success"] as? NSString {
                    
					if success == "true" {
						// User has permission to login.
						dispatch_async(dispatch_get_main_queue(),{
                            self.getOrdersForUser()
//							self.loginResult(true)
						})
					}else{
						if(LoginModel.sharedInstance.checkUserPass(self.username.text, password: self.password.text)) {
                            self.getOrdersForUser()
//							self.loginResult(true)
							return
						}
						
						// User does not have permission to login.
						// Login failed
						let alert = UIAlertView()
						alert.title = "Failed Login"
						alert.message = "The username or password was wrong. Please try again"
						alert.addButtonWithTitle("OK")
						alert.show()
					}
				}
			}
			
		})
		
		// println("calling DAO login")
	}
	// foodorderingsystem.mybluemix.net/orders/getorderid.php?accountid=4
	func loginResult(result:Bool) {
		//println(result)
		self.performSegueWithIdentifier("login", sender: nil)
	}
    
    
    func getOrdersForUser(){
        let urlPath: String = "http://foodorderingsystem.mybluemix.net/orders/getorderid.php?accountid=\(Model.sharedInstance.getLoggedInUser())"
        var url: NSURL = NSURL(string: urlPath)!
        var request1: NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request1, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var err: NSError
            var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)
    //        println(jsonResult)
    //        println("--------------->>>><<<-------------")
    //        println(Model.sharedInstance.getLoggedInUser())
            var tempOrderArray = [Int]()
            if let jsonDictionary = jsonResult as? NSDictionary {
                if let orderIDArray = jsonDictionary["products"] as? NSArray {
                    for var i = 0; i < orderIDArray.count; i++ {
                        if var orderIDobj = orderIDArray[i] as? NSDictionary {
                            println("order     IDOP")
                            println(orderIDobj)
                            if var orderIDic = orderIDobj["orderID"] as? NSInteger{
                                tempOrderArray.append(orderIDic)
                                println(orderIDic)
                                println("below)")
                                
                                
                            }
                            println("above this ==============++++++")
                        }
                        
                    }

                    //           println(userID)
                    //           println("userID is above")
                }
                // Add orderID to model
                Model.sharedInstance.setOrderID(tempOrderArray)
                
                dispatch_async(dispatch_get_main_queue(),{
//                    self.getOrdersForUser()
                    self.loginResult(true)
                })
                
//                if let success = jsonDictionary["Success"] as? NSString {
//                    
//                    if success == "true" {
//                        // User has permission to login.
//                        dispatch_async(dispatch_get_main_queue(),{
//                            self.loginResult(true)
//                        })
//                    }else{
//                        if(LoginModel.sharedInstance.checkUserPass(self.username.text, password: self.password.text)) {
//                            self.loginResult(true)
//                            return
//                        }
//                        
//                        // User does not have permission to login.
//                        // Login failed
//                        let alert = UIAlertView()
//                        alert.title = "Failed Login"
//                        alert.message = "The username or password was wrong. Please try again"
//                        alert.addButtonWithTitle("OK")
//                        alert.show()
//                    }
//                }
            }
            
        })
        
        // println("calling DAO login")
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

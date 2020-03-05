//
//  ViewController.swift
//  Concurrency_in_iOS
//
//  Created by Ashis Laha on 02/03/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		let concurrentModel = ConcurrencyModel()
		concurrentModel.solveConcurrencyWithOperationQueue()
	}
}

struct URLStrings {
	static let google = "https://www.google.com"
	static let apple = "https://www.apple.com"
	static let microsoft = "https://www.microsoft.com/en-in/"
	static let linkedIn = "https://www.linkedin.com"
	static let github = "https://github.com"
}


class ConcurrencyModel {
	
	/*
		define the dependency graph:
			google <-- apple
			apple <-- microsoft
			apple <-- linkedIn
			(microsoft & linkedIn) <-- github
		
	*/
	
	// Solution 1: Hectic appraoch: Using GCD
	
	
	
	// solution 2: using Operations and OperationQueue
	func solveConcurrencyWithOperationQueue() {
		
		
		let dispatchGroup = DispatchGroup()
		
		// step1: create operations
		let googleOperation = BlockOperation {
			dispatchGroup.enter()
			
			NetworkLayer.get(urlString: URLStrings.google, successBlock: { (data) in
				print("Google Call Success")
				dispatchGroup.leave()
				
			}) { (error) in
				print("Google call failed")
				dispatchGroup.leave()
			}
		}
		googleOperation.completionBlock = {
			print("Google sync block has been executed \n")
		}
		
		let appleOperation = BlockOperation {
			dispatchGroup.enter()
			
			NetworkLayer.get(urlString: URLStrings.apple, successBlock: { (data) in
				print("Apple Call Success")
				dispatchGroup.leave()
				
			}) { (error) in
				print("Apple call failed")
				dispatchGroup.leave()
			}
		}
		
		let microsoftOperation = BlockOperation {
			dispatchGroup.enter()
			
			NetworkLayer.get(urlString: URLStrings.microsoft, successBlock: { (data) in
				print("Microsoft Call Success")
				dispatchGroup.leave()
				
			}) { (error) in
				print("Microsoft call failed")
				dispatchGroup.leave()
			}
		}
		
		let linkedInOperation = BlockOperation {
			dispatchGroup.enter()
			
			NetworkLayer.get(urlString: URLStrings.linkedIn, successBlock: { (data) in
				print("LinkedIn Call Success")
				dispatchGroup.leave()
				
			}) { (error) in
				print("LinkedIn call failed")
				dispatchGroup.leave()
			}
		}
		
		let gitHubOperation = BlockOperation {
			dispatchGroup.enter()
			
			NetworkLayer.get(urlString: URLStrings.github, successBlock: { (data) in
				print("GitHub Call Success")
				dispatchGroup.leave()
				
			}) { (error) in
				print("GitHub call failed")
				dispatchGroup.leave()
			}
		}
		
		// step 2: add dependencies
		appleOperation.addDependency(googleOperation)
		microsoftOperation.addDependency(appleOperation)
		linkedInOperation.addDependency(appleOperation)
		[microsoftOperation, linkedInOperation].forEach { gitHubOperation.addDependency($0) }
		
		// step 3: create operation Queue
		let operationQueue = OperationQueue()
		operationQueue.maxConcurrentOperationCount = 2
		let operations = [googleOperation, appleOperation, microsoftOperation, linkedInOperation, gitHubOperation]
		operationQueue.addOperations(operations, waitUntilFinished: false)
		
		// step 4: we want to do some operation at the end of completion: Dispatch Group will help here
		dispatchGroup.notify(queue: .main) {
			print("\n 🏝 All operations has been completed")
		}
	}
	
}


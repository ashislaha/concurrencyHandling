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
		
		// approach - 1
		let concurrentModel = OperationQueueConcurrencyModel()
		concurrentModel.solveConcurrencyWithOperationQueue()
		
		// approach - 2
		//let gcdConcurrentModel = GCDConcurrencyModel()
		//gcdConcurrentModel.solveConcurrencyWithGCD()
	}
}


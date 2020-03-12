//
//  NetworkLayer.swift
//  Concurrency_in_iOS
//
//  Created by Ashis Laha on 02/03/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import UIKit

enum NetworkRequest: String {
	case GET = "GET"
	case POST = "POST"
	case DELETE = "DELETE"
	case PUT = "PUT"
}

typealias SuccessBlock = ((Any?) -> ())
typealias FailureBlock = ((Any?) -> ())

class NetworkLayer {
	
	public class func get(urlString: String, successBlock: SuccessBlock?, failureBlock: FailureBlock?) {
		
		print("📡 started: \(urlString)")
		
		guard !urlString.isEmpty, let url = URL(string: urlString)
			else {
				return
		}
	
		let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
			if let data = data, error == nil {
				successBlock?(data)
			} else {
				failureBlock?(error)
			}
		}
		dataTask.resume()
		
	}
}

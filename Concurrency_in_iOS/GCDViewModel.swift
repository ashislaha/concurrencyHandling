//
//  ViewModel.swift
//  Concurrency_in_iOS
//
//  Created by Ashis Laha on 07/03/20.
//  Copyright © 2020 Ashis Laha. All rights reserved.
//

import Foundation


class GCDConcurrencyModel {
	
	/*
		define the dependency graph:
			google <-- apple
			apple <-- microsoft
			apple <-- linkedIn
			(microsoft & linkedIn) <-- github
		
	*/
	
	// Solution 2: Hectic appraoch: Using GCD
	
	func solveConcurrencyWithGCD() {
		
		//step 1: start with google
		callGoogleApi(successBlock: { (googleData) in
			print("🎾 GCD: Google called success")
			
			//step 2: call Apple API
			self.callAppleApi(successBlock: { (appleData) in
				
				print("🎾 GCD: Apple called success")
				
				// step 3: microsoft and linked are independent to each other, but depends on Apple output
				// but interestingly, gitHub depends on both
				var dictionary: [String: Bool] = [
					"isMicrosoftCompleted": false,
					"isLinkedCompleted": false
				]
				
				// microsoft
				self.callMicrosoftApi(successBlock: { (microsoftData) in
					dictionary["isMicrosoftCompleted"] = true
					
					print("🎾 GCD: Microsoft called success")
					if let isLinkedInCallCompleted = dictionary["isLinkedCompleted"], isLinkedInCallCompleted {
						
						// step 4: call Github as both Microsoft and LinkedCall completed
						self.callGitHubApi(successBlock: { (gitHubData) in
							print("🎾 GCD: GitHub called success")
						}, failureBlock: { (gitHubError) in
							
						})
					}
					
				}) { (microsoftError) in
					dictionary["isMicrosoftCompleted"] = true
					
					// TODO: we need to do the same, check isLinkedInCompleted, if true then call GitHub API
				}
				
				// linkedIn
				self.callLinkedInApi(successBlock: { (linkedInData) in
					dictionary["isLinkedCompleted"] = true
					
					print("🎾 GCD: LinkedIn called success")
					
					if let isMicrosoftCallCompleted = dictionary["isMicrosoftCompleted"], isMicrosoftCallCompleted {
						
						// step 4: call Github as both Microsoft and LinkedCall completed
						self.callGitHubApi(successBlock: { (gitHubData) in
							print("🎾 GCD: GitHub called success")
						}, failureBlock: { (gitHubError) in
							
						})
					}
					
				}, failureBlock: { (linkedInData) in
					dictionary["isLinkedCompleted"] = true
					
					// TODO: we need to do the same, check isMicrosoftCompleted, if true then call GitHub API
				})
				
			}, failureBlock: { (appleError) in
				
			})
			
		}) { (googleError) in
			
			print("🎾 GCD: Google called failed")
			// TODO: we need the similar way to handle the remaining APIs as above.
		}
		
	}
	
	private func callGoogleApi(successBlock: SuccessBlock?, failureBlock: FailureBlock?) {
		DispatchQueue.global(qos: .background).async {
			NetworkLayer.get(urlString: URLStrings.google, successBlock: successBlock, failureBlock: failureBlock)
		}
	}
	
	private func callAppleApi(successBlock: SuccessBlock?, failureBlock: FailureBlock?) {
		DispatchQueue.global(qos: .background).async {
			NetworkLayer.get(urlString: URLStrings.apple, successBlock: successBlock, failureBlock: failureBlock)
		}
	}
	
	private func callMicrosoftApi(successBlock: SuccessBlock?, failureBlock: FailureBlock?) {
		DispatchQueue.global(qos: .background).async {
			NetworkLayer.get(urlString: URLStrings.microsoft, successBlock: successBlock, failureBlock: failureBlock)
		}
	}
	
	private func callLinkedInApi(successBlock: SuccessBlock?, failureBlock: FailureBlock?) {
		DispatchQueue.global(qos: .background).async {
			NetworkLayer.get(urlString: URLStrings.linkedIn, successBlock: successBlock, failureBlock: failureBlock)
		}
	}
	
	private func callGitHubApi(successBlock: SuccessBlock?, failureBlock: FailureBlock?) {
		DispatchQueue.global(qos: .background).async {
			NetworkLayer.get(urlString: URLStrings.github, successBlock: successBlock, failureBlock: failureBlock)
		}
	}
}


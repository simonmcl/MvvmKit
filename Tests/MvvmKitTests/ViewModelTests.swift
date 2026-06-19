//
//  ViewModelTests.swift
//  MvvmKit
//
//  Created by Simon McLoughlin on 19/06/2026.
//

import Testing
import Observation
@testable import MvvmKit





// MARK: Basic ViewModel setup and test

@MainActor
@Observable
class ViewModelTest: ViewModel {
	var isLoading: Bool
	var error: (any Error)?
	
	var count: Int = 0
	
	init() {
		// Open to each implementation to decide if loading behaviour (Activity animation, skeleton tableview, etc) is displayed automatically on view init, until .load() is called
		isLoading = true
	}
	
	func load() async -> Bool {
		isLoading = true
		
		try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 second delay to simulate network
		count += 1
		isLoading = false
		
		return true
	}
}

@Test @MainActor func viewModelSetup() async throws {
	
	let vm = ViewModelTest()
	#expect(vm.isLoading)
	#expect(vm.count == 0)
	
	_ = await vm.load()
	#expect(!vm.isLoading)
	#expect(vm.count == 1)
	
	_ = await vm.load()
	#expect(!vm.isLoading)
	#expect(vm.count == 2)
}






// MARK: ViewModel with input test

@MainActor
@Observable
class ViewModelInputTest: ViewModelWithInput {
	
	struct Profile: Codable	{
		let username: String
	}
	
	typealias ViewModelInput = Profile
	
	var isLoading: Bool
	var error: (any Error)?
	
	var count: Int = 0
	
	init() {
		// Open to each implementation to decide if loading behaviour (Activity animation, skeleton tableview, etc) is displayed automatically on view init, until .load() is called
		isLoading = true
	}
	
	func load(withInput input: Profile) async -> Bool {
		isLoading = true
		
		try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 second delay to simulate network
		
		if input.username == "john_doe" {
			count += 1
			
		} else {
			count += 5
		}
		
		isLoading = false
		
		return true
	}
}

@Test @MainActor func viewModelWithInputSetup() async throws {
	
	let vm = ViewModelInputTest()
	let profileJohn = ViewModelInputTest.Profile(username: "john_doe")
	let profileJane = ViewModelInputTest.Profile(username: "jane_doe")
	
	#expect(vm.isLoading)
	#expect(vm.count == 0)
	
	_ = await vm.load(withInput: profileJohn)
	#expect(!vm.isLoading)
	#expect(vm.count == 1)
	
	_ = await vm.load(withInput: profileJane)
	#expect(!vm.isLoading)
	#expect(vm.count == 6)
}

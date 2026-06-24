//
//  ViewModel.swift
//  MvvmKit
//
//  Created by Simon McLoughlin on 18/06/2026.
//

import UIKit
import Observation



// MARK: UIViewController ViewModels

/**
 A ViewModel protocol that enforces @MainActor and @Observable (sort of, limited in options) to all ViewModels,
 with a standardised contract between the Controller and the the ViewModel.
 
 For the sake of being explicit about the contract, this protocol is designed for ViewModels that require no direct input to
 prefrom its specific business logic. E.g. Requesting data from a known URL that requires no parameters.
 */
@MainActor
public protocol ViewModel: Observable {
	var isLoading: Bool { get set }
	var error: Error? { get set }
	
	mutating func load() async -> Bool
}

/**
 A ViewModel protocol that enforces @MainActor and @Observable (sort of, limited in options) to all ViewModels,
 with a standardised contract between the Controller and the the ViewModel.
 
 For the sake of being explicit about the contract, this protocol is designed for ViewModels that require and input to preform
 its business logic. E.g. Requiring a username and password to complete a login request.
 */
@MainActor
public protocol ViewModelWithInput: Observable {
	associatedtype ViewModelInput
	
	var isLoading: Bool { get set }
	var error: Error? { get set }
	
	mutating func load(withInput input: ViewModelInput) async -> Bool
}



// MARK: UITableView ViewModels


/**
 A ViewModel protocol, designed to work with UITableViews,  that enforces @MainActor and @Observable (sort of, limited in options) to all ViewModels,
 with a standardised contract between the Controller and the the ViewModel.
 
 This ViewModel expects to receive no input to preform its business logic, and will ensure a variable of type `[UITableViewSectionModel]`called `tableViewData`
 will be populated by the end of the function `load()`. This variable can be passed directly to a `UITableView`'s new `tableViewData` property.
 */
@MainActor
public protocol ViewModelWithTableView: Observable {
	var isLoading: Bool { get set }
	var error: Error? { get set }
	var tableViewData: [UITableViewSectionModel] { get set}
	
	mutating func load() async -> Bool
	func registerExternalCells(for tableView: UITableView)
}

/**
 A ViewModel protocol, designed to work with UITableViews,  that enforces @MainActor and @Observable (sort of, limited in options) to all ViewModels,
 with a standardised contract between the Controller and the the ViewModel.
 
 This ViewModel expects to receive an input to preform its business logic, and will ensure a variable of type `[UITableViewSectionModel]`called `tableViewData`
 will be populated by the end of the function `load()`. This variable can be passed directly to a `UITableView`'s new `tableViewData` property.
 */
@MainActor
public protocol ViewModelWithTableViewAndInput: Observable {
	associatedtype ViewModelInput
	
	var isLoading: Bool { get set }
	var error: Error? { get set }
	var tableViewData: [UITableViewSectionModel] { get set}
	
	mutating func load(withInput input: ViewModelInput) async -> Bool
	func registerExternalCells(for tableView: UITableView)
}

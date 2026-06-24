//
//  UITableViewCell+MVVM.swift
//  MvvmKit
//
//  Created by Simon McLoughlin on 19/06/2026.
//

import UIKit

/**
 A protocol for defining a data driven approach to `UITableView`s and `UITableViewCell`.
 The struct created by the VIewModel will denote which `UITableViewCell` class will be loaded to handle its data.
 The class will enable the autocompletion of the cellForRowAtIndexPath delegate
 */
public protocol UITableViewCellModel {
	
	/// The MVVM compliant class to use for this model. E.g. `ProfileCell.Type`
	var cell: UITableViewCellMVVM.Type { get }
}


/**
 A protocol to define the requirements for a `UITableViewCell` to be able to be autoamtically dequeued and registered for a given `UITableView`
 */
@MainActor
public protocol UITableViewCellMVVM: UITableViewCell {
	
	static var staticIdentifier: String { get }
	
	func setup(withModel model: UITableViewCellModel)
}

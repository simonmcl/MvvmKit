//
//  UITableViewMutation.swift
//  MvvmKit
//
//  Created by Simon McLoughlin on 14/08/2026.
//

import UIKit

public struct UITableViewMutation {
	public var insertedRows: [IndexPath]
	public var deletedRows: [IndexPath]
	public var reloadedRows: [IndexPath]
	public var insertedSections: IndexSet
	public var deletedSections: IndexSet
	public var reloadedSections: IndexSet
	public var animation: UITableView.RowAnimation
	
	public init(
		insertedRows: [IndexPath] = [],
		deletedRows: [IndexPath] = [],
		reloadedRows: [IndexPath] = [],
		insertedSections: IndexSet = [],
		deletedSections: IndexSet = [],
		reloadedSections: IndexSet = [],
		animation: UITableView.RowAnimation = .automatic
	) {
		self.insertedRows = insertedRows
		self.deletedRows = deletedRows
		self.reloadedRows = reloadedRows
		self.insertedSections = insertedSections
		self.deletedSections = deletedSections
		self.reloadedSections = reloadedSections
		self.animation = animation
	}
}

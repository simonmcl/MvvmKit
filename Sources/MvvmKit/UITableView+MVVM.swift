//
//  UITableView+MVVM.swift
//  MvvmKit
//
//  Created by Simon McLoughlin on 19/06/2026.
//

import UIKit

/**
 Following an approach from this article: https://medium.com/@valv0/computed-properties-and-extensions-a-pure-swift-approach-64733768112c
 to add a variable to all tableViews without subclassing or having manual boilerplate.
 
 Using the setter, we can capture if the tableview received the data it needed. If so the tableView can now handle its own datasource methods, and the delegate can handle user interactions
 */
public extension UITableView {
	private static var _tableViewDataProperty = [String: [UITableViewSectionModel]?]()
	
	var tableViewData: [UITableViewSectionModel]? {
		get {
			let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
			return UITableView._tableViewDataProperty[tmpAddress] ?? nil
		}
		
		set(newValue) {
			let tmpAddress = String(format: "%p", unsafeBitCast(self, to: Int.self))
			
			if newValue != nil {
				self.dataSource = self
				
			} else {
				self.dataSource = nil
			}
			
			UITableView._tableViewDataProperty[tmpAddress] = newValue
		}
	}
}

/**
 When the `tableViewData` property has been set, we can now conform to the datasource methods as we know what shape the data will take.
 */
extension UITableView: @retroactive UITableViewDataSource {
	
	/**
	 MVVM implementation of `numberOfSectionsInTableView` as it will always be the same when using a viewModel.
	 */
	public func numberOfSections(in tableView: UITableView) -> Int {
		guard let data = tableViewData else { return 0 }
		
		return data.count
	}
	
	/**
	 MVVM implementation of `numberOfRowsInSection` as it will always be the same when using a viewModel.
	 */
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let data = tableViewData else { return 0 }
		
		return data[section].cellModels.count
	}
	
	/**
	 MVVM implementation of `cellForRowAtIndexPath` as it will always be the same when using a viewModel.
	 */
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let data = tableViewData else { return UITableViewCell() }
		
		let cellModel = data[indexPath.section].cellModels[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.cell.staticIdentifier, for: indexPath)
		
		if let mvvmCell = cell as? UITableViewCellMVVM {
			mvvmCell.setup(withModel: cellModel)
			return cell
			
		} else {
			print("WARNING: CellId: \(cellModel) returned a cell of type \(String(describing: cell.self)), which does not confirm to UITableViewCellMVVM")
			return UITableViewCell()
		}
	}
	
	/**
	 MVVM implementation of `titleForHeaderInSection` as it will always be the same when using a viewModel.
	 */
	public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		guard let header = tableViewData?[section].header else { return nil }
		
		return header
	}
	
	/**
	 MVVM implementation of `titleForFooterInSection` as it will always be the same when using a viewModel.
	 */
	public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		guard let footer = tableViewData?[section].footer else { return nil }
		
		return footer
	}
}

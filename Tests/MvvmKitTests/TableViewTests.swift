//
//  TableViewTests.swift
//  MvvmKit
//
//  Created by Simon McLoughlin on 19/06/2026.
//

import Testing
import UIKit
@testable import MvvmKit


// MARK: UIViewController setup

// A simple cell model containing the cell type is bound too, and a username string
struct ProfileCellModel: UITableViewCellModel {
	let cell: UITableViewCellMVVM.Type = ProfileCell.self
	let username: String
}


// A simple cell that denotes its reuse identifier, creates a label (not added to view as its not needed for this test), and sets the text based on the model passed in
class ProfileCell: UITableViewCell, UITableViewCellMVVM {
	
	static var staticIdentifier: String = "ProfileCell"
	
	let label = UILabel()
	
	func setup(withModel model: UITableViewCellModel) {
		guard let model = model as? ProfileCellModel else { return }
		
		label.text = model.username
	}
}

// A viewModel that simulates a networking call to fetch the username, then builds a struture of models that will drive the table view automatically
@MainActor
@Observable
class ProfileViewModel: ViewModelWithTableView {
	var isLoading: Bool
	var error: (any Error)?
	
	var tableViewData: [UITableViewSectionModel] = [.init(withHeader: nil, footer: nil, andCellModels: [])]
	
	init() {
		isLoading = true
	}
	
	func load() async -> Bool {
		try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second delay to simulate network
		
		tableViewData = [
			.init(withHeader: nil, footer: nil, andCellModels: [
				ProfileCellModel(username: "john_doe")
			])
		]
		
		isLoading = false
		return true
	}
	
	func registerExternalCells(for tableView: UITableView) {
		let externalCells = [ ProfileCell.self ]
		
		for cell in externalCells {
			tableView.register(cell.self, forCellReuseIdentifier: cell.staticIdentifier)
		}
	}
}

// A ViewController containing a tableView, which uses the ProfileViewModel to automatically handle all the datasource methods
class ProfileViewController: UIViewController {
	let tableView: UITableView = UITableView()
	let viewModel = ProfileViewModel()
	
	override func viewDidLoad() {
		Task {
			viewModel.registerExternalCells(for: tableView)
			_ = await viewModel.load()
			updatePropertiesIfNeeded() // Needed to work in this context, possibly due to artifical Test setup
		}
	}
	
	override func updateProperties() {
		super.updateProperties()
		
		tableView.tableViewData = viewModel.tableViewData
		tableView.reloadData()
	}
}



// MARK: Tests

@Test @MainActor func tableViewWithMVVM() async throws {
	let vc = ProfileViewController()
	
	vc.viewDidLoad()
	
	try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 second delay to simulate network
	
	// Confirm the viewModel data has been updated
	#expect(vc.viewModel.tableViewData.count == 1)
	#expect(vc.viewModel.tableViewData[0].cellModels.count == 1)
	#expect(vc.viewModel.tableViewData[0].cellModels[0].cell.staticIdentifier == "ProfileCell")
	
	// Confirm the tableView has picked up this update and correctly dequeued the relevant cell
	#expect(vc.tableView.numberOfSections == 1)
	#expect(vc.tableView.numberOfRows(inSection: 0) == 1)
	
	let cell = vc.tableView.cellForRow(at: IndexPath(row: 0, section: 0))
	let profileCell = cell as? ProfileCell
	#expect(profileCell != nil)
}

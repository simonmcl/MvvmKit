//
//  UITableViewSectionModel.swift
//  MvvmKit
//
//  Created by Simon McLoughlin on 19/06/2026.
//

/**
 An Array of this struct will be used to compute `UITableView`'s data source methods automatically.
 
 - By counting the number of structs, we can automatically figure out the number of sections.
 - By counting the number of `cellModels`, we can automatically figure out the number of rows per section.
 - `UITableViewCellModel` gives us all the data we need to configure the cell and set its data.
 - `header` / `footer` properties allow us to set section headers / footers if needed.
 */
public struct UITableViewSectionModel {
	
	/**
	 Optional string to be used as the section header.
	 */
	let header: String?
	
	/**
	 Optional string to be used as the section footer.
	 */
	let footer: String?
	
	/**
	 Required array of `UITableViewCellModel` to be used to configure each cell in the section.
	 */
	let cellModels: [UITableViewCellModel]
	
	/**
	 init()
	 
	 - Parameter header: Optional header text for this section.
	 - Parameter footer: Optional footer text for this section.
	 - Parameter cellModels: An array of objects conforming to `UITableViewCellModel`. This is required to configure each cell in the section.
	 */
	init(withHeader header: String?, footer: String?, andCellModels models: [UITableViewCellModel]) {
		self.header = header
		self.footer = footer
		self.cellModels = models
	}
}

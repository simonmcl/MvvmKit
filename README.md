# MvvmKit

This Swift package provides a set of lightweight protocols, models, and helper functions, to bring a lightweight MVVM architecture to Swift based apps. The goal of this project is to avoid massive architecture frameworks touching every single line of code, forcing patterns throughout the entire codebase. Instead we simply provide an bunch of opt-in protocols to reduce boilerplate code, and standarise the contracts between the Controller and the ViewModel.

ViewModels are defeined as below, enforcing `@MainActor` and `@Observable` compliance. With two different variations to allow the ViewModel to be explicit about its input requirements.

```Swift
@MainActor
protocol ViewModel: Observable {
	var isLoading: Bool { get set }
	var error: Error? { get set }

	mutating func load() async -> Bool
}

@MainActor
protocol ViewModelWithInput: Observable {
	associatedtype ViewModelInput

	var isLoading: Bool { get set }
	var error: Error? { get set }

	mutating func load(withInput input: ViewModelInput) async -> Bool
}
```

The package also includes a lightweight opt-in, model driven approach, to removing boilrerplate code setting up `UITableView`s and `UITableViewCell`s. A new `UITableView` extension uses a technique to inject a new property into all tableViews

```Swift
var tableViewData: [UITableViewSectionModel]?
```

alongside dedicated "TableView" ViewModel variations to again provide the contract. Constructing an array of this object and passing it to a tableView, triggers logic to automatically wire up a `UITableViewDataSource` implementation that will handle sections, rows, text based headers, dequeue's and registrations, by simply providing a near 2D array of structs

E.g.

```Swift
tableViewData = [
	.init(withHeader: nil, footer: nil, andCellModels: [
		ProfileCellModel(username: "john_doe", avatar: "....png"),
		OccupationCellModel(title: "Software Engineer", type: .engineering)
	]),
	.init(withHeader: "Projects", footer: nil, andCellModels: [
		ProjectCellModel(title: "Project1", description: "..."),
		ProjectCellModel(title: "Project2", description: "..."),
		ProjectCellModel(title: "Project3", description: "..."),
	])
]
```

See unit tests for some very basic examples of each.

Need more flexibility? Need to run highly custom logic inplace of this? No problem, just don't conform to the protocols, or don't set the tableView property, or do one but not the other. Flexibility and opt-in is key, as there is no such thing as a one size fits all architecture. Use what works, where it works.

**Wanring:**

Project is in very early stages, subject to big and small changes, while working on on-groing projects to experiment with it.

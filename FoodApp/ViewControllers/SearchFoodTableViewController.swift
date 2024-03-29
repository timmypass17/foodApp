//
//  SearchFoodTableViewController.swift
//  FoodApp
//
//  Created by Timmy Nguyen on 3/1/24.
//

import UIKit

class SearchFoodTableViewController: UITableViewController {

    var history: [CDFood] = []
    
    var searchController: UISearchController!
    private var resultsTableController: ResultsTableViewController!
    
    var meal: Meal?
    let foodService: FoodService
    var searchTask: Task<Void, Never>? = nil
    var debounceTimer: Timer?
    
    weak var delegate: FoodDetailTableViewControllerDelegate?
    
    init(foodService: FoodService, meal: Meal? = nil) {
        self.history = CoreDataStack.shared.getFoodHistory()
        self.foodService = foodService
        self.meal = meal
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.reuseIdentifier)
        if let meal, let meals = meal.mealPlan?.meals {
            let titleView = SearchTitleView(selectedMeal: meal, meals: meals)
            titleView.delegate = self
            navigationItem.titleView = titleView
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", primaryAction: cancelButtonTapped())
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", primaryAction: doneButtonTapped())
        
        resultsTableController = ResultsTableViewController(meal: meal, foodService: foodService)
        resultsTableController.delegate = delegate
        resultsTableController.historyDelegate = self
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        
        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
        
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.reuseIdentifier, for: indexPath) as! HistoryTableViewCell
        cell.delegate = self
        let food = history[indexPath.row]
        cell.update(with: food)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let food = history[indexPath.row]
        let detailVC = FoodDetailTableViewController(food: food.convertToFDCFood(), meal: meal, foodService: foodService)
        detailVC.delegate = delegate
        detailVC.historyDelegate = self
        present(UINavigationController(rootViewController: detailVC), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "History"
    }
    
    func cancelButtonTapped() -> UIAction {
        return UIAction { _ in
            self.dismiss(animated: true)
        }
    }
    
    func doneButtonTapped() -> UIAction {
        return UIAction { _ in
            self.dismiss(animated: true)
        }
    }
}


// MARK: - UISearchBarDelegate

extension SearchFoodTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Task {
            do {
                let foods: [Food] = try await foodService.getFoods(query: searchBar.text!)
                resultsTableController.foods = foods
                resultsTableController.tableView.reloadData()
            } catch {
                print("\(#function) \(error)")
            }
        }
        searchBar.resignFirstResponder()
    }
    
}


// MARK: - UISearchControllerDelegate

// Use these delegate functions for additional control over the search controller.

extension SearchFoodTableViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
}

extension SearchFoodTableViewController: SearchTitleViewDelegate {
    func searchTitleView(_ sender: SearchTitleView, didSelectMeal meal: Meal) {
        self.meal = meal
    }
}

extension SearchFoodTableViewController: FoodDetailTableViewControllerHistoryDelegate {
    func foodDetailTableViewController(_ tableViewController: FoodDetailTableViewController, didUpdateHistoryWithFood food: CDFood) {
        if !history.contains(food) {
            history.append(food)
        }
        history = history.sorted { $0.updatedAt > $1.updatedAt }
        tableView.reloadData()
    }
}

extension SearchFoodTableViewController: HistoryTableViewCellDelegate {
    func historyTableViewCell(_ cell: HistoryTableViewCell, didDeleteFood food: CDFood) {
        guard let row = history.firstIndex(where: { $0 == food }) else { return }
        history.remove(at: row)
        let indexPath = IndexPath(row: row, section: 0)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

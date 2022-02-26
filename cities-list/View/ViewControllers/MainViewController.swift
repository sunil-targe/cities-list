//
//  MainViewController.swift
//  country-list
//
//  Created by Sunil Targe on 2022/2/26.
//

import UIKit

class MainViewController: UITableViewController {
    var activityView: UIActivityIndicatorView?
    
    private var searching = false
    
    // View model instance
    lazy var viewModel: ViewModel = {
        return ViewModel()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
    }

    // Naive binding
    private func initViewModel() {
        // closure for network check, empty data and server side error
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert( message )
                }
            }
        }
        
        // closure to manage loading status
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.showLoader()
                }else {
                    self?.hidLoader()
                }
            }
        }
        
        // closure to reload tableview once data sucessfully fetched
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        // fetch initial data
        viewModel.initFetch()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searching, let result = viewModel.searchedCities {
            return "\(result.count) result 🔍"
        }
        
        if let cities = viewModel.cities {
            return "\(cities.count) cities"
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return viewModel.searchedCities?.count ?? 0
        } else {
            return viewModel.cities?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as? CityTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        if searching {
            guard let cities = viewModel.searchedCities else {
                return cell
            }
            cell.configure(with: cities[indexPath.row])
        } else {
            guard let cities = viewModel.cities else {
                return cell
            }
            cell.configure(with: cities[indexPath.row])
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searching {
            guard let cities = viewModel.searchedCities else { return }
            gotoNext(with: cities[indexPath.row])
        } else {
            guard let cities = viewModel.cities else { return }
            gotoNext(with: cities[indexPath.row])
        }
    }
}

        
// MARK:-
extension MainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searching = false
            tableView.reloadData()
        } else {
            searching = true
            viewModel.searching(by: searchText)
        }
    }
}


// MARK:-
class CityTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    fileprivate func configure(with city: City) {
        titleLabel.text = "\(city.name), \(city.country)"
        descLabel.text = "Long:\(city.coord.lon), Lat:\(city.coord.lat)"
    }
}

//
//  LocationsViewController.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/26/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import UIKit
import MapKit

private let reuseIdentifier = "LocationCell"

class LocationsViewController: UITableViewController, MKLocalSearchCompleterDelegate {
    
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    var searchCompleter = MKLocalSearchCompleter()
    
    var matchingItems: [MKLocalSearchCompletion] = []
    var mapView: MKMapView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        searchCompleter.delegate = self
        
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.matchingItems = completer.results
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        let item = matchingItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let mapView = mapView else {
            return
        }
        
        let selectedItem = matchingItems[indexPath.row]
        let request = MKLocalSearch.Request(completion: selectedItem)
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self] response, _ in
            guard let response = response else {
                return
            }
            self?.handleMapSearchDelegate?.dropPinZoomIn(response.mapItems[0].placemark)
            self?.dismiss(animated: true, completion: nil)
        }
        
    }

}

extension LocationsViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let _ = mapView,
            let searchBarText = searchController.searchBar.text else {
            return
        }
        
        searchCompleter.queryFragment = searchBarText
    }
}

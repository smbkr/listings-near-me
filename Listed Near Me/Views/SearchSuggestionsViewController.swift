//
//  SearchResultsViewController.swift
//  Listed Near Me
//
//  Created by Stuart Baker on 14/09/2020.
//  Copyright © 2020 Stuart Baker. All rights reserved.
//

import UIKit

class SearchSuggestionsViewController: UIViewController {
    
    private var recent: [String] = ["Foo"]
    
}

extension SearchSuggestionsViewController: UISearchControllerDelegate {
    
}

extension SearchSuggestionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Search result 1"
        return cell
    }
    
    
}

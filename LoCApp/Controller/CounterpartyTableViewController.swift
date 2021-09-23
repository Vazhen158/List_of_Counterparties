//
//  CounterpartyTableViewController.swift
//  LoCApp
//
//  Created by Андрей Важенов on 21.09.2021.
//

import UIKit

class CounterpartyTableViewController: UITableViewController {
    var viewModel = CounterpartyModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Counterparty"
        viewModel.connectToDatabase()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
        // сортировка по алфавиту не учитывая регистра
        viewModel.counterpartyArray.sort() { $0.name.lowercased() < $1.name.lowercased() }
        tableView.reloadData()
        
    }
    private func loadData() {
        viewModel.loadDataFromSQLiteDatabase()
    }
    
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        viewModel.numberOfRowsInSection(section: section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
       
        let object = viewModel.cellForRowAt(indexPath: indexPath)
       
       
        if let counterpartyCell = cell as? CounterpartyTableViewCell {
            counterpartyCell.setCellWithValuesOf(object)
            
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let counterparty = viewModel.cellForRowAt(indexPath: indexPath)
            
            // Delete counterparty from database table
            SQLiteCommands.deleteRow(counterpartyId: counterparty.id)
            
            // Updates the UI after delete changes
            self.loadData()
            self.tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass the selected object to the new view controller.
        if segue.identifier == "editCounterparty" {
            guard let newCounterpartyVC = segue.destination as? NewCounterpartyViewController else {return}
            guard let selectedCounterpartyCell = sender as? CounterpartyTableViewCell else {return}
            if let indexPath = tableView.indexPath(for: selectedCounterpartyCell) {
                let selectedCounterparty = viewModel.cellForRowAt(indexPath: indexPath)
                newCounterpartyVC.viewModel = NewCounterpartyModel(counterpartyValues: selectedCounterparty)
            }
            
        }
    }
}

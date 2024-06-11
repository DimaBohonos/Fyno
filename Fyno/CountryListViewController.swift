//
//  CountryListViewController.swift
//  Fyno
//
//  Created by dima on 08.06.2024.
//

import UIKit

class CountryListViewController: UIViewController {
    
    var saveActionHandler: (([CountryModel]) -> Void)?
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedCountries: [CountryModel] = [] {
        didSet{
            self.reloadTable()
        }
    }
    
    var countryList: [CountryModel] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTable()
        
    }
    
    func reloadTable() {
        
        let countries = FynoManager.shared.totalCountriesList
        
        countryList = countries.sorted { item1, item2 in
            if selectedCountries.contains(where: { item3 in
                item1.isoCountryCodes == item3.isoCountryCodes
            }) {
                return true
            }
            
            return false
        }
        
        
        self.tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        countryList = FynoManager.shared.totalCountriesList
        
        // Do any additional setup after loading the view.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func saveButtonAction(_ sender: UIButton?) {
        saveActionHandler?(selectedCountries)
        self.dismiss(animated: true)
    }

}

extension CountryListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CountryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CountryTableViewCell
        
        let item = countryList[indexPath.row]
        cell.countryInfo = item
        
        cell.enable = self.selectedCountries.contains(where: { item2 in
            return item2.isoCountryCodes == item.isoCountryCodes
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = countryList[indexPath.row]
        if self.selectedCountries.contains(where: { item2 in
            return item2.isoCountryCodes == item.isoCountryCodes
        }) {
            selectedCountries.removeAll { item2 in
                return item2.isoCountryCodes == item.isoCountryCodes
            }
        }else{
            selectedCountries.append(item)
        }
        
    }
    
}

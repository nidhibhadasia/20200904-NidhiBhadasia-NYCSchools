//
//  SchoolListViewController.swift
//  20200904-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 9/4/20.
//  Copyright © 2020 Nidhi. All rights reserved.
//

import UIKit

class SchoolListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    let refreshCntl = UIRefreshControl()
   
    // Below Flags are to maintain expand collapse
    var selectedRowIndex = -1
    var previousRowIndex = -1
    // lastElementIndex Flag to maintain API call by page
    var lastElementIndex = 0
    // TableView Datasource array
    var arSchoolVM = [SchoolViewModel]() {
        didSet{
            DispatchQueue.main.async {
                // Reload table when array is set
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    var arSchoolDetailModel = [SchoolDetailModel]()

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup view
        self.setupView()
        //Call API to fetch school data
        self.callNYCSchoolList()
        //Add refresh control to refresh within same screen
        self.addRefreshControl()
    }
        
    // MARK: - Custom functions
    func setupView() {
        // Set title
        self.title = Constant.AppName
        // Set table view estimated row height for dynamic size
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    func addRefreshControl() {
        // Add Refresh Control to table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshCntl
        } else {
            tableView.addSubview(refreshCntl)
        }
        self.refreshCntl.addTarget(self, action: #selector(refreshSchoolData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshSchoolData(_ sender: Any) {
        // Closing expanded cell
        // Make below flags to -1 to closing all expanded cell
        self.selectedRowIndex = -1
        self.previousRowIndex = -1
        //Get fresh data from API
        self.arSchoolVM.removeAll()
        self.callNYCSchoolList()
    }
    
    func showSpinner() {
        // Show spinner
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func hideSpinner() {
        // Hide spinner
        self.refreshCntl.endRefreshing()
        self.spinner.stopAnimating()
    }
   
    func showAlertWithMessage(alertMessage:String)  {
        //Handling error scanario by showing alert message
        let alert = UIAlertController(title:Constant.AppName, message:alertMessage,preferredStyle:.alert)
        let ok = UIAlertAction(title: "OK", style:.default) { (action) in
        }
        alert.addAction(ok)
        present(alert, animated: true,completion:nil)
    }
    
    func tapOnSelectedIndexPath(indexPath: IndexPath) {
        if selectedRowIndex >= 0  && selectedRowIndex == indexPath.row {
            // Taping on same cell will close explanded cell
            selectedRowIndex = -1
            self.tableView.reloadRows(at: [indexPath] , with: .automatic)
            return
        }
        // Close othe expanded cell and expand selected cell
        selectedRowIndex = -1
        let index1 = IndexPath(row: previousRowIndex, section: 0)
        self.tableView.reloadRows(at: [index1] , with: .automatic)
        if selectedRowIndex != indexPath.row {
            // call API to get SAT results for selected school
            if let strDbn = arSchoolVM[indexPath.row].dbn {  self.callAPISATDataForSelectedSchool(dbn:strDbn,indexPath: indexPath)
            }
        }
    }
    
    // MARK: - API call
    func callNYCSchoolList() {
        // call API to fetch school data
        self.showSpinner()
        NetworkManager.shared.fetchNYCSchoolList(offset: self.arSchoolVM.count) { (arSchoolList, error) in
            if error == nil {
                self.arSchoolVM = self.arSchoolVM + arSchoolList.map {SchoolViewModel(model: $0)}
                self.lastElementIndex = self.arSchoolVM.count - 1;
            }
            else {
                self.showAlertWithMessage(alertMessage: error ?? "Something went wrong. Plese try again")
            }
            DispatchQueue.main.async {
                self.hideSpinner()
            }
        }
    }
    
    func callAPISATDataForSelectedSchool(dbn:String, indexPath: IndexPath) {
        // call API to fetch school data
        self.showSpinner()
        NetworkManager.shared.fetchSATDataForSelectedSchool(dbn: dbn) { (schoolDetailModel, error) in
            // Hide spinner
            if error == nil {
                self.arSchoolDetailModel = schoolDetailModel
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.selectedRowIndex = indexPath.row
                    self.previousRowIndex = indexPath.row
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            } else {
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.showAlertWithMessage(alertMessage: Constant.AlertMessage.noSATDataFound)
                }
            }
        }
    }
    
    // MARK: - SchoolTableViewCell delegate
    func tapToAddress(index: Int) {
        guard let address = arSchoolVM[index].address else { return }
        guard let urlString = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        let directionsURL = Constant.API.appleMapURL + urlString
        guard let url = URL(string: directionsURL) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
       
    func tapToCall(index: Int) {
        if let phoneNumber = arSchoolVM[index].phoneNumber, let url = URL(string: "tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    // MARK: - Table view data source
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arSchoolVM.count
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "SchoolTableViewCell") as? SchoolTableViewCell
        // Configure the cell...
        let modal = arSchoolVM[indexPath.row]
        if selectedRowIndex == indexPath.row {
            //Expand cell
            cell?.configureCell(model: modal, detail: arSchoolDetailModel[0])
        }else {
            //Default collapsed cell
            cell?.configureCell(model: modal, detail: nil)
        }
        cell?.delegate = self
        cell?.selectionStyle = .none
        cell?.tag = indexPath.row
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == lastElementIndex {
            callNYCSchoolList()
        }
    }
    
    // MARK: - Table view delegate
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tapOnSelectedIndexPath(indexPath: indexPath)
    }
}

// MARK: - UIColor extension
extension UIColor {
    static let customColor = UIColor(red: 50/255, green: 100/255, blue: 170/255, alpha: 1)
}

//
//  ViewController.swift
//  IDCallerID
//
//  Created by Kenneth Wieschhoff on 9/19/17.
//  Copyright © 2017 Stanley Black&Decker. All rights reserved.
//

import UIKit
import ContactsUI

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let appd = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var tableView: UITableView!
    
    var filteredContacts : [CNContact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "Reload"), object: nil)

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 55.0
        
        self.tableView.register(UINib(nibName: "ContactTableViewCell", bundle:nil),
                                forCellReuseIdentifier: "ContactTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func reloadData() {
        DispatchQueue.main.async {
            self.filteredContacts = self.appd.allContacts
            self.tableView.reloadData()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ContactTableViewCell?
        cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as? ContactTableViewCell
        
        if cell == nil {
            cell = UINib(nibName: "ContactTableViewCell", bundle:nil) as? ContactTableViewCell
            cell = ContactTableViewCell()
        }
        
        let contact = filteredContacts[indexPath.row]
        cell?.name.text = contact.givenName + " " + contact.familyName
        var numbers: String = ""
        for phoneNumber in contact.phoneNumbers {
            numbers +=  phoneNumber.value.stringValue + "\n"
        }
        cell?.number.text = numbers
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredContacts = appd.allContacts
        } else {
            filteredContacts.removeAll()
            for contact in appd.allContacts {
                for phone in contact.phoneNumbers {
                    let phoneNumber = phone.value.stringValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                    if phoneNumber.contains(searchText) {
                        filteredContacts.append(contact)
                    }
                }
            }
        }
        tableView.reloadData()
    }
}

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var number: UILabel!
}

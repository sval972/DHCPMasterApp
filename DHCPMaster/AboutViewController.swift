//
//  AboutViewController.swift
//  DHCPMaster
//
//  Created by Alexey Altoukhov on 12/27/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import UIKit

class AboutHeaderViewCell: UITableViewCell {
    @IBOutlet weak var _appInfoLabel: UILabel!
    
    func updateCell() {
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        _appInfoLabel.text = _appInfoLabel.text! + appVersion!
    }
}

class AboutItemViewCell: UITableViewCell {

    @IBOutlet weak var ItemTitle: UILabel!
    
    func updateCell(title: String) {
        
        ItemTitle.text = title
    }
}

class AboutViewController: UITableViewController {

    var items = ["End User Agreement", "Software License"]

    private var _appConfig: AppConfig = (UIApplication.shared.delegate as! AppDelegate).appConfig
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : items.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //return section == 0 ? "Header" : "Items"
        return ""
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 300 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.section == 0 ? "AboutHeaderCell" : "AboutItemCell", for: indexPath)

        
        if (indexPath.section == 0) {
            let itemCell = cell as! AboutHeaderViewCell
            itemCell.updateCell()
        }
        
        if (indexPath.section == 1) {
            let itemCell = cell as! AboutItemViewCell
            itemCell.updateCell(title: self.items[indexPath.row])
        }

        return cell
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if  segue.identifier == "LicenseViewSegue",
            case let destination = segue.destination as? LicenseViewController,
            let userIndex = tableView.indexPathForSelectedRow?.row
        {
            if (userIndex == 0) {
                if let licenseText = _appConfig.getEula() {
                    destination?.text = licenseText
                }
            }
            else if (userIndex == 1) {
                if let licenseText = _appConfig.getSoftwareLicense() {
                    destination?.text = licenseText
                }
            }

        }
    }
    

}

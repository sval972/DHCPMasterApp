//
//  MessageItemViewController.swift
//  DHCPMaster
//
//  Created by Alexey Altoukhov on 4/21/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import UIKit

class MessageHeaderExtendedViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    
    func update(key: String, value: String) {
        self.name.text = key
        self.value.text = value
    }
}

class MessageItemViewController: UITableViewController {

    var headerItem: (String, String)?
    
    private var _tableItems = [(String, String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _tableItems.append(("Name", headerItem!.0))
        _tableItems.append(("Value", headerItem!.1))
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _tableItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageHeaderExtendedCell", for: indexPath)
        
        let item = _tableItems[indexPath.row]
        
        let headerCell = cell  as! MessageHeaderExtendedViewCell
        headerCell.update(key: item.0, value: item.1)

        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

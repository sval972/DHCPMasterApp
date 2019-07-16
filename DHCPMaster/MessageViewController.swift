//
//  Message2ViewController.swift
//  DHCPMaster
//
//  Created by Alexey Altoukhov on 4/21/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import UIKit
import Network

class MessageHeaderViewCell: UITableViewCell {

    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var value: UILabel!
    
    func update(key: String, value: String) {
        self.key.text = key
        self.value.text = value
    }
}

class MessageOptionViewCell: UITableViewCell {
    @IBOutlet weak var code: UILabel!
    @IBOutlet weak var key: UILabel!
    @IBOutlet weak var value: UILabel!
    
    func update(code: String, key: String, value: String) {
        self.code.text = code
        self.key.text = key
        self.value.text = value
    }
}

class MessageViewController: UITableViewController {

    var _dhcpMessage: DhcpMessage?

    private var _headerItems = [(String, String)]()
    private var _optionItems = [IDhcpOption]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _headerItems.append(("Opcode", String(describing: _dhcpMessage!._opcode)))
        _headerItems.append(("Hardware Type", String(describing: _dhcpMessage!._hwType)))
        _headerItems.append(("Hops", String(_dhcpMessage!._hops)))
        _headerItems.append(("XID", String(_dhcpMessage!._xid)))
        _headerItems.append(("Secs", String(_dhcpMessage!._secs)))
        _headerItems.append(("Broadcast", String(_dhcpMessage!._broadcast)))
        _headerItems.append(("Client IP (ciaddr)", (_dhcpMessage!._clientIpAddress as! IPv4Address).debugDescription))
        _headerItems.append(("Your IP (yiaddr)", (_dhcpMessage!._yourIpAddress as! IPv4Address).debugDescription))
        _headerItems.append(("Next Server IP (siaddr)", (_dhcpMessage!._nextServerIpAddress as! IPv4Address).debugDescription))
        _headerItems.append(("Relay Agent IP (giaddr)", (_dhcpMessage!._relayAgentIpAddress as! IPv4Address).debugDescription))
        _headerItems.append(("Hardware Address (chaddr)", _dhcpMessage!._clientHardwareAddress.hexEncodedString()))
        _headerItems.append(("Server Name (sname)", _dhcpMessage!._serverHostname))
        _headerItems.append(("File Name (file)", _dhcpMessage!._bootFileName))
        
        _optionItems.append(contentsOf: _dhcpMessage!._dhcpOptions)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? _headerItems.count : _optionItems.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Header" : "Options"
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indexPath.section == 0 ? "MessageHeaderCell" : "MessageOptionCell", for: indexPath)
        
        if (indexPath.section == 0) {
            let item = _headerItems[indexPath.row]
            
            let headerCell = cell  as! MessageHeaderViewCell
            headerCell.update(key: item.0, value: item.1)
        }
        else {
            let option = _optionItems[indexPath.row]
            let optionCell = cell as! MessageOptionViewCell
            optionCell.update(code: String(option._optionType.rawValue) + ": ", key: String(describing: option._optionType), value: option._stringValue)
        }
        
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowHeaderItemSegue",
            let destination = segue.destination as? MessageItemViewController,
            let index = tableView.indexPathForSelectedRow?.row
        {
            destination.headerItem = _headerItems[index]
        }
        else if segue.identifier == "ShowOptionItemSegue",
            let destination = segue.destination as? MessageItemViewController,
            let index = tableView.indexPathForSelectedRow?.row
        {
            destination.optionItem = _optionItems[index]
        }
    }
}

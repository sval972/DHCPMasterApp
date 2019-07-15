//
//  MessageLogViewController.swift
//  DHCPMaster
//
//  Created by Alexey Altoukhov on 3/29/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import UIKit
import Network

class SessionViewCell: UITableViewCell {
    
    @IBOutlet weak var _label: UILabel!
    
    func updateCell(message: DhcpMessage) {
        
        _label.text = "\(message.messageType == nil ? "nil" : String(describing: message.messageType!)): \(message._xid) : \((message._yourIpAddress as! IPv4Address).debugDescription)"
    }
}

class MessageLogViewController: UITableViewController {

    @IBOutlet weak var _startButton: UIBarButtonItem!
    
    private var _dhcpClient: DhcpClient! = nil
    private var _localCache: LocalCache! = nil
    
    private var _messages = [DhcpMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _dhcpClient = DhcpClient(macAddress: "abcdef".data(using: String.Encoding.ascii)!, sentCallback: { (message) in
            
            print(message.toString())
            
            self._messages.append(message)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }, receivedCallback: { (message) in
            
            print(message.toString())
            
            self._messages.append(message)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }, errorCallback: { (error) in
            
            print(error)
            
            let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            self.present(alert, animated: true)
        })
        
        _localCache = LocalCache()
        
        for file in _localCache.getFilesList().sorted() {
            print(file)
            do {
                //_localCache.deleteFile(fileName: file)
                let data = _localCache.getData(fileName: file)
                let message: DhcpMessage = try DhcpMessage(data: data!)
                self._messages.append(message)
            }
            catch {
                print("Error parsing")
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    @IBAction func StartPressed(_ sender: Any) {
        
        _dhcpClient.runDhcp()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _messages.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell", for: indexPath) as! SessionViewCell

        let message = _messages[indexPath.row]
        
        cell.updateCell(message: message)
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if  segue.identifier == "ShowMessageSegue",
            let destination = segue.destination as? MessageViewController,
            let index = tableView.indexPathForSelectedRow?.row
        {
            destination._dhcpMessage = _messages[index]
        }
    }

}

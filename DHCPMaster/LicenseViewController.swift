//
//  LicenseViewController.swift
//  DHCPMaster
//
//  Created by Alexey Altoukhov on 12/28/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController {

    var text: String = ""
    
    @IBOutlet weak var MainTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        MainTextView.text = text
    }
    

}

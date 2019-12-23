//
//  UserAgreementViewController.swift
//  DHCPMaster
//
//  Created by Alexey Altoukhov on 12/20/19.
//  Copyright © 2019 Alexey Altoukhov. All rights reserved.
//

import UIKit

class UserAgreementViewController: UIViewController {
    
    @IBOutlet weak var AgreementSlider: UISwitch!
    @IBOutlet weak var CloseButton: UIButton!
    
    private var _appConfig: AppConfig = (UIApplication.shared.delegate as! AppDelegate).appConfig
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func AgreementSliderChanged(_ sender: Any) {
        
        CloseButton.isEnabled = AgreementSlider.isOn
    }
    
    @IBAction func CloseButtonPressed(_ sender: Any) {
        
        if (AgreementSlider.isOn) {
            _appConfig.setTermsAccepted()
        }
        
        self.dismiss(animated: true, completion: nil)
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

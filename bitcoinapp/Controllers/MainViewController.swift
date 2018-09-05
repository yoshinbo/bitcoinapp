//
//  MainViewController.swift
//  bitcoinapp
//
//  Created by Yoshikazu Oda on 2018/09/04.
//  Copyright © 2018年 yoshinbo. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    class func build() -> MainViewController {
        return R.storyboard.main.instantiateInitialViewController()!
    }

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var walletLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let cashAddress = WalletContainer.shared.cashAddress()
        walletLabel.text = cashAddress
        qrImageView.image = WalletContainer.shared.generateQRCode(cashAddress)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

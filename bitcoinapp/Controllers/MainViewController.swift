//
//  MainViewController.swift
//  bitcoinapp
//
//  Created by Yoshikazu Oda on 2018/09/04.
//  Copyright © 2018年 yoshinbo. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class MainViewController: UIViewController {
    
    class func build() -> MainViewController {
        return R.storyboard.main.instantiateInitialViewController()!
    }

    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var walletLabel: UILabel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let cashAddress = WalletContainer.shared.cashAddress()
        walletLabel.text = cashAddress
        qrImageView.image = WalletContainer.shared.generateQRCode(cashAddress)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ApiClient.shared.utxo(address: WalletContainer.shared.base58Address())
            .subscribe(onNext: { [weak self] (json) in
                let entities = Mapper<UtxoEntity>().mapArray(JSONObject: json)
                print("success: \(json) - \(entities)")
            }, onError: { (error) in
                print("error: \(error)")
            }
        ).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

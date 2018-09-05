//
//  WalletContainer.swift
//  bitcoinapp
//
//  Created by Yoshikazu Oda on 2018/09/05.
//  Copyright © 2018年 yoshinbo. All rights reserved.
//

import Foundation
import BitcoinKit
import KeychainAccess

public final class WalletContainer: NSObject {
    private struct Const {
        static let wifKey = "wif"
    }
    
    public static let shared = WalletContainer()
    
    private(set) var wallet: Wallet?
    private(set) var wif = ""
    
    private override init() {
        super.init()
        if let _wif = Keychain()[string: Const.wifKey] {
            wallet = try! Wallet(wif: _wif)
        } else {
            self.create()
        }
    }
    
    func publicKey() -> PublicKey? {
        guard let _wallet = wallet else { return nil }
        return _wallet.publicKey
    }
    
    // NOTE: - base58でエンコードしたAddress
    func base58Address() -> String {
        guard let publicKey = publicKey() else { return "" }
        let base58Address = publicKey.toLegacy()
        print("base58Address: \(base58Address)")
        return "\(base58Address)"
    }
    
    // NOTE: - BCHの新しいアドレス表示方式のcashAddress
    func cashAddress() -> String {
        guard let publicKey = publicKey() else { return "" }
        let cashAddr = publicKey.toCashaddr()
        print("cashAddr: \(cashAddr)")
        return cashAddr.cashaddr
    }
    
    func generateQRCode(_ content: String, scaleX: CGFloat = 6, y: CGFloat = 6) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator", withInputParameters: [
            "inputMessage": content.data(using: .utf8)!,
            "inputCorrectionLevel": "L"
        ])
        guard let outputImage = filter?.outputImage else { return nil }
        
        let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: y))
        guard let cgImage = CIContext().createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

extension WalletContainer {
    fileprivate func create() {
        let privateKey = PrivateKey(network: .testnet, isPublicKeyCompressed: true)
        save(wif: privateKey.toWIF())
    }
    
    fileprivate func save(wif: String) {
        let keychain = Keychain()
        keychain[string: Const.wifKey] = wif
        wallet = try! Wallet(wif: wif)
    }
}

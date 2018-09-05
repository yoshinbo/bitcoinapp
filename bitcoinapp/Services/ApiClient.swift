//
//  ApiClient.swift
//  bitcoinapp
//
//  Created by Yoshikazu Oda on 2018/09/05.
//  Copyright © 2018年 yoshinbo. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class ApiClient: NSObject {
    private struct Const {
        static let bchInsightEndpoint = "https://test-insight.bitpay.com/api"
        // NOTE: - Mainnet for Bitcoin: https://insight.bitpay.com/api
        // NOTE: - Testnet for BitcoinCache: https://test-bch-insight.bitpay.com/api
        // NOTE: - Mainnet for BitcoinCache: https://bch-insight.bitpay.com/api
    }
    
    public static let shared = ApiClient()
    
    override init() {
        super.init()
    }
    
    func utxo(address: String) -> Observable<JSON> {
        return request(url: Const.bchInsightEndpoint + "/addr/\(address)/utxo", method: .get)
    }
}

extension ApiClient {
    fileprivate func request(
        url: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        parameterEncoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
    ) -> Observable<JSON> {
        print("request url: \(url)")
        return Observable.create { observer in
            Alamofire.request(url, method: method, parameters: parameters, encoding: parameterEncoding, headers: headers).responseJSON { response  in
                switch response.result {
                case .success(let data):
                    observer.onNext(JSON(data))
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}

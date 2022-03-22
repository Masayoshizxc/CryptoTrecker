//
//  Networking.swift
//  CryptoTrecker
//
//  Created by Adilet on 22/3/22.
//

import Foundation

final class APICaller{
    static let shared = APICaller()
    
    private struct Constants{
        static let apiKey = "59293daa1b63622fbdca84c5c914ba070817e4d1"
        static let assetsEndpoint = "https://api.nomics.com/v1/currencies/"
    }
    private init(){}
    public var icons: [Icon] = []
    private var whenReadyBlock: ((Result<[Crypto], Error>) -> Void)?
     
    
    public func getAllCryptoData(
        completion: @escaping (Result<[Crypto], Error>) -> Void
    ){
        guard !icons.isEmpty else{
            whenReadyBlock = completion
            return
        }
        
        guard let url = URL(string: Constants.assetsEndpoint + "ticker?key=" + Constants.apiKey) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _,error in
            guard let data = data, error == nil else{
                return
            }
            do{
                let  cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                
                completion(.success(cryptos))
            }
            catch{
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    public func getAllIcons(){
        guard let url = URL(string: "https://api.nomics.com/v1/currencies/ticker?key=59293daa1b63622fbdca84c5c914ba070817e4d1")
        else{
            return
        }
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _,error in
            guard let data = data, error == nil else{
                return
            }
            do{
                self?.icons = try JSONDecoder().decode([Icon].self, from: data)
                if let completion = self?.whenReadyBlock{
                    self?.getAllCryptoData(completion: completion)
                }

            }
            catch{
                print(error)
            }
        }
        task.resume()

    }
    
}

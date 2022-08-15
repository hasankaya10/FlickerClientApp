//
//  NetworkManager.swift
//  FlickerClientApp
//
//  Created by Hasan Kaya on 21.07.2022.
//

import Foundation
class NetworkManager {
    static var shared = NetworkManager()
    func fetchImage(with url : String?, completion: @escaping (Data) -> Void ){
        if let urlString = url ,let url =  URL(string: urlString){
            let request = URLRequest(url: url)
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }
            }.resume()
        }
    }
}

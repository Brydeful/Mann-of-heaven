//
//  NetworkService.swift
//  Mann of heaven
//
//  Created by Вячеслав on 08.12.2019.
//  Copyright © 2019 Вячеслав. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService{
    
    func fetchDiner(completion: @escaping(([Diner]?) -> Void)){
        
        AF.request("\(ip):5000/mann/api/v1/dinner").responseData { response in
            if let error = response.error {
                print(error)
            }
            guard let data = response.data else {return}
            
            do {
                let objects = [try JSONDecoder().decode(Diner.self, from: data)]
                completion(objects)
            }catch let jsonError{
                print(jsonError)
            }
            
        }
    }
    
    func deleteDiner(diner: Diner, completion: @escaping((Bool) -> Void)){
        AF.request("\(ip):5000/mann/api/v1/dinner/\(diner.id)", method: .delete).responseData { (response) in
            switch response.result{
            case .success:
                completion(true)
                
            case .failure(let error):
                print(error)
                completion(false)
            }
        }
    }
    func addDiner(parameters: [String:String]){
        AF.request("\(ip):5000/mann/api/v1/dinner", method: .post, parameters: parameters, encoding:  JSONEncoding.default).responseJSON { (response) in
                switch response.result {
                case let .success(value):
                    print(value)
                case let .failure(error):
                    print(error)
            }
        }
    }
}

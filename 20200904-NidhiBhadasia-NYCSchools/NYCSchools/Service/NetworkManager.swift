//
//  NetworkManager.swift
//  20200904-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 9/5/20.
//  Copyright © 2020 Nidhi. All rights reserved.
//

import Foundation

class NetworkManager: NSObject {
    
    static let shared = NetworkManager()
    
    // MARK: - Initialization
    private override init() {
        // Created sigleton object
        // Private Initialization
    }
    
    // MARK: - API functions
    func fetchNYCSchoolList(offset:Int,completion: @escaping ([SchoolModel], String?) -> Void) {
        // Get API URL
        guard let url = URL(string: Constant.API.schoolListURL + String(offset)) else {
            completion([], Constant.AlertMessage.urlNotFound)
            return
        }
        // Fetch Data
        URLSession.shared.dataTask(with:url, completionHandler: {(data, response, error) -> Void in
            print("API URL: \(url)")
            guard let dataResponse = data, error == nil else {
                print(error?.localizedDescription ?? "Response Error")
                completion([],error?.localizedDescription ?? "Response Error")
                return
            }
            do {
                //dataResponse received from a network request
                let decoder = JSONDecoder()
                //Decode JSON Response Data
                let arSchoolModel =  try decoder.decode([SchoolModel].self, from: dataResponse)
                if arSchoolModel.count > 0 {
                    completion(arSchoolModel,nil)
                }else {
                    completion(arSchoolModel,"No data found")
                }
            } catch let error {
                print(error)
            }
        }).resume()
    }
            
    func fetchSATDataForSelectedSchool(dbn:String,completion: @escaping ([SchoolDetailModel], String?) -> Void) {
        // Get API URL
        guard let url = URL(string: Constant.API.schoolSATDataURL+dbn) else {                        completion([], Constant.AlertMessage.urlNotFound)
            return
        }
        // Fetch Data
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            print("API URL: \(url)")
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    completion([],error?.localizedDescription ?? "Response Error")
                    return
            }
            do {
                //dataResponse received from a network request
                let decoder = JSONDecoder()
                //Decode JSON Response Data
                let schoolDetailModel = try decoder.decode([SchoolDetailModel].self, from: dataResponse)
                if schoolDetailModel.count > 0 {
                    completion(schoolDetailModel,nil)
                }else {
                    completion(schoolDetailModel,"No data found")
                }
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
    }
}




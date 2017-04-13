//
//  RequestManager.swift
//  nodeadsTestApp
//
//  Created by Artem on 4/12/17.
//  Copyright © 2017 Artem Velykyy. All rights reserved.
//

import UIKit

class RequestManager: NSObject {
    
    
    enum RequestType: String {
        case POST, GET
    }
    
    private var session: URLSession! {
        didSet {
            self.cancelAllTasks()
        }
    }
    
    private var requestLink: String!
    
    private var parametrs: [String : String]!
    
    private var reqType: RequestType
    
    
    init(requestLink: String, parametrs: [String : String], reqType: RequestType = .POST) {
        self.requestLink = requestLink
        self.parametrs = parametrs
        self.reqType = reqType
    }
    
    func cancelAllTasks() {
      //  self.session.invalidateAndCancel()
    }
    
    
    func requestTask(_ answer: @escaping ([String: Any]?, String?)->()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let param = generateRequestBody(param: parametrs)
        
        
        session = URLSession.shared
        
        guard let url = URL(string: requestLink) else {
            fatalError("URL isnt correct")
        }
        
        var request = URLRequest(url: url)
        
        
        request.httpMethod = reqType.rawValue
        
        switch reqType {
        case .GET: request.httpBody = nil
        case .POST:
            let data = param.data(using: .utf8)
            request.httpBody = data
        }
        
        
        
        request.httpShouldHandleCookies = true
        
        session.dataTask(with: request) { (data, response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            do {
                guard data != nil else {
                    DispatchQueue.main.async {
                        answer(nil, error?.localizedDescription)
                    }
                    return
                }
                
                let dict = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any]
                
                DispatchQueue.main.async {
                    answer(dict ?? [:], dict == nil ? "Error" : nil)
                }
            }
            }.resume()
        
        
    }
    
    
    private func generateRequestBody(param: [String: String]) -> String {
        var stringParametrs = ""
        
        for (key, value) in param {
            stringParametrs = stringParametrs + (stringParametrs == "" ? "" : "&") + key + "=" + value
        }
        
        return stringParametrs
    }
    
}

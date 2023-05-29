//
//  ools.swift
//  SwiftMediator
//
//  Created by iOS on 2023/5/29.
//

import Foundation

//MARK:--URL get query dictionary
public extension URL {
    
    var queryDictionary: [String: Any]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
    
    var urlParameters: [String: String]? {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
        let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }

}
//MARK:--URL codec
public extension String {
    //Encode the original url into a valid url
    func urlEncoded() -> String {
        self.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed) ?? ""
    }
    
    //convert the encoded url back to the original url
    func urlDecoded() -> String {
        self.removingPercentEncoding ?? ""
    }
}


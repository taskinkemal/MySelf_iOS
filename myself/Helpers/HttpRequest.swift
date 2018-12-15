//
//  HttpRequest.swift
//  myself
//
//  Created by Kemal Taskin on 25.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import Foundation

final class HttpRequest
{
    static func send<T : Decodable>(url:String,
                                    method: String,
                                    data:BaseModel?,
                                    cbSuccess: @escaping (T)  -> Void,
                                    cbError: @escaping (Int, String)  -> Void)
    {
        let urlObject:URL = URL(string: Constants.serviceEndpoint + url)!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: urlObject)
        request.httpMethod = method
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        var statusCode = 500;
        
        do {
            if (data != nil)
            {
                request.httpBody = try JSONSerialization.data(withJSONObject: data!.toJSON(), options: .prettyPrinted)
            }
            
        } catch let error {
            cbError(statusCode, error.localizedDescription)
            return
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("charset", forHTTPHeaderField: "UTF-8")
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let accessToken = DataStore.GetAccessToken();
        
        if (accessToken != nil)
        {
            request.addValue("Bearer " + accessToken!, forHTTPHeaderField: "Authorization")
        }
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                
                cbError(statusCode, "Response is empty")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                
                statusCode = httpResponse.statusCode
            }
            
            if (statusCode != 200)
            {
                let json: Any?
                
                do
                {
                    json = try JSONSerialization.jsonObject(with: data!, options: [])
                }
                catch
                {
                    cbError(statusCode, "Response is invalid")
                    return
                }
                
                guard let serverResponse = json as? NSDictionary else
                {
                    cbError(statusCode, "Response is invalid")
                    return
                }
                
                var errorMessage = "Server error";
                
                if serverResponse["error"] is String
                {
                    errorMessage = serverResponse["error"] as! String
                }
                
                cbError(statusCode, errorMessage)
                return
            }
            let feedback = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

            
            let decoder = JSONDecoder();
            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full);
            //let result = try? decoder.decode(T.self, from: data!);
            do {
                let result = try decoder.decode(T.self, from: data!);
                cbSuccess(result)
            } catch {
                print("Unexpected error: \(error).")
            }
            
        })
        
        task.resume()
    }
}

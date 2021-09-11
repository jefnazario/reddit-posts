//
//  Api.swift
//  RedditPosts
//
//  Created by Jeferson Fracalossi Nazario on 11/09/21.
//

import Foundation

protocol ApiProtocol: AnyObject {
    func request<T: Decodable>(method: HttpMethod, url: URL?, json: Data?, completion: @escaping (ApiResponse<T>) -> Void)
}

class Api: ApiProtocol {
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        
        configuration.allowsCellularAccess = true
        configuration.httpShouldSetCookies = true
        configuration.httpShouldUsePipelining = true
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.timeoutIntervalForRequest = 30.0
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        
        return  URLSession(configuration: configuration)
    }()
    
    func request<T>(method: HttpMethod, url: URL?, json: Data?, completion: @escaping (ApiResponse<T>) -> Void) where T : Decodable {
        guard let url = url else {
            completion(.error("URL not found"))
            return
        }
        
        var request = defineUrlRequest(method: method, url: url)
        request.httpBody = json ?? nil
        
        urlSession.dataTask(with: request) { (data, response, error) in
            guard let result = data else { return }
            do {
                let decoded = try JSONDecoder().decode(T.self, from: result)
                completion(.success(decoded))
            } catch let ex {
                completion(.error(ex.localizedDescription))
            }
            
        }.resume()
    }
    
    //MARK: - Defining url request with content
    fileprivate func defineUrlRequest(method: HttpMethod, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch method {
        case .get:
            request.setValue(ContentType.get.rawValue, forHTTPHeaderField: "Content-Type")
        case .post:
            request.setValue(ContentType.postPutDel.rawValue, forHTTPHeaderField: "Content-Type")
            return request
        case .put:
            request.setValue(ContentType.postPutDel.rawValue, forHTTPHeaderField: "Content-Type")
            return request
        case .del:
            request.setValue(ContentType.postPutDel.rawValue, forHTTPHeaderField: "Content-Type")
            return request
        }
        return request
    }
}

enum ApiResponse<T: Codable> {
    case success(T)
    case error(String)
}

enum ContentType: String {
    case get        =   "application/x-www-form-urlencoded"
    case postPutDel =   "application/json"
}

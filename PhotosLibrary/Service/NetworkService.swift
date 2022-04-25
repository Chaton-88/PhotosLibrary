//
//  NetworkService.swift
//  PhotosLibrary
//
//  Created by Valeriya Trofimova on 21.04.2022.
//

import Foundation
import UIKit

final class NetworkService {
    
    func request(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        
        let params = self.prepareParams(searchTerm: searchTerm)
        let url = self.url(params: params)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeader()
        request.httpMethod = "GET"
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeader() -> [String: String] {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID _EUgX97jagiNNNw7mVddlbsYaPXqDfvEZZFTYSj4QYs"
        
        return headers
    }
    
    private func prepareParams(searchTerm: String?) -> [String: String] {
        var params = [String: String]()
        params["query"] = searchTerm
        params["page"] = String(1)
        params["per_page"] = String(30)
        
        return params
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
       
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}

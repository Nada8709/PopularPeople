//
//  PopularPeopleService.swift
//  PopularPeople
//
//  Created by NadaAshraf on 03/08/2023.
//

import Foundation

protocol PopularPeopleService{
    func fetchPopularPeople(pageNumber: Int, completion: @escaping ([Any]?) -> Void)
}

class PopularPeopleServiceImpl : PopularPeopleService {
    
    let popularPeopleURL = "https://api.themoviedb.org/3/person/popular?api_key=e7631ffcb8e766993e5ec0c1f4245f93&language=en-US&page=%@"
    
    let defaultSession = URLSession(configuration: .default)
    
    var dataTask: URLSessionDataTask?
    var errorMessage = ""
        
    func fetchPopularPeople(pageNumber: Int, completion: @escaping ([Any]?) -> Void) {
        dataTask?.cancel()
        
        guard let url = URL(string: String(format: popularPeopleURL, "\(pageNumber)") ) else {
            return
        }
        
        dataTask = defaultSession.dataTask(with: url) { [weak self] data, response, error in
            defer {
                self?.dataTask = nil
            }
            
            if let error = error {
                self?.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
            } else if let data = data {
                
                var response: [String: Any]?
                
                do {
                  response = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch _ as NSError {
                  return
                }
                
                guard let array = response!["results"] as? [Any] else {
                  return
                }
                
                DispatchQueue.main.async {
                    completion(array)
                }
            }
        }
        
        dataTask?.resume()
    }
}


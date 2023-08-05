//
//  PopularPeopleViewModel.swift
//  PopularPeople
//
//  Created by NadaAshraf on 03/08/2023.
//

import UIKit

protocol PopularPeopleViewModel{
    //getting data
    var popularPeopleArray: [Any] { get set }
    var pageNumber : Int { get set }
    
    //load data functions
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ())
    
    //fetch popularPeople
    func fetchPopularPeople(pageNumber: Int, completion: @escaping () -> Void)
    func getPersonDetail(personId: Int, completion: @escaping ([String: Any]?) -> Void)
}

class PopularPeopleViewModelImpl : PopularPeopleViewModel {
    var pageNumber: Int
    var popularPeopleArray: [Any] = []
    private var _popularPeopleService : PopularPeopleService!
    private var _personDetailService: PersonDetailService!

    private let imageUrl = "https://image.tmdb.org/t/p/%@%@"
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    init(popularPeopleService: PopularPeopleService, personDetailService: PersonDetailService) {
        self._popularPeopleService = popularPeopleService
        self._personDetailService = personDetailService
        self.pageNumber = 1
    }
    
    func fetchPopularPeople(pageNumber: Int, completion: @escaping () -> Void) {
        _popularPeopleService.fetchPopularPeople(pageNumber: pageNumber) {[weak self] (jsonArray) in
            if let jsonArray = jsonArray {
                self?.popularPeopleArray.append(contentsOf: jsonArray)
            }
            completion()
            
        }
    }
    
    func getPersonDetail(personId: Int, completion: @escaping ([String : Any]?) -> Void) {
        _personDetailService.getPersonDetails(personId: personId, completion: completion)
    }
    
    // MARK: - Image Loading
    ///
    /// Loading image with URL String
    /// - Parameter urlString: string of the url image. completion: block callback uiimage
    ///
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {

            guard let url = URL(string: String(format: self.imageUrl, "w154", urlString)), let data = try? Data(contentsOf: url) else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
}


//
//  PersonDetailViewModel.swift
//  PopularPeople
//
//  Created by NadaAshraf on 04/08/2023.
//

import UIKit

protocol PersonDetailViewModel{
    var personDictionary: [String: Any] { get set }
    var personImagesArray: [String] { get set }

    func loadPersonDetail(personId: Int, completion: @escaping () -> Void)
    func loadPersonImages(personId: Int, completion: @escaping () -> Void)
    func loadImage(with urlString: String, completion: @escaping (UIImage?) -> ())
}

class PersonDetailViewModelImpl : PersonDetailViewModel {
    var personDictionary: [String: Any] = [:]
    var personImagesArray: [String] = []
    private let personDetailService : PersonDetailService!
    private let personImagesService : PersonImagesService!
    //Image loading
    private let utilityQueue = DispatchQueue.global(qos: .userInitiated)
    private let imageUrl = "https://image.tmdb.org/t/p/%@%@"
    
    init(personDetailService: PersonDetailService, personImagesService: PersonImagesService) {
        self.personDetailService = personDetailService
        self.personImagesService = personImagesService
    }
    
    func loadPersonDetail(personId: Int, completion: @escaping () -> Void) {
        personDetailService.getPersonDetails(personId: personId) {[weak self] (personDetail) in
            if let personDetail = personDetail {
                self?.personDictionary = personDetail
            }
            completion()
        }
    }
    
    func loadPersonImages(personId: Int, completion: @escaping () -> Void) {
        personImagesService.getPersonImages(personId: personId) { [weak self] (personImages) in
            if let personImages = personImages, let imagesArray = personImages["profiles"] as? Array<[String: Any]>{
                for personImage in imagesArray{
                    self?.personImagesArray.append(personImage[Constants.filePath] as? String ?? "")
                }
            }
            completion()
        }
    }
    // MARK: - Image Loading
    ///
    /// Loading image with URL String
    /// - Parameter urlString: string of the url image. completion: block callback image data
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


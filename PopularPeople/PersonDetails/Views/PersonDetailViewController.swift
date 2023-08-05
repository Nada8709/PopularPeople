//
//  PersonDetailViewController.swift
//  PopularPeople
//
//  Created by NadaAshraf on 04/08/2023.
//

import UIKit
class PersonDetailViewController: UIViewController{
    
    //MARK: - Outlets
    @IBOutlet weak var personImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var bioGraphy: UILabel!
    @IBOutlet weak var imagesGridView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    //MARK: - Publics
    static let identifier = "PersonDetailViewController"
   
    //MARK: - Privates
    private var viewModel : PersonDetailViewModel!
                                         
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        imagesGridView.dataSource = self
        imagesGridView.delegate = self
        scrollView.contentSize = CGSize(width:  UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height * 3)
        configData()
    }
    
    func configData() {
        viewModel = PersonDetailViewModelImpl(personDetailService: PersonDetailServiceImpl(), personImagesService: PersonImagesServiceImpl())
    }
    
    func loadPersonDetail(personId: Int){
        viewModel.loadPersonDetail(personId: personId){ [weak self] in
            self?.reloadData()
        }
        viewModel.loadPersonImages(personId: personId){ [weak self] in
            self?.showGrid()
        }
    }
    
    private func reloadData() {
        personName.text = viewModel.personDictionary[Constants.name] as? String ?? ""
        bioGraphy.text = viewModel.personDictionary[Constants.biography] as? String ?? ""
        let imageUrlString = viewModel.personDictionary[Constants.personImage] as? String ?? ""
        DispatchQueue.global().async {
            self.viewModel.loadImage(with: imageUrlString) { [weak self] (image) in
                guard let self = self, let image = image else { return }
                personImage.image = image
            }
        }
    }
    
    private func showGrid() {
        imagesGridView.reloadData()
    }
}
extension PersonDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout{
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
   
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return viewModel.personImagesArray.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagesGridView.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! PersonImagesCell
         DispatchQueue.main.async {
             self.viewModel.loadImage(with: self.viewModel.personImagesArray[indexPath.row]) { [weak self] (image) in
                 guard let image = image else { return }
                 cell.personImage.image = image
             }
         }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageURL = viewModel.personImagesArray[indexPath.row]
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let imageDetailsViewController = mainStoryboard.instantiateViewController(withIdentifier: ImageDetailsViewController.identifier) as! ImageDetailsViewController
        self.present(imageDetailsViewController, animated: true, completion: nil)
        imageDetailsViewController.loadImage(imageURL: imageURL)
        
    }
    

}

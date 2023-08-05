//
//  ImageDetailsViewController.swift
//  PopularPeople
//
//  Created by NadaAshraf on 05/08/2023.
//

import UIKit
class ImageDetailsViewController : UIViewController{
    @IBOutlet weak var selectedImage: UIImageView!
    
    @IBAction func downloadImage(_ sender: UIButton) {
        guard let inputImage = selectedImage.image else { return }
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: inputImage)
    }
    @IBAction func goBack(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true)
    }
    private var viewModel : PersonDetailViewModel!
  
    func configData() {
        viewModel = PersonDetailViewModelImpl(personDetailService: PersonDetailServiceImpl(), personImagesService: PersonImagesServiceImpl())
    }
    
    static let identifier = "ImageDetailsViewController"

    override func viewDidLoad() {
        super.viewDidLoad()
        configData()
    }
    func loadImage(imageURL: String){
        DispatchQueue.main.async {
            self.viewModel.loadImage(with: imageURL) { [weak self] (image) in
                guard let self = self, let image = image else { return }
                self.selectedImage.image = image
            }
        }
    }
}
class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}

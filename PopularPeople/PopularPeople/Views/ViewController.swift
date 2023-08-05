//
//  ViewController.swift
//  PopularPeople
//
//  Created by NadaAshraf on 03/08/2023.
//

import UIKit

class ViewController: UIViewController {
   
    @IBOutlet weak var popularPeopleTableView: UITableView!    
    //MARK: - Private Declarations
    private var spinner = UIActivityIndicatorView(style: .large)
    private var viewModel : PopularPeopleViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PopularPeopleViewModelImpl(popularPeopleService: PopularPeopleServiceImpl(), personDetailService: PersonDetailServiceImpl())
        configureUI()
        loadData()
    }
    //MARK: - Private functions
    private func configureUI() {
       // popularPeopleTableView.backgroundColor = Constants.backgroundTableViewColor
        popularPeopleTableView.dataSource = self
        popularPeopleTableView.delegate = self
        popularPeopleTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
       configSpinnerLoadingView()
    }
    
    private func loadData(){
        viewModel.fetchPopularPeople(pageNumber: viewModel.pageNumber) { [weak self] in
            self?.popularPeopleTableView.reloadData()
        }
    }
    
    private func showSpinnerLoadingView(isShow: Bool) {
        if isShow {
            self.spinner.isHidden = false
            spinner.startAnimating()
        } else if spinner.isAnimating {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    private func loadMorePopularPersons() {
        //Increase page number
        let pageNumber = viewModel.pageNumber
        viewModel.pageNumber = pageNumber + 1
        //Start Spinner Loading View
        showSpinnerLoadingView(isShow: true)
        viewModel.fetchPopularPeople(pageNumber: viewModel.pageNumber) { [weak self] in
            //Stop Spinner Loading View
            self?.showSpinnerLoadingView(isShow: false)
            //Reload table view
            self?.popularPeopleTableView.reloadData()
        }
    }
    
    private func configSpinnerLoadingView() {
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        //Autolayout
        spinner.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            spinner.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0),
            spinner.widthAnchor.constraint(equalToConstant: 24),
            spinner.heightAnchor.constraint(equalToConstant: 24)
            
        ]
        NSLayoutConstraint.activate(constraints)
        
        spinner.isHidden = true
    }
}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return viewModel.popularPeopleArray.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell: popularPeopleCell = tableView.dequeueReusableCell(withIdentifier: popularPeopleCell.identifier, for: indexPath) as! popularPeopleCell

          //configure data
          let popularPeopleDict = viewModel.popularPeopleArray[indexPath.row] as! [String: Any]
          cell.configure(popularPeopleDictionary: popularPeopleDict)
          
          
          let urlImageString = popularPeopleDict[Constants.personImage] as? String ?? ""
          self.viewModel.loadImage(with: urlImageString) { [weak self] (image) in
              guard let self = self, let image = image else { return }
              
              cell.configureImage(image)
          }
          return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let popularPeopleDict = viewModel.popularPeopleArray[indexPath.row] as! [String: Any]
        let personId = popularPeopleDict[Constants.personId] as? Int ?? -1
        if personId != -1 {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let personDetailViewController = mainStoryboard.instantiateViewController(withIdentifier: PersonDetailViewController.identifier) as! PersonDetailViewController
            self.present(personDetailViewController, animated: true, completion: nil)
            personDetailViewController.loadPersonDetail(personId: personId)
            
        }
    }
}

//MARK: - UIScrollViewDelegate
extension ViewController : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 15.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 15.0 {
            self.loadMorePopularPersons()
        }
    }

}

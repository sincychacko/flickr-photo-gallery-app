//
//  ViewController.swift
//  PhotoGallery
//
//  Created by SINCY on 06/01/20.
//  Copyright © 2020 SINCY. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController {
    
    private let reuseIdentifier = "PhotoCell"
    private let itemsPerRow: CGFloat = 3
    private let photoTitleHeight: CGFloat = 28
    private let sectionInsets = UIEdgeInsets(top: 30.0, left: 10.0, bottom: 30.0, right: 10.0)
        
    @IBOutlet weak var searchTextField: UITextField!
    
    var viewModel = PhotosViewModel()
    var cachedImages: [String: UIImage] = [:]
    var shouldLoadNewPage = false
    var activityIndicator: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
    }
    

    private func loadMoreImages() {
        guard let searchText = searchTextField.text, searchText.count > 0, viewModel.paging != nil else {
            return
        }
        
        if !shouldLoadNewPage && viewModel.paging!.currentPage < viewModel.paging!.totalPages {
            self.shouldLoadNewPage = true
            viewModel.getResultImagesFor(searchText: searchText, pageNo: viewModel.paging!.currentPage + 1)
        }
    }
    
}


// MARK: - UICollectionViewDatasource methods
extension PhotosViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        
        cell.backgroundColor = .white
        let photo = viewModel.photos[indexPath.row]
        cell.title.text = photo.title
        cell.imageView.image = UIImage(named: "loading")
    
        if indexPath.row == viewModel.photos.count - 1 && viewModel.paging != nil {
            loadMoreImages()
        }
                
        if let cachedImage = cachedImages[photo.id] {
            
            cell.imageView.image = cachedImage
        } else {
            
            if let url = URL(string: photo.imageURLString) {
                
                NetworkHandler.shared.downloadImageWith(url: url) { (imgData) in
                    if let imgData = imgData, let image = UIImage(data: imgData) {
                        
                        self.cachedImages[photo.id] = image
                        
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                        }
                    } else {
                        DispatchQueue.main.async {
                            cell.imageView.image = UIImage(named: "imageError")
                        }
                    }
                }
            }
            
        }
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout methods
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalPadding = sectionInsets.left * (itemsPerRow + 1)
        let itemWidth = ((view.frame.width - totalPadding) / itemsPerRow - 5)
        let itemHeight = itemWidth + photoTitleHeight
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

// MARK: - UITextFieldDelegate methods
extension PhotosViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.paging = nil
        shouldLoadNewPage = true
        
        guard let searchText = textField.text, searchText.trimmingCharacters(in: .whitespaces).count > 0 else {
            shouldLoadNewPage = false
            collectionView.reloadData()
            return true
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        textField.addSubview(activityIndicator)
        activityIndicator.frame = textField.bounds
        activityIndicator.startAnimating()
        self.activityIndicator = activityIndicator
        
        viewModel.getResultImagesFor(searchText: searchText, pageNo: 1)
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.paging = nil
        shouldLoadNewPage = false
        collectionView.reloadData()
        return true
    }
}

// MARK: - PhotosViewModelDelegate methods
extension PhotosViewController: PhotosViewModelDelegate {
    func fetchDidCompleteWith(fetchType: FetchType) {
        DispatchQueue.main.async {
            switch fetchType {
            case .initial:
                self.activityIndicator?.removeFromSuperview()
            default:
               break
            }
            self.collectionView.reloadData()
            self.shouldLoadNewPage = false
        }
        
    }
    
    func fetchDidFailWith(reason: String) {
        print("Error while fetching Flickr Images!! - \(reason)")
    }
    
    
    
}

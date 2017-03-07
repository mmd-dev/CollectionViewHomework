//
//  ViewController.swift
//  CollectionViewHomeWork
//
//  Created by yan on 2017/02/27.
//  Copyright © 2017 mmd. All rights reserved.
//

import UIKit

import Photos

import AssetsLibrary

final class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    fileprivate let reuseIdentifier = "ViewCell"
    
    fileprivate let itemPerRow: CGFloat = 3
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 10.0, bottom: 50.0, right: 10.0)
    
    var images =  [ ["1", "2", "3", "4"], ["5", "6"] ]
    
    var assets = [UIImagePickerController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            let result: PHFetchResult = PHAsset.fetchAssets(with: nil)
            result.enumerateObjects({ (asset,_,_) in self.assets.append(asset) })
        }else if status == .notDetermined{
            PHPhotoLibrary.requestAuthorization( { (status) in
                DispatchQueue.main.async {
                    if status == .authorized{
                        let result: PHFetchResult<PHAsset> = PHAsset.fetchAssets(with: nil)
                        result.enumerateObjects( { (asset,_,_) in self.assets.append(asset)} )
                        self.collectionView?.reloadData()
                    }
                }
            } )
        }
//        let options = PHFetchOptions()
//        PHAsset.fetchAssets(with: options)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return self.images.count
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO:
        return self.assets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath) as!PhotoCell
        cell.backgroundColor = UIColor.black
        let asset = self.assets[indexPath.row]
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 40, height: 40), contentMode: .aspectFit, options: nil, resultHandler: { (image, nil) in cell.imageView.image = image })
        // Configure the cell
//        cell.imageView.image = UIImage(named: self.images[indexPath.section][indexPath.row])
        print(indexPath)
        return cell
        
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = (availableWidth / itemPerRow - 0.5)
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
        
    }
    
    
}

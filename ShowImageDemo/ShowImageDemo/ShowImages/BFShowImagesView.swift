//
//  BFShowImagesView.swift
//  ShowImageDemo
//
//  Created by midland on 2019/3/29.
//  Copyright © 2019年 midland. All rights reserved.
//

import UIKit

protocol BFShowImagesViewDelegate: class {
    func addImageAction()
    // calculateHeight
    func deleteImageAction()
    func showImageAction(model: BFShowImagesModel, models: [BFShowImagesModel], currentIndex: Int)
}

// MARK: - image add new & edit
class BFShowImagesView: UIView {
    
    var showImageHeightCallback: ((_ height: CGFloat) -> ())?

    weak var delegate: BFShowImagesViewDelegate?
    
    private var _style = BFShowImagesStyle() {
        didSet {
            collectionView.reloadData()
            calculateHeightCons()
        }
    }
    var style: BFShowImagesStyle {
        set {
            _style = newValue
        }
        get {
            return _style
        }
    }
    
    func setDatas(datas: [BFShowImagesModel]) {
        if datas.count < style.maxImagesCount {
             originImages = datas
        }
    }
    
    func setData(model: BFShowImagesModel) {
        if originImages.count < style.maxImagesCount {
            originImages.append(model)
            setDatas(datas: originImages)
        }
    }
    
    func getDatas() -> [BFShowImagesModel] {
        return originImages
    }
    
    private var originImages = [BFShowImagesModel]() {
        didSet {
            collectionView.reloadData()
            calculateHeightCons()
        }
    }
    private var images: [BFShowImagesModel] {
        if originImages.count < style.maxImagesCount {
            if let _ = style.addImage {
                let addModel = BFShowImagesModel()
                addModel.image = style.addImage
                return originImages + [addModel]
            }
            return originImages
        } else {
            return originImages
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCollectionView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
        calculateHeightCons()
    }
    
    // MARK: - Public methods
    func calculateHeight() -> CGFloat {
        let pWidth = bounds.width
        let itemWidth = (pWidth - (CGFloat)(style.column - 1) * style.minimumInteritemSpacing - style.sectionInsets.left - style.sectionInsets.right)  / (CGFloat)(style.column)
        let row = images.count % style.column == 0 ? (images.count / style.column) : (images.count / style.column + 1)
        var height: CGFloat = 0.0
        if style.itemHeight == 0 {
            height = CGFloat(row) * itemWidth + style.sectionInsets.top + style.sectionInsets.top  + CGFloat(row - 1) * style.minimumLineSpacing
        }
        if style.itemHeight > 0 {
            height = CGFloat(row) * style.itemHeight + style.sectionInsets.top + style.sectionInsets.top  + CGFloat(row - 1) * style.minimumLineSpacing
        }
        return height
    }
    
    // MARK: - Private methods
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BFShowImagesCell.self, forCellWithReuseIdentifier: "BFShowImagesCell")
        collectionView.backgroundColor = UIColor.clear
        addSubview(collectionView)
    }

    private func calculateHeightCons() {
        let pWidth = bounds.width
        let itemWidth = (pWidth - (CGFloat)(style.column - 1) * style.minimumInteritemSpacing - style.sectionInsets.left - style.sectionInsets.right)  / (CGFloat)(style.column)
        let row = images.count % style.column == 0 ? (images.count / style.column) : (images.count / style.column + 1)
        var height: CGFloat = 0.0
        if style.itemHeight == 0 {
            height = CGFloat(row) * itemWidth + style.sectionInsets.top + style.sectionInsets.top  + CGFloat(row - 1) * style.minimumLineSpacing
        }
        if style.itemHeight > 0 {
            height = CGFloat(row) * style.itemHeight + style.sectionInsets.top + style.sectionInsets.top  + CGFloat(row - 1) * style.minimumLineSpacing
        }
        if let _ = showImageHeightCallback {
            showImageHeightCallback!(height)
        }
    }
    
    // MARK: - Lazy load
    private lazy var collectionView: UICollectionView =  UICollectionView.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
}

// MARK: - UICollectionViewDataSource ,UICollectionViewDelegate
extension BFShowImagesView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = images[indexPath.item]
        if let image = model.image {
            if image == style.addImage! { // add new
                if let _ = delegate {
                    delegate?.addImageAction()
                    return
                }
                return
            }
        }
        
        // look
        let tempModels = images.filter {
            if let tempImage = $0.image {
                if tempImage == style.addImage! {
                    return false
                }
            }
            return true
        }
        if let _ = delegate {
            delegate?.showImageAction(model: model, models: tempModels, currentIndex: indexPath.item)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BFShowImagesCell", for: indexPath) as? BFShowImagesCell else {
            return UICollectionViewCell()
        }
        let model = images[indexPath.item]
        cell.indexPath = indexPath
        cell.delegate = self
        if let image = model.image {
             cell.deleteButton.isHidden = image != style.addImage! ? false : true
            cell.contentImageView.image = model.image
        } else {
            cell.deleteButton.isHidden = false
            // link download image
        }
        cell.deleteImageSize = style.deleteImageSize
        cell.deleteButton.setBackgroundImage(style.deleteImage, for: UIControl.State.normal)
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BFShowImagesView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return style.minimumInteritemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return style.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? CGSize.zero : CGSize(width: UIScreen.main.bounds.width, height: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return  style.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let pWidth = bounds.width
        let itemWidth = (pWidth - (CGFloat)(style.column - 1) * style.minimumInteritemSpacing - style.sectionInsets.left - style.sectionInsets.right)  / (CGFloat)(style.column)
        if style.itemHeight == 0 {
            return CGSize(width: itemWidth, height: itemWidth)
        }
        if style.itemHeight > 0 {
            return CGSize(width: itemWidth, height: style.itemHeight)
        }
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

// MARK: - BFShowImagesCellDelegate
extension BFShowImagesView: BFShowImagesCellDelegate {
    func showImagesCellDeleteAction(indexPath: IndexPath, cell: BFShowImagesCell) {
        if indexPath.item < originImages.count {
            originImages.remove(at: indexPath.item)
            collectionView.reloadData()
            calculateHeightCons()
        }
        if let _ = delegate {
            delegate?.deleteImageAction()
        }
    }
}

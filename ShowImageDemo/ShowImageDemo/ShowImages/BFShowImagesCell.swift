//
//  BFShowImagesCell.swift
//  ShowImageDemo
//
//  Created by midland on 2019/3/29.
//  Copyright © 2019年 midland. All rights reserved.
//

import UIKit

protocol BFShowImagesCellDelegate: class {
    func showImagesCellDeleteAction(indexPath: IndexPath, cell: BFShowImagesCell)
}

class BFShowImagesCell: UICollectionViewCell {
    
    var deleteImageSize = CGSize.init(width: 25, height: 25) {
        didSet {
            setNeedsLayout()
        }
    }
    var indexPath: IndexPath!
    weak var delegate: BFShowImagesCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentImageView.frame = bounds
        deleteButton.frame = CGRect.init(x: bounds.width - deleteImageSize.width, y: 0, width: deleteImageSize.width, height: deleteImageSize.height)
    }
    
    private func setupUI() {
        contentView.addSubview(contentImageView)
        contentView.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteImageAction), for: UIControl.Event.touchUpInside)
    }
    
    // MARK: - Event response
    @objc func deleteImageAction() {
        if let _ = delegate {
            delegate?.showImagesCellDeleteAction(indexPath: indexPath, cell: self)
        }
        
    }
    
    lazy var contentImageView = UIImageView()
    lazy var deleteButton = UIButton()
    
}

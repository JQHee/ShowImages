//
//  BFShowImagesStyle.swift
//  ShowImageDemo
//
//  Created by midland on 2019/3/29.
//  Copyright © 2019年 midland. All rights reserved.
//

import UIKit

class BFShowImagesStyle {
    
    var minimumInteritemSpacing: CGFloat = 0
    var minimumLineSpacing: CGFloat = 0
    var sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var addImage: UIImage? = UIImage.init(named: "show_image_add")
    var deleteImage: UIImage? = UIImage.init(named: "show_image_delete")
    var maxImagesCount = 5
    var column: Int = 3
    var itemHeight: CGFloat = 0
    var deleteImageSize = CGSize.init(width: 30, height: 30)
    var isShowAddImage: Bool = true
}

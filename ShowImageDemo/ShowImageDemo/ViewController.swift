//
//  ViewController.swift
//  ShowImageDemo
//
//  Created by midland on 2019/3/29.
//  Copyright © 2019年 midland. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var showImageView: BFShowImagesView!
    @IBOutlet weak var showImageViewHeightCons: NSLayoutConstraint!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        showImageView.style.column = 4
        showImageView.style.maxImagesCount = 9
        showImageView.style.minimumLineSpacing = 15
        showImageView.style.minimumInteritemSpacing = 15
        showImageView.showImageHeightCallback = {[weak self](height) in
            guard let `self` = self else {return}
            self.showImageViewHeightCons.constant = height
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

       
    }

    @IBAction func click(_ sender: Any) {
        let model = BFShowImagesModel()
        model.image = UIImage.init(named: "show_image_delete")
        showImageView.setData(model: model)

    }
    
}


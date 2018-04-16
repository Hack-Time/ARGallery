//
//  StyleImageController.swift
//  ARGallery
//
//  Created by kingcos on 2018/4/15.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit

class StyleImageController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    var style: String?
    var nextBarButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMainImageVeiw))
        mainImageView.addGestureRecognizer(tapGesture)
    }
}

extension StyleImageController {
    @objc func tappedMainImageVeiw() {
        print(#function)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
//        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .camera
        
        present(imagePickerController, animated: true)
    }
}

extension StyleImageController: UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        style = "简约冷"
        picker.dismiss(animated: true)
        let styleImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        mainImageView.image = styleImage
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExampleImageController") as? ExampleImageController
        controller?.style = style
        tabBarController?.navigationController?.pushViewController(controller!,
                                                                   animated: true)
    }
}

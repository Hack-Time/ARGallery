//
//  ExampleImageController.swift
//  ARGallery
//
//  Created by kingcos on 2018/4/15.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire

class ExampleImageController: UIViewController {

    @IBOutlet weak var mainImageView: UIImageView!
    var style: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Your Painting"
        view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedMainImageVeiw))
        mainImageView.addGestureRecognizer(tapGesture)
    }

}

extension ExampleImageController {
    @objc func tappedMainImageVeiw() {
        print(#function)
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        //        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        
        present(imagePickerController, animated: true)
    }
}

extension ExampleImageController: UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        let exampleImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        mainImageView.image = exampleImage
        
//        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExampleImageController")
//        tabBarController?.navigationController?.pushViewController(controller,
//                                                                   animated: true)
        
        HUD.show(.label("Loading..."))
        
//        let base64String = UIImageJPEGRepresentation(Helper.resizeImage(exampleImage!), 0.1)?.base64EncodedString()
        
        HUD.hide(afterDelay: 1.0)
        
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController
        
        controller?.image = UIImage(named: Helper.images[Helper.count])
        while Helper.count < 2 {
            Helper.count += 1
        }
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller!,
                                                          animated: true)
        }
        
//        Alamofire.request("https://api.deeparteffects.com/v1/noauth/upload",
//                          method: .post,
//                          parameters: ["styleId":Helper.styleIDs[style!]!,
//                                       "imageBase64Encoded":base64String!],
//                          encoding: JSONEncoding.default,
//                          headers: ["x-api-key" : "W3lvGLKrOg6ToXBlUigrb3I2iDEWN6lK3p8ThYO7"]).responseJSON { (response) in
//
//                            switch response.result {
//                            case .success(let value):
//                                let dict = value as! Dictionary<String,String>
//                                let submissionID = dict["submissionId"] as! String
//                                // ecf016ad-c1ad-4e80-9ec2-2685e05d26b6
//                                Alamofire.request("https://api.deeparteffects.com/v1/noauth/result?submissionId=\(submissionID)", method: .get, parameters: nil, headers: ["x-api-key" : "W3lvGLKrOg6ToXBlUigrb3I2iDEWN6lK3p8ThYO7"]).responseJSON(completionHandler: { (response) in
//                                    HUD.hide(animated: true)
//                                    switch response.result {
//                                    case .success(let value):
//                                        let dict = value as! Dictionary<String,String>
//                                        let imageURL = dict["url"] as! String
//                                        let url = URL(string: imageURL)
//                                        let data = try? Data(contentsOf: url!)
//
//                                        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as? ViewController
//                                        controller?.image = UIImage(data: data!)
//                                        DispatchQueue.main.async {
//                                            self.navigationController?.pushViewController(controller!,
//                                                                                                            animated: true)
//                                        }
//
//
//
//
//
//
//
//                                    case .failure(let error):
//                                        HUD.flash(.label((error as NSError).description), delay: 1.0)
//                                    }
//                                })
//
//                            case .failure(let error):
//                                HUD.hide(animated: true)
//                                HUD.flash(.label((error as NSError).description), delay: 1.0)
//                            }
//        }
        
    }
}

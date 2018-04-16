//
//  Helper.swift
//  ARGallery
//
//  Created by kingcos on 2018/4/14.
//  Copyright © 2018 kingcos. All rights reserved.
//

import UIKit

class Helper {
    
}

// API
extension Helper {
    static let styleImages = [
        "FanGaoXingKong": "https://i.loli.net/2018/04/14/5ad1da4b774ed.png",
        "DaFenQi": "",
        "GuoHua": "",
        "工笔1": "https://i.loli.net/2018/04/15/5ad2a9e434a25.jpg",
        "工笔2": "https://i.loli.net/2018/04/15/5ad2a9e43ecc6.jpg",
        "马拉之死1": "https://i.loli.net/2018/04/15/5ad2a9e442f19.jpg",
        "马拉之死2": "https://i.loli.net/2018/04/15/5ad2a9e4485f7.jpg",
    ]
    
    static let exampleImages = [
        "https://i.loli.net/2018/04/14/5ad1da6b5f355.jpg"
    ]
    
    static let deepAIAPIURL = "https://api.deepai.org/api/neural-style"
    static let deepAIAPIKey = "722e9f7c-6585-482d-83a6-102a80131332"
}

extension Helper {
    static let styleIDs = ["简约冷": "c7984d82-1560-11e7-afe2-06d95fe194ed",
                           "简约暖": "c7984bd2-1560-11e7-afe2-06d95fe194ed",
                           "油画冷": "c79857d7-1560-11e7-afe2-06d95fe194ed",
                           "油画暖": "c79856d6-1560-11e7-afe2-06d95fe194ed",]
    static let deepArtUploadAPI = "https://api.deeparteffects.com/v1/noauth/upload"
    static let deepArtGetResultAPI = "https://api.deeparteffects.com/v1/noauth/result?submissionId=1ffb37d6-4d4d-4b6f-ab9d-19e6c77b1424"
}

extension Helper {
    static var count = 0
    static let images = [
        "1.jpg",
        "2.jpg",
        "3.jpg"
    ]
    
    static func resizeImage(_ sourceImage: UIImage) -> UIImage {
        let size = CGSize(width: 300,
                          height: sourceImage.size.height / sourceImage.size.width * 300)
        UIGraphicsBeginImageContext(size)
        sourceImage.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage ?? sourceImage
    }
}

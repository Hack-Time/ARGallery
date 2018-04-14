//
//  APITests.swift
//  ARGalleryTests
//
//  Created by kingcos on 2018/4/14.
//  Copyright © 2018 kingcos. All rights reserved.
//

import XCTest
import Alamofire

class APITests: XCTestCase {
    
    func testSMMS() {
        
    }
    
    func testDeepAI() {
        let testStyleImageURL = "https://i.loli.net/2018/04/14/5ad1da4b774ed.png"
        let testInpurImageURL = "https://i.loli.net/2018/04/14/5ad1da6b5f355.jpg"
        let deepAIAPIURL = "https://api.deepai.org/api/neural-style"
        let parameters = [
            "style" : testStyleImageURL,
            "content" : testInpurImageURL
        ]
        let headers = [
            "api-key" : "722e9f7c-6585-482d-83a6-102a80131332"
        ]
        
        let expect = expectation(description: "Test Deep.AI API")
        
        Alamofire.request(deepAIAPIURL,
            method: .post,
            parameters: parameters,
            headers: headers).response { response in
                guard let data = response.data,
                      let result = String(data: data, encoding: .utf8) else {
                        print("Failed")
                        XCTFail("Deep.AI API failed.")
                        return
                }
                
                print(result)
                expect.fulfill()
        }
    }

}

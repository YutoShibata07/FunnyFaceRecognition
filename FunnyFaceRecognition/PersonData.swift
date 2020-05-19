//
//  PersonData.swift
//  FunnyFaceRecognition
//
//  Created by 柴田優斗 on 2019/12/29.
//  Copyright © 2019 柴田優斗. All rights reserved.
//

import Foundation

struct PersonData:Codable{
    var confidence:Double
    
    enum CodingKeys : String, CodingKey {
    //CodingKey = decodeメソッドを使うために満たす必要のあるプロトコル。
        case confidence
        //この名前と一致するものをJsonはDecodeする。だからプロトコルとしてcodingKeyを批准している。
    }
}

//
//  TokenModel.swift
//  myProject
//
//  Created by Владимир Курганов on 27.06.2022.
//

import Foundation

struct TokenModel: Decodable {
    
    let access_token: String
    let token_type: String
}

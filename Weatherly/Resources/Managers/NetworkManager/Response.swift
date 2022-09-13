//
//  Response.swift
//  Weatherly
//
//  Created by Aleksandr on 23.07.2022.
//

import Foundation

enum Response<T: Decodable> {
    case success(T)
    case failure(ResponseError)
}

enum ResponseError: Error {
    case serverNotResponding
    case noInternetConnection
}

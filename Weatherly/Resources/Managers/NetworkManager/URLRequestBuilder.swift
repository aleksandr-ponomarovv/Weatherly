//
//  URLRequestBuilder.swift
//  Weatherly
//
//  Created by Aleksandr on 23.07.2022.
//

import Alamofire

protocol URLRequestBuilder: URLRequestConvertible {
    var path: String { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
}

extension URLRequestBuilder {
    func asURLRequest() throws -> URLRequest {
        let url = try NetworkConstants.baseUrl.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        request.headers = .init()
        request = try URLEncoding.default.encode(request, with: parameters)
        return request
    }
}

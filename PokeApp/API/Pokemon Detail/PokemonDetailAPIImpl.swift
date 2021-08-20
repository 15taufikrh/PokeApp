//
//  PokemonDetailAPIImpl.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation
import RxSwift

class PokemonDetailAPIImpl: PokemonDetailAPI {
    
    private class PokemonDetailRequest: HTTPRequest {
        var method = HTTPMethods.GET
        var path = "/pokemon/"
        
        var parameters: [String : Any] = [:]
        
        init(param:String) {
            self.path = self.path + "\(param)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(param:String) -> Single<PokemonDetailResponse> {
        return httpClient.send(request: PokemonDetailRequest(param: param))
    }
}

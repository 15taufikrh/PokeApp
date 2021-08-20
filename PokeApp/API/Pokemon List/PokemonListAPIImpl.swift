//
//  PokemonListAPIImpl.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//

import RxSwift

class PokemonListAPIImpl: PokemonListAPI {
    
    private class PokemonListRequest: HTTPRequest {
        var method = HTTPMethods.GET
        var path = "/pokemon"
        var parameters: [String: Any]
        
        init(parameters: [String: Any]) {
            self.parameters = parameters
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(parameters: [String: Any]) -> Single<PokemonListResponse> {
        return httpClient.send(request: PokemonListRequest(parameters: parameters))
    }
}

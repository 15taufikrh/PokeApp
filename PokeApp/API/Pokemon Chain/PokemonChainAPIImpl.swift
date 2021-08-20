//
//  PokemonChainAPIImpl.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation
import RxSwift

class PokemonChainAPIImpl: PokemonChainAPI {
    
    private class PokemonChainRequest: HTTPRequest {
        var method = HTTPMethods.GET
        var path = "/evolution-chain/"
        
        var parameters: [String : Any] = [:]
        
        init(typeID:Int) {
            self.path = self.path + "\(typeID)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(typeID:Int) -> Single<PokemonChainResponse> {
        return httpClient.send(request: PokemonChainRequest(typeID: typeID))
    }
}




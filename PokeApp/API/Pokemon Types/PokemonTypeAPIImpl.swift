//
//  PokemonTypeAPIImpl.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation
import RxSwift

class PokemonTypeAPIImpl: PokemonTypeAPI {
    
    private class PokemonTypeRequest: HTTPRequest {
        var method = HTTPMethods.GET
        var path = "/type/"
        
        var parameters: [String : Any] = [:]
        
        init(typeID:Int) {
            self.path = self.path + "\(typeID)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(typeID:Int) -> Single<PokemonTypeResponse> {
        return httpClient.send(request: PokemonTypeRequest(typeID: typeID))
    }
}



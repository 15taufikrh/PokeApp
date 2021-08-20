//
//  PokemonSpeciesAPIImpl.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 20/08/21.
//

import Foundation
import RxSwift

class PokemonSpeciesAPIImpl: PokemonSpeciesAPI {
    
    private class PokemonSpeciesRequest: HTTPRequest {
        var method = HTTPMethods.GET
        var path = "/pokemon-species/"
        
        var parameters: [String : Any] = [:]
        
        init(pokemonID:Int) {
            self.path = self.path + "\(pokemonID)"
        }
    }
    
    let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func request(pokemonID:Int) -> Single<PokemonSpeciesResponse> {
        return httpClient.send(request: PokemonSpeciesRequest(pokemonID: pokemonID))
    }
}


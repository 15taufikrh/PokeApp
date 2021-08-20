//
//  PokemonController.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//

import Foundation
import CoreData

class PokemonController: DatabaseKit<Pokemon> {
    
    func readByName(name: String) -> Result<Pokemon, DatabaseError> {
        let filter = NSPredicate(format: "name == %@", name)
        let filterApplied = NSCompoundPredicate(type: .and, subpredicates: [filter])
        let fetch = self.read(predicate: filterApplied)
        switch fetch {
        case .success(let models):
            if let modelFilter = models.filter({ $0.name == name }).first{
                return .success(modelFilter)
            }else{
                return .failure(.custom("Not Found"))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func insertBulk(models: [PokemonModel]) -> Result<Bool, DatabaseError> {
        var itemStored = [Pokemon]()
        
        for model in models {
            self.context.performAndWait {
                let pokemon = Pokemon(context: self.context)
                pokemon.index = Int32(model.index)
                pokemon.name = model.name
                pokemon.imageUrl = model.imageURL
                pokemon.types = model.types.joined(separator: ",")
                
                do {
                    let result = try self.writeWith(return: pokemon).get()
                    itemStored.append(result)
                } catch let error {
                    print(error.localizedDescription)
                }
            }
            
            if itemStored.count == models.count {
                return .success(true)
            }
        }
        return .success(itemStored.count == models.count)
    }
    
    func update(pokemon:PokemonModel) -> Result<Pokemon, DatabaseError> {
        let fetch = self.readByName(name: pokemon.name)
        switch fetch {
        case .success(let model):
            
            model.imageUrl = pokemon.imageURL
            model.types = pokemon.types.joined(separator: ",")
            
            return self.writeWith(return: model)
        case .failure(let error):
            return .failure(error)
        }
    }
}

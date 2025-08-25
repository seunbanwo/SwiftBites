//
//  RecipeContainer.swift
//  SwiftBites
//
//  Created by Seun on 25/08/2025.
//

import Foundation
import SwiftData

enum RecipeSchemaV1: VersionedSchema {
    static var models: [any PersistentModel.Type] {
        [Category.self, Ingredient.self, RecipeIngredient.self, Recipe.self]
    }

    static var versionIdentifier: Schema.Version = .init(1, 1, 1)
}

class RecipeContainer {
    @MainActor
    static func create() -> ModelContainer {
        let schema = Schema(RecipeSchemaV1.models)
        let configuration = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: configuration)
        return container
    }
}

//
//  RecipeModels.swift
//  SwiftBites
//
//  Created by Seun on 24/08/2025.
//

import Foundation
import SwiftData

@Model
class Category: Identifiable, Hashable {
    @Attribute(.unique)
    var id: UUID
    
    var name: String

    @Relationship(deleteRule: .cascade, inverse: \Recipe.category)
    var recipes: [Recipe]
    
    init(id: UUID = UUID(), name: String, recipes: [Recipe] = []) {
        self.id = id
        self.name = name
        self.recipes = recipes
    }
    
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
class Ingredient: Identifiable, Hashable {
    @Attribute(.unique)
    var id: UUID
    
    var name: String

    init(id: UUID = UUID(), name: String = "") {
        self.id = id
        self.name = name
    }
    
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
class RecipeIngredient: Identifiable, Hashable {
    @Attribute(.unique)
    var id: UUID
    
    var ingredient: Ingredient
    var quantity: String
    //var recipe: Recipe?

    init(id: UUID = UUID(), ingredient: Ingredient = Ingredient(), quantity: String = "") {
        self.id = id
        self.ingredient = ingredient
        self.quantity = quantity
    }
    
    static func == (lhs: RecipeIngredient, rhs: RecipeIngredient) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Model
class Recipe: Identifiable, Hashable {
    @Attribute(.unique) var id: UUID
    var name: String
    var summary: String
    var category: Category?
    
    var serving: Int
    var time: Int
    
    var ingredients: [RecipeIngredient]
    
    var instructions: String
    var imageData: Data?
    
    init(
        id: UUID = UUID(),
        name: String,
        summary: String,
        category: Category? = nil,
        serving: Int,
        time: Int,
        ingredients: [RecipeIngredient] = [],
        instructions: String = "",
        imageData: Data? = nil
    ) {
        self.id = id
        self.name = name
        self.summary = summary
        self.category = category
        self.serving = serving
        self.time = time
        self.ingredients = ingredients
        self.instructions = instructions
        self.imageData = imageData
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


import SwiftUI
import SwiftData

struct IngredientsView: View {
  typealias Selection = (Ingredient) -> Void

  let selection: Selection?

  init(selection: Selection? = nil) {
    self.selection = selection
  }

  @Query private var allIngredients: [Ingredient]
  @Environment(\.modelContext) private var modelContext
  @State private var query = ""

  // MARK: - Body

  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Ingredients")
        .toolbar {
          if !allIngredients.isEmpty {
            NavigationLink(value: IngredientForm.Mode.add) {
              Label("Add", systemImage: "plus")
            }
          }
        }
        .navigationDestination(for: IngredientForm.Mode.self) { mode in
          IngredientForm(mode: mode)
        }
    }
  }

  // MARK: - Views

  @ViewBuilder
  private var content: some View {
      if allIngredients.isEmpty {
          empty
      } else {
          FilteredIngredientsList(
              query: query,
              selection: selection,
              onDelete: delete
          )
          .searchable(text: $query)
      }
  }

  private var empty: some View {
    ContentUnavailableView(
      label: {
        Label("No Ingredients", systemImage: "list.clipboard")
      },
      description: {
        Text("Ingredients you add will appear here.")
      },
      actions: {
        NavigationLink("Add Ingredient", value: IngredientForm.Mode.add)
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
      }
    )
  }

  // MARK: - Data

  private func delete(ingredient: Ingredient) {
      modelContext.delete(ingredient)
  }
}

private struct FilteredIngredientsList: View {
    typealias Selection = IngredientsView.Selection

    @Query private var ingredients: [Ingredient]
    @Environment(\.dismiss) private var dismiss

    private let query: String
    private let selection: Selection?
    private let onDelete: (Ingredient) -> Void
    
    init(query: String, selection: Selection?, onDelete: @escaping (Ingredient) -> Void) {
        self.query = query
        self.selection = selection
        self.onDelete = onDelete
        
        let predicate = #Predicate<Ingredient> { ingredient in
            query.isEmpty || ingredient.name.localizedStandardContains(query)
        }
        
        _ingredients = Query(filter: predicate, sort: \Ingredient.name)
    }
    
    var body: some View {
        List {
            if ingredients.isEmpty {
                noResults
            } else {
                ForEach(ingredients) { ingredient in
                    row(for: ingredient)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                onDelete(ingredient)
                            }
                        }
                }
            }
        }
        .listStyle(.plain)
    }
    
    private var noResults: some View {
      ContentUnavailableView(
        label: {
          Text("Couldn't find \"\(query)\"")
        }
      )
      .listRowSeparator(.hidden)
    }
    
    @ViewBuilder
    private func row(for ingredient: Ingredient) -> some View {
      if let selection {
        Button(
          action: {
            selection(ingredient)
            dismiss()
          },
          label: {
            title(for: ingredient)
          }
        )
      } else {
        NavigationLink(value: IngredientForm.Mode.edit(ingredient)) {
          title(for: ingredient)
        }
      }
    }

    private func title(for ingredient: Ingredient) -> some View {
      Text(ingredient.name)
        .font(.title3)
    }
}

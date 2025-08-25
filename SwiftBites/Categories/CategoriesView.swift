import SwiftUI
import SwiftData

struct CategoriesView: View {
  @Environment(\.modelContext) private var modelContext
  @Query private var allCategories: [Category]
  @State private var query = ""

  // MARK: - Body

  var body: some View {
    NavigationStack {
      content
        .navigationTitle("Categories")
        .toolbar {
          if !allCategories.isEmpty {
            NavigationLink(value: CategoryForm.Mode.add) {
              Label("Add", systemImage: "plus")
            }
          }
        }
        .navigationDestination(for: CategoryForm.Mode.self) { mode in
          CategoryForm(mode: mode)
        }
        .navigationDestination(for: RecipeForm.Mode.self) { mode in
          RecipeForm(mode: mode)
        }
    }
  }

  // MARK: - Views
    @ViewBuilder
    private var content: some View {
        if allCategories.isEmpty {
            empty
        } else {
            FilteredCategoriesList(query: query)
                .searchable(text: $query)
        }
    }

  private var empty: some View {
    ContentUnavailableView(
      label: {
        Label("No Categories", systemImage: "list.clipboard")
      },
      description: {
        Text("Categories you add will appear here.")
      },
      actions: {
        NavigationLink("Add Category", value: CategoryForm.Mode.add)
          .buttonBorderShape(.roundedRectangle)
          .buttonStyle(.borderedProminent)
      }
    )
  }
}

private struct FilteredCategoriesList: View {
    @Query private var categories: [Category]
    private var query: String

    init(query: String) {
        self.query = query
        let predicate = #Predicate<Category> { category in
            query.isEmpty || category.name.localizedStandardContains(query)
        }
        
        _categories = Query(filter: predicate, sort: \Category.name)
    }

    var body: some View {
        ScrollView(.vertical) {
            if categories.isEmpty {
                noResults
            } else {
                LazyVStack(spacing: 10) {
                    ForEach(categories, content: CategorySection.init)
                }
            }
        }
    }
    
    private var noResults: some View {
      ContentUnavailableView(
        label: {
          Text("Couldn't find \"\(query)\"")
        }
      )
    }
}

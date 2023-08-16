import SwiftUI
import InstantSearchSwiftUI

struct ContentView: View {
  @ObservedObject var searchBoxController: SearchBoxObservableController
  @ObservedObject var hitsController: HitsObservableController<StockItem>
  @ObservedObject var statsController: StatsTextObservableController
  @ObservedObject var facetListController: FacetListObservableController
  
  @State private var isEditing = false
  @State private var isPresentingFacets = false
  
  //MARK: - Search Bar, Stats, and Hits List
  
  var body: some View {
    VStack(spacing: 7) {
      SearchBar(text: $searchBoxController.query,
                isEditing: $isEditing,
                onSubmit: searchBoxController.submit)
      Text(statsController.stats)
        .fontWeight(.medium)
      HitsList(hitsController) { (hit, _) in
        VStack(alignment: .leading, spacing: 10) {
          Text(hit?.name ?? "")
            .padding(.all, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
          Divider()
        }
      } noResults: {
        Text("No Results")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .navigationBarTitle("Algolia & SwiftUI")
    .navigationBarItems(trailing: facetsButton())
    .sheet(isPresented: $isPresentingFacets, content: facets)
  }
  
  //MARK: - Facet List
  
  @ViewBuilder
  private func facets() -> some View {
    NavigationView {
      FacetList(facetListController) { facet, isSelected in
        VStack {
          FacetRow(facet: facet, isSelected: isSelected)
          Divider()
        }
      } noResults: {
        Text("No facet found")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
      .navigationBarTitle("Brand")
    }
  }
  
  private func facetsButton() -> some View {
    Button(action: {
      isPresentingFacets.toggle()
    },
           label: {
      Image(systemName: "line.horizontal.3.decrease.circle")
        .font(.title)
    })
  }
}

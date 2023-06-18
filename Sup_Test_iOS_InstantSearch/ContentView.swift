//
//  ContentView.swift
//  Sup_Test_iOS_InstantSearch
//
//  Created by Steven Kaiser on 6/14/23.
//

import SwiftUI
import InstantSearchSwiftUI
import InstantSearchCore

struct StockItem: Codable {
  let name: String
}

struct ContentView: View {
  @ObservedObject var searchBoxController: SearchBoxObservableController
  @ObservedObject var hitsController: HitsObservableController<StockItem>
  @ObservedObject var statsController: StatsObservableController
  @ObservedObject var facetListController: FacetListObservableController
  
  @State private var isEditing = false
  @State private var isPresentingFacets = false

  var body: some View {
    VStack(spacing: 7) {
      SearchBar(text: $searchBoxController.query,
                isEditing: $isEditing,
                onSubmit: searchBoxController.submit)
//      UNCOMMENT FOR STATS -- need to escalate, getting error
//      Text(statsController.stats)
//        .fontWeight(.medium)
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



struct ContentView_Previews: PreviewProvider {
  
  static let algoliaController = AlgoliaController()
  
  static var previews: some View {
    NavigationView {
      ContentView(searchBoxController: algoliaController.searchBoxController,
                  hitsController: algoliaController.hitsController,
                  statsController: algoliaController.statsController,
                  facetListController: algoliaController.facetListController)
    }.onAppear {
      algoliaController.searcher.search()
    }
  }
  
}



class AlgoliaController {
  
  let searcher: HitsSearcher

  let searchBoxInteractor: SearchBoxInteractor
  let searchBoxController: SearchBoxObservableController

  let hitsInteractor: HitsInteractor<StockItem>
  let hitsController: HitsObservableController<StockItem>
  
  let statsInteractor: StatsInteractor
  let statsController: StatsObservableController
  
  let filterState: FilterState
  
  let facetListInteractor: FacetListInteractor
  let facetListController: FacetListObservableController
  
  init() {
    self.searcher = HitsSearcher(appID: "latency",
                                 apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                 indexName: "bestbuy")
    self.searchBoxInteractor = .init()
    self.searchBoxController = .init()
    self.hitsInteractor = .init()
    self.hitsController = .init()
    self.statsInteractor = .init()
    self.statsController = .init()
    self.filterState = .init()
    self.facetListInteractor = .init()
    self.facetListController = .init()
    setupConnections()
  }
  
  func setupConnections() {
    searchBoxInteractor.connectSearcher(searcher)
    searchBoxInteractor.connectController(searchBoxController)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsController)
    statsInteractor.connectSearcher(searcher)
//    UNCOMMENT FOR STATS -- need to escalate, getting error
//    statsInteractor.connectController(statsController)
    facetListInteractor.connectSearcher(searcher, with: "manufacturer")
    facetListInteractor.connectFilterState(filterState, with: "manufacturer", operator: .or)
    facetListInteractor.connectController(facetListController, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))

  }
  
  
      
}


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
  
  @State private var isEditing = false

  var body: some View {
    VStack(spacing: 7) {
      SearchBar(text: $searchBoxController.query,
                isEditing: $isEditing,
                onSubmit: searchBoxController.submit)
      HitsList(hitsController) { (hit, _) in
        VStack(alignment: .leading, spacing: 10) {
          Text(hit?.name ?? "")
            .padding(.all, 10)
          Divider()
        }
      } noResults: {
        Text("No Results")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .navigationBarTitle("Algolia & SwiftUI")
  }


}

struct ContentView_Previews: PreviewProvider {
  
  static let algoliaController = AlgoliaController()
  
  static var previews: some View {
    NavigationView {
      ContentView(searchBoxController: algoliaController.searchBoxController,
                  hitsController: algoliaController.hitsController)
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
  
  init() {
    self.searcher = HitsSearcher(appID: "latency",
                                 apiKey: "1f6fd3a6fb973cb08419fe7d288fa4db",
                                 indexName: "bestbuy")
    self.searchBoxInteractor = .init()
    self.searchBoxController = .init()
    self.hitsInteractor = .init()
    self.hitsController = .init()
    setupConnections()
  }
  
  func setupConnections() {
    searchBoxInteractor.connectSearcher(searcher)
    searchBoxInteractor.connectController(searchBoxController)
    hitsInteractor.connectSearcher(searcher)
    hitsInteractor.connectController(hitsController)
  }
      
}


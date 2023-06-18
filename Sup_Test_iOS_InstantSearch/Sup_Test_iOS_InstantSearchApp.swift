//
//  Sup_Test_iOS_InstantSearchApp.swift
//  Sup_Test_iOS_InstantSearch
//
//  Created by Steven Kaiser on 6/14/23.
//

import SwiftUI

@main
struct Sup_Test_iOS_InstantSearchApp: App {
    let algoliaController = AlgoliaController()
    var body: some Scene {
        WindowGroup {
          NavigationView {
            ContentView(
              searchBoxController:algoliaController.searchBoxController,
              hitsController: algoliaController.hitsController,
              statsController: algoliaController.statsController,
              facetListController: algoliaController.facetListController)
          }.onAppear {
            algoliaController.searcher.search()
          }
        }
    }
}

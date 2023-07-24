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

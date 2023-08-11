import InstantSearchSwiftUI
import InstantSearchCore

class AlgoliaController {
  
  let searcher: HitsSearcher
  
  let searchBoxInteractor: SearchBoxInteractor
  let searchBoxController: SearchBoxObservableController
  
  let hitsInteractor: HitsInteractor<StockItem>
  let hitsController: HitsObservableController<StockItem>
  
  let statsInteractor: StatsInteractor
  let statsController: StatsTextObservableController
  
  let filterState: FilterState
  
  let facetListInteractor: FacetListInteractor
  let facetListController: FacetListObservableController
  
  init() {
    //    self.searcher = HitsSearcher(appID: "<<YOUR_APP_ID>>",
    //                                 apiKey: "<<YOUR_SEARCH_API_KEY>>",
    //                                 indexName: "<<YOUR_INDEX_NAME>>")
    self.searcher = HitsSearcher(appID: "latency",
                                 apiKey: "af044fb0788d6bb15f807e4420592bc5",
                                 indexName: "products")
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
    statsInteractor.connectController(statsController)
    facetListInteractor.connectSearcher(searcher, with: "brand")
    facetListInteractor.connectFilterState(filterState, with: "brand", operator: .or)
    facetListInteractor.connectController(facetListController, with: FacetListPresenter(sortBy: [.isRefined, .count(order: .descending)]))
  }
}

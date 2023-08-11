/*Defines a structure that represent a record in your index.
 
 For simplicity’s sake, the structure only provides the name of the product.
 
 It must conform to the Codable protocol to work with InstantSearch.*/

struct StockItem: Codable {
  let name: String
}

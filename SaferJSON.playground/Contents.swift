import Foundation
import PlaygroundSupport
import SaferJSON

//PlaygroundPage.current.needsIndefiniteExecution = true

do {
    let url = URL(string: "https://jsonplaceholder.typicode.com/users/1")!
    let json = try SaferJSON(data: Data(contentsOf: url))
    print(json)
    var geo: SaferJSON = json.address.geo
    geo.latitude = geo.lat as SaferJSON
    print(geo)
} catch {
    print(error)
}

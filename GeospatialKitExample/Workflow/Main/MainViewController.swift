import GeospatialKit

// swiftlint:disable force_cast
class MainViewController: UIViewController {
    internal let timberHandler = TimberHandler()
    
    let geoJsonObjects = (IntegrationData.geoJsonTestData["geoJsonObjects"] as! [GeoJsonDictionary]) + [(IntegrationData.geoJsonTestDataBig)]
    
    let geospatial = GeospatialCocoa()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let displayViewController = segue.destination as! DisplayViewController
        
        displayViewController.geospatial = geospatial
        displayViewController.geoJsonObject = (sender as! GeoJsonCell).geoJsonObject
    }
}

#warning("Section by GeoJson and WKT?")
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoJsonObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GeoJsonCell") as? GeoJsonCell else { return UITableViewCell() }
        
        cell.textLabel?.text = geoJsonObjects[indexPath.row]["name"] as? String
        cell.geoJsonObject = geospatial.geoJson.parse(geoJson: geoJsonObjects[indexPath.row]["geoJson"] as! GeoJsonDictionary).success
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate { }

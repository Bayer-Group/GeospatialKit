import XCTest

@testable import GeospatialKit

class PointProjectorTests: XCTestCase {
    var pointProjector: PointProjector!
    
    var boundingBox: MockGeoJsonBoundingBox!
    
    override func setUp() {
        super.setUp()
        
        boundingBox = MockGeoJsonBoundingBox()
        let boundingCoordinates: BoundingCoordinates = (minLongitude: 20, minLatitude: 25, maxLongitude: 30, maxLatitude: 35)
        boundingBox.boundingCoordinatesResult = boundingCoordinates
        
        pointProjector = PointProjector(boundingBox: boundingBox, width: 100, height: 100)
    }
    
    func testAsPoints_NoPoints() {
        let cgPoints = pointProjector.asPoints([])
        
        XCTAssertEqual(cgPoints.count, 0)
    }
    
    // SOMEDAY: Need good tests which are straightforward to check this logic.
    func testAsPoints_OnePoint() {
        let cgPoints = pointProjector.asPoints([GeoTestHelper.simplePoint(1, 2, 3)])
        
        XCTAssertEqual(cgPoints.count, 1)
        XCTAssertEqual(cgPoints[0].x.bitPattern, 13861716411871999040)
        XCTAssertEqual(cgPoints[0].y.bitPattern, 4643339655210954334)
    }
    
    func testAsPoints_MultiplePoints() {
        let cgPoints = pointProjector.asPoints([GeoTestHelper.simplePoint(1, 2, 3), GeoTestHelper.simplePoint(2, 3, 4), GeoTestHelper.simplePoint(3, 4, 5)])
        
        XCTAssertEqual(cgPoints.count, 3)
        XCTAssertEqual(cgPoints[0].x.bitPattern, 13861716411871999040)
        XCTAssertEqual(cgPoints[0].y.bitPattern, 4643339655210954334)
        XCTAssertEqual(cgPoints[1].x.bitPattern, 13861209645401614208)
        XCTAssertEqual(cgPoints[1].y.bitPattern, 4643212841280414570)
        XCTAssertEqual(cgPoints[2].x.bitPattern, 13860702878931229360)
        XCTAssertEqual(cgPoints[2].y.bitPattern, 4642960606766465092)
    }
}

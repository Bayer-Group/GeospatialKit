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
    
    // TODO: Need good tests which are straightforward to check this logic.
    func testAsPoints_OnePoint() {
        let cgPoints = pointProjector.asPoints([GeoTestHelper.simplePoint(1, 2, 3)])
        
        XCTAssertEqual(cgPoints.count, 1)
        XCTAssertEqual(cgPoints[0].x.bitPattern, 13861229916060429584)
        XCTAssertEqual(cgPoints[0].y.bitPattern, 4643167900225557472)
    }
    
    func testAsPoints_MultiplePoints() {
        let cgPoints = pointProjector.asPoints([GeoTestHelper.simplePoint(1, 2, 3), GeoTestHelper.simplePoint(2, 3, 4), GeoTestHelper.simplePoint(3, 4, 5)])
        
        XCTAssertEqual(cgPoints.count, 3)
        XCTAssertEqual(cgPoints[0].x.bitPattern, 13861229916060429584)
        XCTAssertEqual(cgPoints[0].y.bitPattern, 4643167900225557472)
        XCTAssertEqual(cgPoints[1].x.bitPattern, 13860743420248860128)
        XCTAssertEqual(cgPoints[1].y.bitPattern, 4642924417478921128)
        XCTAssertEqual(cgPoints[2].x.bitPattern, 13860256924437290672)
        XCTAssertEqual(cgPoints[2].y.bitPattern, 4642680711902553760)
    }
}

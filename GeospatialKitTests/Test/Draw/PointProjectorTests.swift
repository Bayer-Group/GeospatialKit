import XCTest

import GeospatialSwift

@testable import GeospatialKit

class PointProjectorTests: XCTestCase {
    var pointProjector: PointProjector!
    
    var boundingBox: GeodesicBoundingBox!
    
    override func setUp() {
        super.setUp()
        
        boundingBox = .init(minLongitude: 20, minLatitude: 25, maxLongitude: 30, maxLatitude: 35)
        
        pointProjector = PointProjector(boundingBox: boundingBox, width: 100, height: 100)
    }
    
    func testAsPoints_NoPoints() {
        let cgPoints = pointProjector.asPoints([])
        
        XCTAssertEqual(cgPoints.count, 0)
    }
    
    #warning("Need good tests which are straightforward to check this logic.")
    func testAsPoints_OnePoint() {
        let cgPoints = pointProjector.asPoints([GeoTestHelper.simplePoint(1, 2, 3)])
        
        XCTAssertEqual(cgPoints.count, 1)
        XCTAssertEqual(cgPoints[0].x.bitPattern, 13863114271988116512)
        XCTAssertEqual(cgPoints[0].y.bitPattern, 4644090141154378860)
    }
    
    func testAsPoints_MultiplePoints() {
        let cgPoints = pointProjector.asPoints([GeoTestHelper.simplePoint(1, 2, 3), GeoTestHelper.simplePoint(2, 3, 4), GeoTestHelper.simplePoint(3, 4, 5)])
        
        XCTAssertEqual(cgPoints.count, 3)
        XCTAssertEqual(cgPoints[0].x.bitPattern, 13863114271988116512)
        XCTAssertEqual(cgPoints[0].y.bitPattern, 4644090141154378860)
        XCTAssertEqual(cgPoints[1].x.bitPattern, 13862810212105885616)
        XCTAssertEqual(cgPoints[1].y.bitPattern, 4643937964437731144)
        XCTAssertEqual(cgPoints[2].x.bitPattern, 13862506152223654704)
        XCTAssertEqual(cgPoints[2].y.bitPattern, 4643785648452501544)
    }
}

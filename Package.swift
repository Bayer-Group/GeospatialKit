// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "GeospatialKit",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "GeospatialKit",
            targets: ["GeospatialKit"]),
    ],
    dependencies: [
        .package(name: "GeospatialSwift", url: "https://github.com/MonsantoCo/GeospatialSwift.git", from: "1.1.1"),
        .package(name: "TimberSwift", url: "https://github.com/MonsantoCo/TimberSwift.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "GeospatialKit",
            dependencies: ["GeospatialSwift", "TimberSwift"],
            path: "GeospatialKit"
        ),
        .testTarget(
            name: "GeospatialKitTests",
            dependencies: ["GeospatialKit"],
            path: "GeospatialKitTests"
        )
    ]
)

// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "GeospatialKit",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "GeospatialKit",
            targets: ["GeospatialKit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/MonsantoCo/GeospatialSwift.git", branch: "bug/SCOUT-2135-Isolation-Distance-is-not-accurate"),
//        .package(name: "GeospatialSwift", url: "https://github.com/MonsantoCo/GeospatialSwift.git", from: "1.2.0"),
        .package(name: "TimberSwift", url: "https://github.com/MonsantoCo/TimberSwift.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "GeospatialKit",
            dependencies: ["GeospatialSwift", "TimberSwift"],
            path: "GeospatialKit",
            exclude: ["Info.plist"]
        ),
        .testTarget(
            name: "GeospatialKitTests",
            dependencies: ["GeospatialKit"],
            path: "GeospatialKitTests",
            exclude: ["Info.plist"],
            resources: [.process("Data/WktTestData.json")]
        )
    ]
)

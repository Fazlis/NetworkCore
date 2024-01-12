// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EONetworkCore",
    
    products: [
        .library(
            name: "EONetworkCore",
            targets: ["EONetworkCore"]
        )
    ],
    
    dependencies: [
        .package(
            url: "https://github.com/SwiftyJSON/SwiftyJSON.git",
            from: "4.0.0"
        )
    ],
    
    targets: [
        .target(
            name: "EONetworkCore",
            dependencies: ["SwiftyJSON"]
        ),
        
        .testTarget(
            name: "EONetworkCoreTests",
            dependencies: ["EONetworkCore"]
        ),
    ]
)

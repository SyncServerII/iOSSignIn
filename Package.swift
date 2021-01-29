// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "iOSSignIn",
    platforms: [
        // This package uses SwiftUI-- only available starting with iOS 13.
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "iOSSignIn",
            targets: ["iOSSignIn"]),
    ],
    
    // Binary packages:
    // https://github.com/apple/swift-evolution/blob/master/proposals/0272-swiftpm-binary-dependencies.md
    
    // Conditional dependencies available in Swift 5.3:
    // https://github.com/apple/swift-evolution/blob/master/proposals/0273-swiftpm-conditional-target-dependencies.md
    dependencies: [
        .package(url: "https://github.com/SyncServerII/ServerShared.git", from: "0.0.4"),
        .package(url: "https://github.com/SyncServerII/iOSShared.git", from: "0.0.2"),

        //.package(path: "../ServerShared"),
        
        // 5/1/20; Can't import SwiftyDropbox as a swift package:
        // https://github.com/dropbox/SwiftyDropbox/issues/252
        // .package(url: "https://github.com/dropbox/SwiftyDropbox.git", .upToNextMajor(from: "5.1.0")),
        
        .package(url: "https://github.com/crspybits/PersistentValue.git", from: "0.7.1"),
    ],
    
    targets: [
        .target(
            name: "iOSSignIn",
            dependencies: [
                "ServerShared", "PersistentValue", "iOSShared"
            ]),
        .testTarget(
            name: "iOSSignInTests",
            dependencies: [
                "iOSSignIn"
            ]),
    ]
)

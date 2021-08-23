// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ABAlbum",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "ABAlbum",
            targets: ["ABAlbum"]),
    ],
    dependencies: [
        .package(name: "ZoomableImageView", url: "https://github.com/rushairer/ZoomableImageView.git", from: "1.0.0"),
        .package(name: "SwiftConcurrencyExtensions", path: "../SwiftConcurrencyExtensions")
    ],
    targets: [
        .target(
            name: "ABAlbum",
            dependencies: [
                "ZoomableImageView",
                "SwiftConcurrencyExtensions"
            ]),
        .testTarget(
            name: "ABAlbumTests",
            dependencies: ["ABAlbum"]),
    ],
    swiftLanguageVersions: [.v5]
)

// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "tiktok_events_sdk",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(name: "tiktok-events-sdk", targets: ["tiktok_events_sdk"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tiktok/tiktok-business-ios-sdk", from: "1.6.1"),
    ],
    targets: [
        .target(
            name: "tiktok_events_sdk",
            dependencies: [
                .product(name: "TikTokBusinessSDK", package: "tiktok-business-ios-sdk"),
            ],
            path: "Sources/tiktok_events_sdk"
        ),
    ]
)

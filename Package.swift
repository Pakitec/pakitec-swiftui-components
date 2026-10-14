// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PakitecSwiftUIComponents",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "PakitecSwiftUIComponents", targets: ["PakitecSwiftUIComponents"])
    ],
    targets: [
        .target(name: "PakitecSwiftUIComponents"),
        .testTarget(name: "PakitecSwiftUIComponentsTests", dependencies: ["PakitecSwiftUIComponents"])
    ]
)

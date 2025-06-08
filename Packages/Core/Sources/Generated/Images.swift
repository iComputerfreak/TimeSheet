// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import SwiftUI

private let bundle = Bundle(for: BundleToken.self)

// MARK: - Asset Catalogs

public enum Images {
    public static let testImage = ImageAsset(name: "testImage")
}

// MARK: - Implementation Details

public struct ImageAsset: Sendable {
    fileprivate let name: String

    public var image: Image {
        return Image(name, bundle: bundle)
    }

    public var uiImage: UIImage {
        return UIImage(named: name, in: bundle, with: nil)!
    }
}

private final class BundleToken {}

// swiftlint:enable all
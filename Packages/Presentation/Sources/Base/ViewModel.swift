// Copyright © 2025 Jonas Frey. All rights reserved.

import SwiftUI

@MainActor
public protocol ViewModel<ViewState> {
    associatedtype ViewState: Observable

    var state: ViewState { get set }
}

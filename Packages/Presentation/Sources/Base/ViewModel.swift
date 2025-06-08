// Copyright © 2025 Jonas Frey. All rights reserved.

public protocol ViewModel<ViewState> {
    associatedtype ViewState
    var state: ViewState { get set }
}

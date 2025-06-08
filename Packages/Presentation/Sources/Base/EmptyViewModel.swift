// Copyright © 2025 Jonas Frey. All rights reserved.

public class EmptyViewModel<ViewState>: ViewModel {
    public var state: ViewState

    init(state: ViewState) {
        self.state = state
    }
}

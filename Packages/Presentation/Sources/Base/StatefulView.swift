// Copyright © 2025 Jonas Frey. All rights reserved.

import SwiftUI

public protocol StatefulView: View {
    associatedtype ViewState
    var viewModel: any ViewModel<ViewState> { get set }
}

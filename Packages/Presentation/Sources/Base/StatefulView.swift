// Copyright © 2025 Jonas Frey. All rights reserved.

import SwiftUI

public protocol StatefulView: View {
    associatedtype ViewModel

    var viewModel: ViewModel { get set }

    init(viewModel: ViewModel)
}

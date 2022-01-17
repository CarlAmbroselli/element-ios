// 
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

@available(iOS 14.0, *)
struct AddRoomSelector: View {
    
    // MARK: Properties
    
    @ObservedObject var viewModel: MatrixItemChooserViewModel.Context
    
    // MARK: Private
    
    @Environment(\.theme) private var theme: ThemeSwiftUI

    @ViewBuilder
    var body: some View {
        MatrixItemChooser(viewModel: viewModel)
            .background(theme.colors.background)
            .navigationBarItems(leading: Button(VectorL10n.cancel, action: {
                viewModel.send(viewAction: .cancel)
            })
            .font(theme.fonts.body)
            .foregroundColor(theme.colors.accent),
            trailing: Button(VectorL10n.add, action: {
                viewModel.send(viewAction: .done)
            })
            .font(theme.fonts.body)
            .foregroundColor(viewModel.viewState.selectedItemIds.isEmpty ? theme.colors.quarterlyContent : theme.colors.accent)
            .opacity(viewModel.viewState.selectedItemIds.isEmpty ? 0.7 : 1)
            .disabled(viewModel.viewState.selectedItemIds.isEmpty))
    }

}
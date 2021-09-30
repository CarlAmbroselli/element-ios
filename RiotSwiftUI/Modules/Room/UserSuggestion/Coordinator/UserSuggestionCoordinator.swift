// File created from SimpleUserProfileExample
// $ createScreen.sh Room/UserSuggestion UserSuggestion
/*
 Copyright 2021 New Vector Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

import Foundation
import UIKit
import SwiftUI

final class UserSuggestionCoordinator: Coordinator {
    
    // MARK: - Properties
    
    // MARK: Private
    
    private let parameters: UserSuggestionCoordinatorParameters
    private let userSuggestionHostingController: UIViewController
    
    private var userSuggestionService: UserSuggestionServiceProtocol
    private var userSuggestionViewModel: UserSuggestionViewModelProtocol
    
    // MARK: Public

    // Must be used only internally
    var childCoordinators: [Coordinator] = []
    var completion: (() -> Void)?
    
    // MARK: - Setup
    
    @available(iOS 14.0, *)
    init(parameters: UserSuggestionCoordinatorParameters) {
        self.parameters = parameters
        
        userSuggestionService = UserSuggestionService(session: parameters.room)
        userSuggestionViewModel = UserSuggestionViewModel.makeUserSuggestionViewModel(userSuggestionService: userSuggestionService)
        
        let view = UserSuggestionList(viewModel: viewModel.context)
            .addDependency(AvatarService.instantiate(mediaManager: parameters.session.mediaManager))
        
        userSuggestionHostingController = VectorHostingController(rootView: view)
    }
    
    // MARK: - Public
    func start() {
        MXLog.debug("[UserSuggestionCoordinator] did start.")
        userSuggestionViewModel.completion = { [weak self] result in
            MXLog.debug("[UserSuggestionCoordinator] UserSuggestionViewModel did complete with result: \(result).")
            guard let self = self else { return }
            switch result {
            case .cancel, .done:
                self.completion?()
                break
            }
        }
    }
    
    func toPresentable() -> UIViewController {
        return self.userSuggestionHostingController
    }
}

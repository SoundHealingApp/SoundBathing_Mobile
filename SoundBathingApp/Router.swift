//
//  Router.swift
//  SoundBathingApp
//
//  Created by Ирина Печик on 09.02.2025.
//

import Foundation
import SwiftUI
import Observation

@Observable
class Router {
    var path = NavigationPath()
    
    func navigateToNameEnteringView() {
        path.append(Route.nameEnteringView)
    }
    
    func navigateToBirthEnteringView() {
        path.append(Route.birthEnteringView)
    }
    
    func navigateToSignUp() {
        path.append(Route.signUp)
    }
    
    func navigateToSwiftUIView() {
        path.append(Route.swiftUIView)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
}

struct RouterViewModifier: ViewModifier {
    @State private var router = Router()
    
    private func routeView(for route: Route) -> some View {
        Group {
            switch route {
            case .signUp:
                RegisterView()
            case .nameEnteringView:
                NameEnteringView()
            case .birthEnteringView:
                BirthdateEnteringView()
            case .swiftUIView: // TODO: delete
                SwiftUIView()
            }
        }
        .environment(router)
    }
    
    func body(content: Content) -> some View {
        NavigationStack(path: $router.path) {
            content
                .environment(router)
                .navigationDestination(for: Route.self) { rout in
                    routeView(for: rout)
                }
        }
    }
}

extension View {
    func withRouter() -> some View {
        modifier(RouterViewModifier())
    }
}

enum Route: Hashable {
    case signUp
    case nameEnteringView
    case birthEnteringView
    case swiftUIView // TODO: delete
}

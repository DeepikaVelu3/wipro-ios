
import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    // MARK: - Properties
    @Published var isAuthenticated = false
    @Published var showLoginScreen = false
    @Published var errorMessage: String?

    private let authenticationService = AuthenticationService()

    // MARK: - Check Authentication
    func checkAuthentication() {
        authenticationService.authenticate { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.isAuthenticated = true
                self.showLoginScreen = false

            case .unavailable:
                self.showLoginScreen = true

            case .failed(let message):
                self.errorMessage = message
                self.showLoginScreen = false
            }
        }
    }

    // MARK: - Local Login
    func login(username: String, password: String) {

        guard !username.trimmingCharacters(
            in: .whitespacesAndNewlines
        ).isEmpty else {
            errorMessage = "Please enter your username."
            return
        }

        guard !password.isEmpty else {
            errorMessage = "Please enter your password."
            return
        }

        // Temporary demo credentials
        if username == "admin" && password == "123456" {
            isAuthenticated = true
            showLoginScreen = false
            errorMessage = nil
        } else {
            errorMessage = "Invalid username or password."
        }
    }

    // MARK: - Logout
    func logout() {
        isAuthenticated = false
        showLoginScreen = true
    }
}

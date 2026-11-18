
import SwiftUI

struct FaceIDView: View {

    // MARK: - ViewModel

    @ObservedObject var authViewModel: AuthViewModel

    // MARK: - Body

    var body: some View {

        ZStack {

            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 28) {

                Spacer()

                // Application Logo
                VStack(spacing: 12) {

                    Image(systemName: "wallet.pass.fill")
                        .font(.system(size: 45))
                        .foregroundStyle(.blue)

                    Text("SubTrack")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }

                // Face ID Icon
                Image(systemName: "faceid")
                    .font(.system(size: 90))
                    .foregroundStyle(.blue)
                    .padding(30)

                // Welcome Message
                VStack(spacing: 10) {

                    Text("Welcome Back!")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Authenticate to access your subscriptions.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                // Error Message
                if let error = authViewModel.errorMessage {

                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                }

                // Face ID Button
                Button {

                    authViewModel.checkAuthentication()

                } label: {

                    Label(
                        "Authenticate with Face ID",
                        systemImage: "faceid"
                    )
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }

                Spacer()

                Text("Your subscriptions, all in one place.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(25)
        }
    }
}

#Preview {
    FaceIDView(
        authViewModel: AuthViewModel()
    )
}

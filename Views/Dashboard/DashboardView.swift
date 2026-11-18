
import SwiftUI

struct DashboardView: View {

    @ObservedObject var subscriptionViewModel: SubscriptionViewModel

    @State private var showingSubscriptions = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // Welcome
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Welcome to SubTrack!")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Manage all your subscriptions in one place.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    // Monthly Spending
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Monthly Spending")
                            .font(.headline)
                            .foregroundStyle(.secondary)

                        Text(
                            subscriptionViewModel.monthlySpending,
                            format: .currency(code: "INR")
                        )
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.blue.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Subscription Counts
                    HStack(spacing: 15) {
                        countCard(
                            title: "Total",
                            count: subscriptionViewModel.totalSubscriptions,
                            icon: "list.bullet"
                        )

                        countCard(
                            title: "Active",
                            count: subscriptionViewModel.activeSubscriptionsCount,
                            icon: "checkmark.circle"
                        )
                    }

                    // Spending Breakdown
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Spending by Category")
                            .font(.headline)

                        ForEach(SubscriptionCategory.allCases) { category in

                            let amount =
                                subscriptionViewModel.spending(for: category)

                            if amount > 0 {
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(category.rawValue)
                                            .font(.subheadline)

                                        Spacer()

                                        Text(
                                            amount,
                                            format: .currency(code: "INR")
                                        )
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                    }

                                    ProgressView(
                                        value: subscriptionViewModel.monthlySpending > 0
                                            ? amount / subscriptionViewModel.monthlySpending
                                            : 0
                                    )
                                    .tint(.blue)
                                }
                            }
                        }

                        if subscriptionViewModel.monthlySpending == 0 {
                            Text("Add active subscriptions to see your spending breakdown.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // View Subscriptions
                    Button {
                        showingSubscriptions = true
                    } label: {
                        Label(
                            "View My Subscriptions",
                            systemImage: "creditcard"
                        )
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .sheet(isPresented: $showingSubscriptions) {
                SubscriptionListView(
                    subscriptionViewModel: subscriptionViewModel
                )
            }
        }
    }

    // MARK: - Count Card
    private func countCard(
        title: String,
        count: Int,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.blue)

            Text("\(count)")
                .font(.title)
                .fontWeight(.bold)

            Text(title)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    DashboardView(
        subscriptionViewModel: SubscriptionViewModel()
    )
}

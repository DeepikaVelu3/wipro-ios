
import SwiftUI

struct SubscriptionListView: View {

    @ObservedObject var subscriptionViewModel: SubscriptionViewModel

    @State private var showingAddSubscription = false

    var body: some View {

        NavigationStack {

            VStack(spacing: 15) {

                // MARK: - Search Bar

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)

                    TextField(
                        "Search subscriptions",
                        text: $subscriptionViewModel.searchText
                    )
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                // MARK: - Category Filter

                ScrollView(.horizontal, showsIndicators: false) {

                    HStack(spacing: 10) {

                        categoryButton(title: "All", category: nil)

                        ForEach(SubscriptionCategory.allCases) { category in
                            categoryButton(
                                title: category.rawValue,
                                category: category
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                // MARK: - Status Filter

                ScrollView(.horizontal, showsIndicators: false) {

                    HStack(spacing: 10) {

                        statusButton(
                            title: "All Statuses",
                            status: nil
                        )

                        ForEach(SubscriptionStatus.allCases) { status in
                            statusButton(
                                title: status.rawValue,
                                status: status
                            )
                        }
                    }
                    .padding(.horizontal)
                }

                // MARK: - Subscription List

                if subscriptionViewModel.filteredSubscriptions.isEmpty {

                    Spacer()

                    Image(systemName: "creditcard")
                        .font(.system(size: 50))
                        .foregroundStyle(.secondary)

                    Text("No subscriptions found")
                        .font(.headline)

                    Text("Try changing your search or filters.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Spacer()

                } else {

                    List {

                        ForEach(
                            subscriptionViewModel.filteredSubscriptions
                        ) { subscription in

                            NavigationLink {

                                EditSubscriptionView(
                                    subscription: subscription,
                                    subscriptionViewModel: subscriptionViewModel
                                )

                            } label: {

                                subscriptionRow(subscription)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete { indexSet in

                            let items =
                                subscriptionViewModel.filteredSubscriptions

                            for index in indexSet {

                                let subscription = items[index]

                                subscriptionViewModel.deleteSubscription(
                                    id: subscription.id
                                )
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("My Subscriptions")

            // MARK: - Add Subscription Button

            .toolbar {

                ToolbarItem(placement: .topBarTrailing) {

                    Button {
                        showingAddSubscription = true
                    } label: {

                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                }
            }

            // MARK: - Add Subscription Sheet

            .sheet(isPresented: $showingAddSubscription) {

                AddSubscriptionView(
                    subscriptionViewModel: subscriptionViewModel
                )
            }
        }
    }

    // MARK: - Category Filter Button

    private func categoryButton(
        title: String,
        category: SubscriptionCategory?
    ) -> some View {

        let isSelected =
            subscriptionViewModel.selectedCategory == category

        return Button {

            subscriptionViewModel.selectedCategory = category

        } label: {

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 15)
                .padding(.vertical, 9)
                .background(
                    isSelected
                    ? Color.blue
                    : Color(.secondarySystemBackground)
                )
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }

    // MARK: - Status Filter Button

    private func statusButton(
        title: String,
        status: SubscriptionStatus?
    ) -> some View {

        let isSelected =
            subscriptionViewModel.selectedStatus == status

        return Button {

            subscriptionViewModel.selectedStatus = status

        } label: {

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 15)
                .padding(.vertical, 9)
                .background(
                    isSelected
                    ? Color.blue
                    : Color(.secondarySystemBackground)
                )
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }

    // MARK: - Subscription Row

    private func subscriptionRow(
        _ subscription: Subscription
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: "creditcard.fill")
                .font(.title2)
                .foregroundStyle(.blue)
                .frame(width: 45, height: 45)
                .background(Color.blue.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 5) {

                Text(subscription.serviceName)
                    .font(.headline)

                Text(subscription.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(subscription.status.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(
                        subscription.status == .active
                        ? .green
                        : .secondary
                    )
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 5) {

                Text(
                    subscription.cost,
                    format: .currency(code: "INR")
                )
                .font(.headline)

                Text(subscription.billingCycle.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    SubscriptionListView(
        subscriptionViewModel: SubscriptionViewModel()
    )
}


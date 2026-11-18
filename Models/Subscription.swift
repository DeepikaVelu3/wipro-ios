
import Foundation

struct Subscription: Identifiable, Codable {

    var id: UUID = UUID()
    var serviceName: String
    var category: SubscriptionCategory
    var cost: Double
    var billingCycle: BillingCycle
    var startDate: Date
    var notes: String
    var status: SubscriptionStatus

    var monthlyCost: Double {
        guard status == .active else {
            return 0
        }

        return cost / billingCycle.months
    }

    // Only encode stored properties
    enum CodingKeys: String, CodingKey {
        case id
        case serviceName
        case category
        case cost
        case billingCycle
        case startDate
        case notes
        case status
    }
}

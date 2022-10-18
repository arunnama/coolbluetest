
import Foundation

struct SearchResponse: Codable {
    let products: [Product]?
    let currentPage, pageSize, totalResults, pageCount: Int?
}

struct Product: Codable {
    let productID: Int?
    let productName: String?
    let reviewInformation: ReviewInformation?
    let usps: [String]?
    let availabilityState: Int?
    let salesPriceIncVat: Double?
    let productImage: String?
    let coolbluesChoiceInformationTitle: String?
    let promoIcon: PromoIcon?
    let nextDayDelivery: Bool?
    let listPriceIncVat: Int?
    let listPriceExVat: Double?

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case productName, reviewInformation
        case usps = "USPs"
        case availabilityState, salesPriceIncVat, productImage, coolbluesChoiceInformationTitle, promoIcon, nextDayDelivery, listPriceIncVat, listPriceExVat
    }
}

// MARK: - PromoIcon
struct PromoIcon: Codable {
    let text: String?
    let type: TypeEnum?
}

enum TypeEnum: String, Codable {
    case actionPrice = "action-price"
    case coolbluesChoice = "coolblues-choice"
}

struct ReviewInformation: Codable {
    //let reviews: []?
    let reviewSummary: ReviewSummary?
}

struct ReviewSummary: Codable {
    let reviewAverage: Double?
    let reviewCount: Int?
}


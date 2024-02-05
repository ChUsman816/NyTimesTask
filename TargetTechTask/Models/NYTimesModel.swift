
import UIKit

struct NYTimesModel : Codable {
	let status : String?
	let copyright : String?
	let num_results : Int?
	let results : [Results]?

	enum CodingKeys: String, CodingKey {

		case status = "status"
		case copyright = "copyright"
		case num_results = "num_results"
		case results = "results"
	}
}

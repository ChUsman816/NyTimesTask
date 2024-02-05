
import UIKit

struct Media : Codable {
	let type : String?
	let subtype : String?
	let caption : String?
	let copyright : String?
	let approved_for_syndication : Int?
	let mediametadata : [MediaMetadata]?

	enum CodingKeys: String, CodingKey {

		case type = "type"
		case subtype = "subtype"
		case caption = "caption"
		case copyright = "copyright"
		case approved_for_syndication = "approved_for_syndication"
		case mediametadata = "media-metadata"
	}

}

import Foundation

struct Constants {
    struct URLs {
        static let token = "https://api.intra.42.fr/oauth/token"
        static let user = "https://api.intra.42.fr/v2/users/"
        static let locationsDomen = "https://api.intra.42.fr/v2/users/"
        static let locationsParameters = "/locations?sort=-end_at"
    }

    struct SectionNames {
        static let skills = "Skills"
        static let projects = "Projects"
    }

    struct NibNames {
        static let project = "ProjectCell"
        static let profile = "ProfileCell"
        static let skill = "SkillCell"
        static let section = "SectionCell"
    }

    struct Token {
        static let client_id: String = "dbca5241fdb6c9a667455675619a0d57fa51c7ba40b6830809583391331c8531"
        static let client_secret: String = "dfe4854420649742f35b472bd112a83b1b794b9ebf1611fec4f202825127bd49"
        static var token: String = ""
    }
}

import Foundation

struct Constants {
    struct Titles {
        static let error = "Oooops. Error."
        static let friends = "Friends"
    }

    struct Labels {
        static let corrections = "Corrections: "
        static let defaultUsersPlace = "Sillicon Valley"
        static let level = "Level: "
        static let levelCustom = " - level: "
        static let lastOnline = "Last Online: "
        static let noFriends = "You don't have friends yet. Search for a friend and add him to the friends. :)"
        static let ok = "OK"
        static let rushes = "Rushes"
        static let titleEndsWith = "'s profile"
        static let wallet = "Wallet: "
    }

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
        static let friend = "FriendCell"
    }

    struct StoryboardID {
        static let user = "UserVCID"
        static let loading = "LoadingVCID"
        static let friends = "FriendsVCID"
    }

    struct CellIdentifier {
        static let profile = "profileCell"
        static let project = "projectCell"
        static let skill = "skillCell"
        static let section = "sectionCell"
        static let friend = "friendCell"
    }

    struct Token {
        static let clientID: String = "dbca5241fdb6c9a667455675619a0d57fa51c7ba40b6830809583391331c8531"
        static let clientSecret: String = "dfe4854420649742f35b472bd112a83b1b794b9ebf1611fec4f202825127bd49"
        static var token: String = ""
    }
}

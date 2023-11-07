//
//  ConfigToggles.swift
//  SampleFirebaseRemoteConfigApp
//
//  Created by Mehmet Emin Deniz on 10.10.2023.
//

import Foundation

struct Toggles {
    func getAllToogles() -> [String:NSObject] {

        let boolToggles:[String:NSObject] = BooleanConfigToggle.allCases
            .reduce(into: [String:NSObject]()) { dict, enumCase in
            dict[enumCase.rawValue] = enumCase.getDefaultValue()
        }

        let stringToggles: [String:NSObject] = StringConfigToggle.allCases
            .reduce(into: [String:NSObject]()) { dict, enumCase in
            dict[enumCase.rawValue] = enumCase.getDefaultValue()
        }

       return boolToggles.merging(stringToggles) { (current, _) in current }
    }


}

protocol ConfigToggleProtocol {
    func getDefaultValue() -> NSObject
}

enum BooleanConfigToggle : String, CaseIterable, ConfigToggleProtocol{

    case newFinanceEnabled = "newFinanceEnabled"
    case newSearchMaskEnabled = "newSearchMaskEnabled"
    case leasingEnabled = "leasingEnabled"
    case afterLeadEnabled = "afterLeadEnabled"
    case homeSmyleEnabled = "homeSmyleEnabled"


    func getDefaultValue() -> NSObject {
        return self.getDefaultBoolValue() as NSObject
    }

    func getDefaultBoolValue() -> Bool{
        switch self {
        case .newFinanceEnabled,
                .newSearchMaskEnabled,
                .leasingEnabled:
            return false
        case .afterLeadEnabled:
            return StringConfigToggle.afterLeadVersion.getBooleanValue()
        case .homeSmyleEnabled:
            return StringConfigToggle.homeSmyleBannerVersion.getBooleanValue()
        }
    }

}

enum StringConfigToggle: String, CaseIterable, ConfigToggleProtocol {
    case afterLeadVersion = "afterLeadVersion"
    case homeSmyleBannerVersion = "homeSmyleBannerVersion"

    func getDefaultValue() -> NSObject {
        return self.getDefaultStringValue() as NSObject
    }

    func getDefaultStringValue() -> String{
        switch self {
        case .afterLeadVersion:
            return "v0"
        case .homeSmyleBannerVersion:
            return "v0"
        }
    }

    func getBooleanValue() -> Bool {
        switch self {
        case .afterLeadVersion, .homeSmyleBannerVersion:
            return self.getDefaultStringValue() != "v0"
        }
    }
}

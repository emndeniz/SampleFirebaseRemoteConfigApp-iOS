//
//  Countries.swift
//  SampleFirebaseRemoteConfigApp
//
//  Created by Mehmet Emin Deniz on 30.10.2023.
//

import Foundation

// MARK: Do we really need country? 
enum Countries: String {
    case germany
    case netherlands
    case italy
    case spain
    case belgium
    case others

    init(countryCode: String) {
        switch countryCode.uppercased() {
        case "DE":
            self = .germany
        case "NL":
            self = .netherlands
        case "IT":
            self = .italy
        case "ES":
            self = .spain
        case "BE":
            self = .italy
        default:
            self = .others
        }
    }

    var countryName: String {
        switch self {
        case .germany:
            return "Germany"
        case .netherlands:
            return "Netherlands"
        case .italy:
            return "Italy"
        case .spain:
            return "Spain"
        case .belgium:
            return "Belgium"
        case .others:
            return "Others"
        }
    }

}

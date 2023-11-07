//
//  RemoteConfigManager.swift
//  SampleFirebaseRemoteConfigApp
//
//  Created by Mehmet Emin Deniz on 10.10.2023.
//

import Foundation
import FirebaseRemoteConfig
import FirebaseAnalytics

class RemoteConfigManager {

    static let shared = RemoteConfigManager()

    private let remoteConfig: RemoteConfig
    private init(){
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings

        let toggles = Toggles()
        remoteConfig.setDefaults(toggles.getAllToogles())
        //remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    }

    func fetchConfigs(completion: @escaping (ConfigUIModel?) -> Void){
        remoteConfig.fetch(withExpirationDuration: 0) { [weak self] status, error in
            if status == .success, error == nil {
                self?.remoteConfig.activate(completion: { isChanged, err in
                    guard err == nil else {
                        print("Error received: \(err?.localizedDescription)")
                        completion(nil)
                        return
                    }
                    completion(self?.convertExistingConfigsToModel())
                })
            }else {
                print("Error, \(error?.localizedDescription)")
                completion(nil)
            }
        }
    }

    // Too see in the UI for POC
    func convertExistingConfigsToModel() -> ConfigUIModel {

        let newSearchMaskEnabled = remoteConfig.configValue(forKey: BooleanConfigToggle.newSearchMaskEnabled.rawValue).boolValue
        let leasingEnabled = remoteConfig.configValue(forKey: BooleanConfigToggle.leasingEnabled.rawValue).boolValue
        let afterLeadEnabled = remoteConfig.configValue(forKey: BooleanConfigToggle.afterLeadEnabled.rawValue).boolValue

        let afterLeadVersion:String = remoteConfig.configValue(forKey: StringConfigToggle.afterLeadVersion.rawValue).stringValue ?? ""
        let smyleVersion:String = remoteConfig.configValue(forKey: StringConfigToggle.homeSmyleBannerVersion.rawValue).stringValue ?? ""

        let newRawJson = convertFirebaseJsonToDictionary(firebaseJson: remoteConfig.configValue(forKey: BooleanConfigToggle.newFinanceEnabled.rawValue).jsonValue as Any)

        let newFinanceEnabled = toggleStatusForCurrentCountry(toggle: newRawJson)

        return ConfigUIModel(newFinanceEnabled: newFinanceEnabled,
                             newSearchMaskEnabled: newSearchMaskEnabled,
                             leasingEnabled: leasingEnabled,
                             afterLeadEnabled: afterLeadEnabled,
                             afterLeadVersion: afterLeadVersion,
                             smyleVersion: smyleVersion)
    }
}

extension RemoteConfigManager {

    private func convertFirebaseJsonToDictionary(firebaseJson:Any) -> Dictionary<String, Any>?{
        guard let nsDictionary = firebaseJson as? NSDictionary,
              let dictionary = nsDictionary as? [String: Any] else {
            return nil
        }
        return dictionary
    }

    private func toggleStatusForCurrentCountry(toggle: Dictionary<String, Any>?) -> Bool{
        guard let toggle = toggle,
              let countries:[String] = toggle["countries"] as? [String],
              let currentLocale = Locale.current.region?.identifier else { return false }
        return countries.contains(currentLocale)
    }
}


//
//  ContentView.swift
//  SampleFirebaseRemoteConfigApp
//
//  Created by Mehmet Emin Deniz on 10.10.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {

        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 24, content: {
            Text(LocalizedStringKey("language"))
            Text("Country: \(Locale.current.identifier)")
            Text("App Version: \(Bundle.main.releaseVersionNumberPretty)")
            Divider()
            Text("New finance enabled: \(viewModel.model.newFinanceEnabled)")
            Text("New search mask enabled: \(viewModel.model.newSearchMaskEnabled)")
            Text("Leasing enabled: \(viewModel.model.leasingEnabled)")
            Text("After lead enabled: \(viewModel.model.afterLeadEnabled)")
            Text("After lead version: \(viewModel.model.afterLeadVersion)")
            Text(viewModel.getSmyle())
        })
        .padding()
        .onAppear{
            viewModel.getConfigs()
        }
    }
}


class ViewModel: ObservableObject {
    @Published var model =  ConfigUIModel()

    fileprivate func getConfigs() {
        // First get cached value
        model = RemoteConfigManager.shared.convertExistingConfigsToModel()

        RemoteConfigManager.shared.fetchConfigs { configModel in
            if let configModel = configModel {
                DispatchQueue.main.async{
                    self.model = configModel
                }
            }
        }
    }

    fileprivate func getSmyle() -> String {
        switch model.smyleVersion {
        case "v1": return "Smyle v1 🙂"
        case "v2": return "Smyle v2 😀"
        case "v3": return "Smyle v3 🤣"
        default: return "No Smyle 🙁"
        }
    }

}


struct ConfigUIModel {
    var newFinanceEnabled: String = ""
    var newSearchMaskEnabled: String = ""
    var leasingEnabled: String = ""
    var afterLeadEnabled: String = ""
    var afterLeadVersion: String = ""
    var smyleVersion: String = ""

    fileprivate init() {}

    init(newFinanceEnabled: Bool,
         newSearchMaskEnabled: Bool,
         leasingEnabled: Bool,
         afterLeadEnabled: Bool,
         afterLeadVersion: String,
         smyleVersion: String) {
        self.newFinanceEnabled = getPrettyBool(boolVal: newFinanceEnabled)
        self.newSearchMaskEnabled =  getPrettyBool(boolVal: newSearchMaskEnabled)
        self.leasingEnabled =  getPrettyBool(boolVal: leasingEnabled)
        self.afterLeadEnabled =  getPrettyBool(boolVal: afterLeadEnabled)
        self.afterLeadVersion = afterLeadVersion
        self.smyleVersion = smyleVersion
    }

    private func getPrettyBool(boolVal: Bool) -> String {
        return boolVal ? "True ✅" : "False ❌"
    }
}


#Preview {
    ContentView(viewModel: ViewModel())
}

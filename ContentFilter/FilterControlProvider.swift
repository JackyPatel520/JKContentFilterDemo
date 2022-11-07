//
//  FilterControlProvider.swift
//  ContentFilter
//
//  Created by M1 Mac mini 4 on 03/11/22.
//

import NetworkExtension

class FilterControlProvider: NEFilterControlProvider {

    public static let defaults = UserDefaults(suiteName: "7J3EXH6427.group.com.demo.ContentFilterDemoApp")
    override init() {
        super.init()
        FilterUtilities.fetchRulesFromServer(self.filterConfiguration.serverAddress)
    }

    override func handleNewFlow(_ flow: NEFilterFlow, completionHandler: @escaping (NEFilterControlVerdict) -> Void) {
        var controlVerdict = NEFilterControlVerdict.updateRules()
        
        if  FilterUtilities.shouldAllowAccess(flow) == true {
            controlVerdict = NEFilterControlVerdict.allow(withUpdateRules: false)
        }else{
            controlVerdict = NEFilterControlVerdict.drop(withUpdateRules: false)
        }
        completionHandler(controlVerdict)
    }

    //MARK: - DEFault methods
    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        // Add code to initialize the filter
        completionHandler(nil)
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code to clean up filter resources
        completionHandler()
    }
    
//    override func handleNewFlow(_ flow: NEFilterFlow, completionHandler: @escaping (NEFilterControlVerdict) -> Void) {
//
//        // Add code to determine if the flow should be dropped or not, downloading new rules if required
//        completionHandler(.allow(withUpdateRules: false))
//    }
}

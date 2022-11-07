//
//  FilterDataProvider.swift
//  ContentFilterData
//
//  Created by M1 Mac mini 4 on 03/11/22.
//

import NetworkExtension

class FilterDataProvider: NEFilterDataProvider {
    
    // MARK: NEFilterDataProvider
    
    /// Handle a new flow of data.
    override func handleNewFlow(_ flow: NEFilterFlow) -> NEFilterNewFlowVerdict {
        let result = NEFilterNewFlowVerdict.needRules()
        return result
    }
    
    /// Filter an inbound chunk of data.
    override func handleInboundData(from flow: NEFilterFlow, readBytesStartOffset offset: Int, readBytes: Data) -> NEFilterDataVerdict {
        var result = NEFilterDataVerdict.allow()
        result = NEFilterDataVerdict.needRules()
        return result
    }
    
    /// Handle the event where all of the inbound data for a flow has been filtered.
    override func handleInboundDataComplete(for flow: NEFilterFlow) -> NEFilterDataVerdict {
        var result = NEFilterDataVerdict.allow()
        result = NEFilterDataVerdict.needRules()
        //result = NEFilterDataVerdict.drop()
        return result
    }
    
    /// Filter an outbound chunk of data.
    override func handleOutboundData(from flow: NEFilterFlow, readBytesStartOffset offset: Int, readBytes: Data) -> NEFilterDataVerdict {
        
        var result = NEFilterDataVerdict.allow()
        result = NEFilterDataVerdict.needRules()
        //result = NEFilterDataVerdict.drop()
        return result
    }
    
    /// Handle the event where all of the outbound data for a flow has been filtered.
    override func handleOutboundDataComplete(for flow: NEFilterFlow) -> NEFilterDataVerdict {
        var result = NEFilterDataVerdict.allow()
        result = NEFilterDataVerdict.needRules()
        //result = NEFilterDataVerdict.drop()
        return result
    }
    
    /// Handle the user tapping on the "Request Access" link in the block page.
    override func handleRemediation(for flow: NEFilterFlow) -> NEFilterRemediationVerdict {
        Log.logger.write("handleRemediationForFlow called: Allow verdict")
        return NEFilterRemediationVerdict.allow()
    }


    //MARK: - DEFAULT METHODS
    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        // Add code to initialize the filter.
        completionHandler(nil)
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code to clean up filter resources.
        completionHandler()
    }
    
//    override func handleNewFlow(_ flow: NEFilterFlow) -> NEFilterNewFlowVerdict {
//        // Add code to determine if the flow should be dropped or not, downloading new rules if required.
//        return .allow()
//    }
}

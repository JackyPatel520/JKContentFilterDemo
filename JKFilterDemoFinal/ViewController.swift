//
//  ViewController.swift
//  JKFilterDemoFinal
//
//  Created by M1 Mac mini 4 on 03/11/22.
//

import UIKit
import NetworkExtension

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FilterUtilities.defaults?.setValue(false, forKey: "rules")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if NEFilterManager.shared().providerConfiguration == nil {
                let newConfiguration = NEFilterProviderConfiguration()
                newConfiguration.username = "JACKY"
                newConfiguration.organization = "JKFilterDemoFinal APP"
                newConfiguration.filterBrowsers = true
                newConfiguration.filterSockets = true
                newConfiguration.serverAddress = "https://619c88d968ebaa001753c8f8.mockapi.io/" //url of server from where rules will be fetched
                NEFilterManager.shared().providerConfiguration = newConfiguration
            }
            NEFilterManager.shared().isEnabled = true //self.statusCell.isOn
            NEFilterManager.shared().saveToPreferences { error in
                if let  saveError = error {
                    Log.logger.write("Failed to save the filter configuration: \(saveError)")
                }
            }
        }
        
      //  FilterUtilities.getList()
    }
    
    
    /// Handle the event where the view is loaded into memory.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NEFilterManager.shared().loadFromPreferences { error in
            if let loadError = error {
                Log.logger.write("Failed to load the filter configuration: \(loadError)")
                return
            }
        }
    }
    
    @IBAction func refreshRulesButtonPressed(_ sender: Any) {
        FilterUtilities.getList()

        DispatchQueue.global(qos: .userInitiated).async {
            FilterUtilities.fetchRulesFromServer(NEFilterManager.shared().providerConfiguration?.serverAddress)
        }
    }
    
}


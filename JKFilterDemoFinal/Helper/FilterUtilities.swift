
import Foundation
import NetworkExtension
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import SwiftyJSON

 var arrSites : [temproryModel] {
    get {
            let encodedeObject: NSData = FilterUtilities.defaults?.object(forKey: "Sites_to_block") as? NSData ?? NSData()
            let kUSerObject: [temproryModel] = NSKeyedUnarchiver.unarchiveObject(with: encodedeObject as Data) as? [temproryModel] ?? []
            return kUSerObject

//        do {
//
//            let encodedeObject: NSData = FilterUtilities.defaults?.object(forKey: "Sites_to_block") as? NSData ?? NSData()
//
//            let archived = try NSKeyedArchiver.archivedData(withRootObject: encodedeObject, requiringSecureCoding: false)
//
//            let records = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self, temproryModel.self], from: archived) as! [temproryModel]
//            print(records)
//            return records
//
//        } catch {
//            print(error)
//        }
        return []
    }
    set {
            let encodedObject = try NSKeyedArchiver.archivedData(withRootObject: newValue)
            FilterUtilities.defaults?.setValue(encodedObject, forKey: "Sites_to_block")
            FilterUtilities.defaults?.synchronize()

//        do {
//            let encodedObject = try NSKeyedArchiver.archivedData(withRootObject: newValue, requiringSecureCoding: false)
//            FilterUtilities.defaults?.setValue(encodedObject, forKey: "Sites_to_block")
//            FilterUtilities.defaults?.synchronize()
//        }
//        catch {
//            print("FAIL TO SAVE", error)
//        }
    }
}

open class FilterUtilities {
    
    // MARK: Properties
    public static let defaults = UserDefaults(suiteName: "7J3EXH6427.group.com.zb.dev.JKFilterDemoFinal")
    open class func shouldAllowAccess(_ flow: NEFilterFlow) -> Bool {
        //access to your app and certains url should be allowd handling
        if #available(iOS 11.0, *) {

            DispatchQueue.global(qos: .background).async {
                self.getList()
            }
           // getList()
            logw("arrSITES.. \(arrSites.count)")

            logw("flow. : \(flow)")
            let sourceDATA = try? JSONSerialization.jsonObject(with: flow.sourceAppUniqueIdentifier ?? Data(), options: []) as? [String: Any]
            logw("flow.sourceAppUniqueIdentifier : \(sourceDATA ?? [:]), flow.sourceAppIdentifier : \(flow.sourceAppIdentifier ?? ""), flow.sourceAppVersion : \(flow.sourceAppVersion ?? "") ")

            logw("flow.url : \(flow.url)")
            logw("FilterUtilities.getFlowHostname flow. : \(FilterUtilities.getFlowHostname(flow))")

            for (i, valS) in arrSites.enumerated() {
                
                if (flow.url?.absoluteString ?? "").localizedCaseInsensitiveContains(valS.webName) {
                    let startDt = valS.startTime.getUTCtoLocalDate()
                    let endDt = valS.endTime.getUTCtoLocalDate()
                    
                    logw("flow.startDt : \(startDt), flow.endDt \(endDt) , CURRENT DAte : \(Date())")

                    if (Date() > startDt) && (Date() < endDt) {
                        return false
                    }
                    
                }else{
                    
                }
            }
                
            if (flow.url?.absoluteString ?? "").localizedCaseInsensitiveContains("hexeros") {
                return false
            }else {
                logw("flow.url?.absoluteString : \(flow.url?.absoluteString ?? "")")
            }
            
            logw("Current App BundleID \(Bundle.main.bundleIdentifier ?? "")")

            if let bundleId = flow.sourceAppIdentifier {
                logw("sourceAppIdentifier \(bundleId)")
                if (bundleId == "7J3EXH6427.com.demo.ZBContentFilterDemoApp") || (bundleId.localizedCaseInsensitiveContains("com.zb.dev.JKFilterDemoFinal")) || (bundleId.localizedCaseInsensitiveContains("com.apple.mobilesafari")){
                    //|| (bundleId == "XCFF99Z77H.com.app.ChilisQARestaurant")
                    return true
                }
            }

        } else {
            Log.logger.write("flow.url?.absoluteString : \(flow.url?.absoluteString ?? "")")

            // Fallback on earlier versions
            let hostname = FilterUtilities.getFlowHostname(flow)
            logw("host name is \(hostname)")
            if hostname.isEmpty {
                return true
            }
            if hostname == "192.168.100.48" {
                return true //our own server url
            }
        }
        return defaults?.bool(forKey: "rules") ?? true
    }
    
    
    /// Get the hostname from a browser flow.
    open class func getFlowHostname(_ flow: NEFilterFlow) -> String {
        guard let browserFlow : NEFilterBrowserFlow = flow as? NEFilterBrowserFlow,
            let url = browserFlow.url,
            let hostname = url.host
            , flow is NEFilterBrowserFlow
            else {
            Log().write("flow.description\(flow.description)")
            return "" }
        return hostname
    }
    
    
    open class func fetchRulesFromServer(_ serverAddress: String?) {
        guard serverAddress != nil else { return }
        guard let infoURL = URL(string: "\(serverAddress!)SiteList") else { return }
        let content: String
        do {
            content = try String(contentsOf: infoURL, encoding: String.Encoding.utf8)
        }
        catch(let err) {
            print("ERROR IN fetchRulesFromServer",err.localizedDescription)
            return
        }
        let utf8ShouldAllowAccess = String(utf8String: "ALLOW".cString(using: .utf8)!)
        if content ==  utf8ShouldAllowAccess{
            defaults?.setValue(true, forKey:"rules")
        }else{
            defaults?.setValue(false, forKey:"rules")
        }
    }
    
    open class func getList() {
        var semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://619c88d968ebaa001753c8f8.mockapi.io/SiteList")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            
            do {
                let json = try JSON(data: data)
                arrSites = json.arrayValue.map({temproryModel(fromJson: $0)})
                print(json)
            }
            catch (let err ){
                print(err.localizedDescription)
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
}

extension String {

  //MARK:- Convert UTC To Local Date by passing date formats value
  func UTCToLocal(incomingFormat: String, outGoingFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = incomingFormat
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

    let dt = dateFormatter.date(from: self)
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.dateFormat = outGoingFormat

    return dateFormatter.string(from: dt ?? Date())
  }

  //MARK:- Convert Local To UTC Date by passing date formats value
  func localToUTC(incomingFormat: String, outGoingFormat: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = incomingFormat
    dateFormatter.calendar = NSCalendar.current
    dateFormatter.timeZone = TimeZone.current

    let dt = dateFormatter.date(from: self)
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
    dateFormatter.dateFormat = outGoingFormat

    return dateFormatter.string(from: dt ?? Date())
  }
    
    func getUTCtoLocalDate(incomingFormat : String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = incomingFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: self)
        return dt ?? Date()
    }
}

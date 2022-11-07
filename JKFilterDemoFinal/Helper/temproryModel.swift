//
//	temproryModel.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class temproryModel : NSObject, NSCoding{
    
    var webName : String!
    var avatar : String!
    var bundleId : String!
    var createdAt : String!
    var endTime : String!
    var id : String!
    var name : String!
    var startTime : String!


    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        webName = json["Web_name"].stringValue
        avatar = json["avatar"].stringValue
        bundleId = json["bundle_id"].stringValue
        createdAt = json["createdAt"].stringValue
        endTime = json["end_time"].stringValue
        id = json["id"].stringValue
        name = json["name"].stringValue
        startTime = json["start_time"].stringValue
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if webName != nil{
            dictionary["Web_name"] = webName
        }
        if avatar != nil{
            dictionary["avatar"] = avatar
        }
        if bundleId != nil{
            dictionary["bundle_id"] = bundleId
        }
        if createdAt != nil{
            dictionary["createdAt"] = createdAt
        }
        if endTime != nil{
            dictionary["end_time"] = endTime
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        if startTime != nil{
            dictionary["start_time"] = startTime
        }
        return dictionary
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         webName = aDecoder.decodeObject(forKey: "Web_name") as? String
         avatar = aDecoder.decodeObject(forKey: "avatar") as? String
         bundleId = aDecoder.decodeObject(forKey: "bundle_id") as? String
         createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
         endTime = aDecoder.decodeObject(forKey: "end_time") as? String
         id = aDecoder.decodeObject(forKey: "id") as? String
         name = aDecoder.decodeObject(forKey: "name") as? String
         startTime = aDecoder.decodeObject(forKey: "start_time") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
    {
        if webName != nil{
            aCoder.encode(webName, forKey: "Web_name")
        }
        if avatar != nil{
            aCoder.encode(avatar, forKey: "avatar")
        }
        if bundleId != nil{
            aCoder.encode(bundleId, forKey: "bundle_id")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if endTime != nil{
            aCoder.encode(endTime, forKey: "end_time")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if startTime != nil{
            aCoder.encode(startTime, forKey: "start_time")
        }

    }

}

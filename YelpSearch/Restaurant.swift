//
//  Restaurant.swift
//  YelpSearch
//
//  Created by Kumar, Chandaraprakash on 9/25/14.
//  Copyright (c) 2014 chantech. All rights reserved.
//

import UIKit


class Restaurant: NSObject {
    var name: String!
    var thumbImage: String!
    var ratingImage: String!
    var reviewsCount: Int!
    var categories: String! = ""
    var categoryItem: String! = ""
    var address: String! = ""
    var addressItem: String! = ""
    var RestaurantViewController: YelpViewController!
    
    init(restaurantDictionary: NSDictionary) {
        var jsonObj = JSON(object: restaurantDictionary)
        name = jsonObj["name"].stringValue
        thumbImage = jsonObj["image_url"].stringValue
        ratingImage = jsonObj["rating_img_url"].stringValue
        reviewsCount = jsonObj["review_count"].integerValue
        
        //parse address
        if let addressArray = jsonObj["location"]["display_address"].arrayValue {
            for item in addressArray {
                if(address != "") {
                    addressItem = ", " + item.stringValue!
                } else {
                    addressItem = item.stringValue!
                }
                address = address + addressItem
            }
        }
    
    //parse category
        if let categoryArray = jsonObj["categories"].arrayValue {
            for item in categoryArray {
                if(categories != "") {
                    categoryItem = ", " + item[0].stringValue!
                } else {
                    categoryItem = item[0].stringValue!
                }
                categories = categories + categoryItem
            }
        }
    }
    
    class func searchWithQuery(query : String, completion : (Restaurants: [Restaurant]!, error: NSError!) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(query, success: {
            (operation : AFHTTPRequestOperation! , response :AnyObject!) -> Void in
            //println(response)
            var restaurantDictionaries = (response as NSDictionary)["businesses"] as [NSDictionary]
            var restaurants = restaurantDictionaries.map { (business : NSDictionary) -> Restaurant in
                Restaurant(restaurantDictionary: business)
            }
            completion(Restaurants: restaurants, error: nil)
            }) { (operation : AFHTTPRequestOperation! , error :NSError!) -> Void in
                println(error)
        }
    }
    
}
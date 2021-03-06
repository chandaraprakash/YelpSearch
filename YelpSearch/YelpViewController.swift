//
//  YelpViewController.swift
//  YelpSearch
//
//  Created by Kumar, Chandaraprakash on 9/25/14.
//  Copyright (c) 2014 chantech. All rights reserved.
//

import UIKit

class YelpViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FilterViewControllerDelegate {

    @IBOutlet weak var restaurantTableView: UITableView!
    
    
    
    var client: YelpClient!
    var restaurants: [Restaurant]! = []
    
    var searchBar: UISearchBar!
    
    var filtersObj: Filters = Filters()
    
    var categories = ["Bakeries",
        "Beer, Wine & Spirits",
        "Beverage Store",
        "Breweries",
        "Coffee & Tea",
        "Convenience Stores",
        "Desserts",
        "Farmers Market",
        "Food Delivery Services",
        "Food Trucks",
        "Grocery",
        "Ice Cream & Frozen Yogurt",
        "Juice Bars & Smoothies",
        "Specialty Food"]
    var categoriesParamString = ["bakeries",
        "beer_and_wine",
        "beverage_stores",
        "breweries",
        "coffee",
        "convenience",
        "desserts",
        "farmersmarket",
        "fooddeliveryservices",
        "foodtrucks",
        "grocery",
        "icecream",
        "juicebars",
        "gourmet"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self
        
        prepareSearchBar()
        
        YelpClient.sharedInstance.searchWithTerm("Thai", success: {
            (operation : AFHTTPRequestOperation! , response :AnyObject!) -> Void in
            var restaurantDictionaries = (response as NSDictionary)["businesses"] as [NSDictionary]
            self.restaurants = restaurantDictionaries.map { (business : NSDictionary) -> Restaurant in
                Restaurant(restaurantDictionary: business)
            }
            self.restaurantTableView.reloadData()
            }) { (operation : AFHTTPRequestOperation! , error :NSError!) -> Void in
                println(error)
        }
        
        //self.restaurantTableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = restaurantTableView.dequeueReusableCellWithIdentifier("RestaurantCell") as RestaurantCell
        
        cell.restaurant = self.restaurants[indexPath.row]
        return cell
    }
    
    func prepareSearchBar(){
        
        searchBar = UISearchBar(frame: CGRectMake(0.0, 0.0, 200, 44.0))
        searchBar.delegate = self
        searchBar.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
        searchBar.backgroundColor = UIColor.clearColor()
        self.navigationItem.titleView = searchBar
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        
    }
    

    /*
    // MARK: - Navigation
    */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var nav = segue.destinationViewController as UINavigationController
        
        if nav.viewControllers[0] is FiltersViewController {
            var controller = nav.viewControllers[0] as FiltersViewController
            controller.delegate = self
            
            var categoriesDictionary = [self.categories[0]  : false,
                self.categories[1]  : false,
                self.categories[2]  : false,
                self.categories[3]  : false,
                self.categories[4]  : false,
                self.categories[5]  : false,
                self.categories[6]  : false,
                self.categories[7]  : false,
                self.categories[8]  : false,
                self.categories[9]  : false,
                self.categories[10] : false,
                self.categories[11] : false,
                self.categories[12] : false,
                self.categories[13] : false]
            
            //Setting the FilterObject to default
            if (self.filtersObj.isbestDeal == nil) {
                controller.filtersObj = Filters(isbestDeal: false, radius: 0, sortBy: 0, categoriesDictionary: categoriesDictionary)
                //println("new filtersObj")
                //println("a \(filtersObj.radius)")
            } else {
                controller.filtersObj = self.filtersObj
                //println("old filtersObj")
                //println("b \(filtersObj.radius)")
            }
        }
    }
    
    func searchTermDidChange(filtersObj : Filters) {
        self.filtersObj = filtersObj
        
        //Prepare seach filters
        //1.SortBy
        var sortByString = "\(filtersObj.sortBy!)"
        //2.Distance
        var distArray = [0.2, 0.5, 1.0, 5.0]
        var radiusString = "\(distArray[filtersObj.radius!]*1609.34)"
        //3.Deals
        var isDealsOnString: String
        if filtersObj.isbestDeal! {
            isDealsOnString = "true"
        } else {
            isDealsOnString = "false"
        }
        //4.0 Categories
        var categoryString = ""
        for (var i=0; i<filtersObj.categoriesDictionary?.count; i++ ) {
            if let cat = filtersObj.categoriesDictionary {
                if cat[categories[i]] == true {
                    if (categoryString != "") {
                        categoryString = categoryString + "+" + categoriesParamString[i]
                    } else {
                        categoryString = categoriesParamString[i]
                    }
                }
            }
        }
        var filterDict = Dictionary<String, String>()
        filterDict.updateValue(sortByString, forKey: "sort")
        filterDict.updateValue(radiusString, forKey: "radius_filter")
        filterDict.updateValue(isDealsOnString, forKey: "deals_filter")
        filterDict.updateValue(categoryString, forKey: "category_filter")
        //println(filterDict)
        
        //0.searchTerm
        var searchTerm = self.searchBar.text
        
        YelpClient.sharedInstance.searchWithFilters( searchTerm, filter: filterDict, success: {
            (operation : AFHTTPRequestOperation! , response :AnyObject!) -> Void in
            var restaurantDictionaries = (response as NSDictionary)["businesses"] as [NSDictionary]
            self.restaurants = restaurantDictionaries.map { (business : NSDictionary) -> Restaurant in
                Restaurant(restaurantDictionary: business)
            }
            self.restaurantTableView.reloadData()
            }) { (operation : AFHTTPRequestOperation! , error :NSError!) -> Void in
                println(error)
        }
    }

}

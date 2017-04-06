//
//  AppDelegate.swift
//  Spectator
//
//  Created by Michael Zeller on 7/2/16.
//  Copyright © 2016 Lights and Shapes. All rights reserved.
//

import UIKit

import Kingfisher
import SwiftyStoreKit
import COLORAdFramework

let removeAdsIAP = "com.lightsandshapes.Player2.RemoveAds"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Setup Flurry only if we are not in the simulator
        #if !(arch(i386) || arch(x86_64)) && os(tvOS)
        Flurry.startSession("QQHPHPQDJ9FG2QQ8GMYW");
        #endif
        
        // Set maximum GameCell cache duration for Kingfisher to 3 days
        P2ImageCache.GameCellCache.maxCachePeriodInSecond = TimeInterval(60 * 60 * 24 * 3)
        // Set maximum StreamCell cache duration for Kingfisher to 1hr
        P2ImageCache.StreamCellCache.maxCachePeriodInSecond = TimeInterval(60 * 60 * 1)
        
        
        //Setup SearchController
        
        //if let tabBarController =  self.window?.rootViewController as? TabBarViewController {
            //tabBarController.viewControllers?.append(searchContainterDisplay())
        //}
        
        // Setup Ads
        COLORAdController.sharedAdController().start(withAppIdentifier: "493d9694-1386-4da0-b63a-6f85f4dc4fcb")
        
        // Setup StoreKit
        setUpStoreKit()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Custom URL scheme
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if (url.path == "/game") {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            if let items = components?.queryItems {
                let game = items.filter {
                    $0.name == "name"
                }.first?.value
                
                if let game = game {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let streams = storyboard.instantiateViewController(withIdentifier: "Streams") as! StreamSectionController
                    streams.game = game
                    let mainVC = self.window?.rootViewController as? TabBarViewController
                    mainVC?.dismiss(animated: false, completion: nil)
                    mainVC?.selectedIndex = 0
                    mainVC?.present(streams, animated: true, completion: nil)
                }
            }
        }
        return true
    }

    // MARK: - SearchController
    
    func searchContainterDisplay() -> UIViewController {
        let sb = UIStoryboard(name: "Search", bundle: nil)
        let searchResults = sb.instantiateViewController(withIdentifier: "SearchResults") as! NewSearchResultsViewController
        let searchController = UISearchController(searchResultsController: searchResults)
        searchController.searchBar.delegate = searchResults
        searchController.view.backgroundColor = .white
        searchController.searchBar.placeholder = "Search for..."
        
        // Contain the searchController
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        searchContainer.title = "Search"
        
        // Embed the container in a navigation controller
        let searchNavigationController = UINavigationController(rootViewController: searchContainer)
        return searchNavigationController
    }
    
    // MARK: - SwiftyStoreKit
    func setUpStoreKit() {
        SwiftyStoreKit.completeTransactions(atomically: true) { products in
            
            for product in products {
                print(product)
                if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {
                    
                    if product.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                    print("purchased: \(product)")
                }
            }
        }
        
        // Test products
        SwiftyStoreKit.retrieveProductsInfo([removeAdsIAP]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
            } else {
                print("Invalid: ")
                print(result.invalidProductIDs)
            }
        }
    }
}



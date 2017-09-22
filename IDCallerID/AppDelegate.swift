//
//  AppDelegate.swift
//  IDCallerID
//
//  Created by Kenneth Wieschhoff on 9/19/17.
//  Copyright © 2017 Stanley Black&Decker. All rights reserved.
//

import UIKit
import ContactsUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var allContacts : [CNContact] = []


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        fetchContacts()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func fetchContacts()
    {
        let contactStore = CNContactStore()
        var allContainers : [CNContainer] = []
        
        contactStore.requestAccess(for: .contacts) { (sucess, error) in
            //you can use one of these/ all keys to filter contacts
            let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactOrganizationNameKey,   CNContactJobTitleKey, CNContactPhoneNumbersKey, CNContactIdentifierKey, CNContactFormatter. as Any]
            do{
                // _______________ Fetch all the Containers_________________________________
                allContainers = try contactStore.containers(matching: nil)
                
            }
            catch{
                print(error)
            }
            for container in allContainers{
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                do{
                    //____________Fetch all the contacts corresponding to every Container______
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    self.allContacts.append(contentsOf: containerResults)
                    NotificationCenter.default.post(name: Notification.Name("Reload"), object: nil)

                }
                catch{
                    print(error)
                }
            }
        }
    }

}


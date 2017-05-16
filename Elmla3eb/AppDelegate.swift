//
//  AppDelegate.swift
//  Elmla3eb
//
//  Created by Killvak on 26/02/2017.
//  Copyright © 2017 Killvak. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {

        let FBhandled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return  FBhandled
        
        
    }
    
    func setNavigatiobColor() {
      
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = Constants.Colors.blue
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().clipsToBounds = false
        UINavigationBar.appearance().backgroundColor = UIColor.green
        let navBackgroundImage:UIImage! = UIImage(named: "bg_main")
        UINavigationBar.appearance().setBackgroundImage(navBackgroundImage, for: .default)
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 18) , NSForegroundColorAttributeName: UIColor.white ]
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                IQKeyboardManager.sharedManager().enable = true
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        L102Localizer.DoTheMagic()
        setNavigatiobColor()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), for:UIBarMetrics.default)


        let x = self.isUserLoggedIn()
        if x {
            
        }else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            // In project directory storyboard looks like Main.storyboard,
            // you should use only part before ".storyboard" as it's name,
            // so in this example name is "Main".
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            // controller identifier sets up in storyboard utilities
            // panel (on the right), it called Storyboard ID
            let viewController = storyboard.instantiateViewController(withIdentifier: "SplashLoginVC") as! SplashLoginVC
            
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()    
        }
        
        let notificationTypes : UIUserNotificationType = [.alert, .badge, .sound]
        let notificationSettings : UIUserNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        
        return true
    }
    
    func reloadApp() {
        
        let x = self.isUserLoggedIn()
        if x {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            self.window?.rootViewController = storyboard.instantiateInitialViewController()

        }else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            // In project directory storyboard looks like Main.storyboard,
            // you should use only part before ".storyboard" as it's name,
            // so in this example name is "Main".
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            
            // controller identifier sets up in storyboard utilities
            // panel (on the right), it called Storyboard ID
            let viewController = storyboard.instantiateViewController(withIdentifier: "SplashLoginVC") as! SplashLoginVC
            
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }

         }
    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings)
    {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
 
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
    }
    
    //@End Notification 
    
    
    
    
    func userOffline(_ view : UIViewController?) {
        guard let view = view else {
            return
        }
        let offline = NoNetConnectionVC(nibName:"NoNetConnectionVC",bundle: nil)
        view.present(offline, animated: true, completion: nil)
    }
    
    func saveUserLogginData(email:String?,photoUrl : String? , uid : Int?,name:String?) {
        print("saving User Data email: \(email) , photoUrl: \(photoUrl),uid: \(uid)")
        if   let email = email   {
            UserDefaults.standard.setValue(email, forKey: "userEmail")
        }else{
            UserDefaults.standard.setValue(nil, forKey: "userEmail")
            
        }
        
        if  let photo = photoUrl {
            UserDefaults.standard.setValue(photo, forKey: "profileImage")
        }else {
            UserDefaults.standard.setValue(nil, forKey: "profileImage")
        }
        
        if  let uid = uid {
            UserDefaults.standard.setValue(uid, forKey: "userId")
        }else {
            UserDefaults.standard.setValue(nil, forKey: "userId")
        }
        
        if let name = name {
            UserDefaults.standard.setValue(name, forKey: "usreName")
        }else {
            UserDefaults.standard.setValue(nil, forKey: "userName")
        }
        
    }
    
    func isUserLoggedIn() -> Bool {
        if (UserDefaults.standard.value(forKey: "userId") != nil) {
            return true
        }else {
            return false
        }
        
    }
    
    func sideMenuTrigger(_ view : UIViewController,_ triggerPage:String ) {
        let x = MenuVC()
        x.modalTransitionStyle = .partialCurl
        x.currentPage = triggerPage
//        view.navigationController?.present(x, animated: true, completion: nil)
         view.present(x, animated: true, completion: nil)
    }
}
let ad = UIApplication.shared.delegate as! AppDelegate


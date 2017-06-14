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
import Firebase
import FirebaseMessaging
import CDAlertView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {

    var window: UIWindow?
    
    var production = false 
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

        FIRApp.configure()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let x = self.isUserLoggedIn()
        if !x { 
            self.window = UIWindow(frame: UIScreen.main.bounds)
            
            // In project directory storyboard looks like Main.storyboard,
            // you should use only part before ".storyboard" as it's name,
            // so in this example name is "Main".
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
//            
//            // controller identifier sets up in storyboard utilities
//            // panel (on the right), it called Storyboard ID
            let viewController = storyboard.instantiateViewController(withIdentifier: "SplashLoginVC") as! SplashLoginVC
 
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
            //test Nib
//           let initialViewController  = CheckPhoneValidVC(nibName:"CheckPhoneValidVC",bundle:nil)
//            
//            let frame = UIScreen.main.bounds
//            window = UIWindow(frame: frame)
//            
//            window!.rootViewController = initialViewController
//            window!.makeKeyAndVisible()
            //@end test end
        }
        
        let notificationTypes : UIUserNotificationType = [.alert, .badge, .sound]
        let notificationSettings : UIUserNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        print("that is UDID : \(UIDevice.current.identifierForVendor!.uuidString)")
 
        fcm()

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
//        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        print(token)

        fcm()
     
    }
    
    func fcm() {

        guard let userID = UserDefaults.standard.value(forKey: "userId") as? Int else {
            UserDefaults.standard.setValue(nil, forKey: "FCMToken")
            print("⚠️No userID Found  ❌ "); return }

        guard  let refreshedToken = FIRInstanceID.instanceID().token() else {
            print("⚠️No Token Returned From FCM  ❌ "); return }
        print("☢️☣️InstanceID token: 📴📳\(refreshedToken)📴📳")

            if     UserDefaults.standard.value(forKey: "FCMToken") as? String != refreshedToken {
                print("✅Updating Token ✳️found  userId: \(UserDefaults.standard.value(forKey: "userId") as? String)\n ,FCMToken \(UserDefaults.standard.value(forKey: "FCMToken") as? String)\n, refreshedToken \(refreshedToken)\n")
                
                let userFCM = MUserData()
                userFCM.userFCMToken(userID: userID, token: refreshedToken, completed: { (state,sms) in
                    
                    if state {
                        UserDefaults.standard.setValue(refreshedToken, forKey: "FCMToken")
                        print("✅Updated Token  ✅ ")

                    }
                })
            }else {
                print("❌ Won't Update Token Token Already Exist⚠️found a strange thing there mate userId: \(UserDefaults.standard.value(forKey: "userId") as? Int)\n ,♎️FCMTokenNSDefault \(UserDefaults.standard.value(forKey: "FCMToken") as? String)\n, ☢️☣️InstanceID token: 📴📳\(refreshedToken)📴📳\n")
            }
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("that's the userInfo : \(userInfo)")
        print("that's the message Id  : \(userInfo["gcm_message_id"]!)")

    }
    
    //@End Notification 
    
    
    func showAlert(_ title : String,_ sms : String) {
        guard title != "√" else {
            let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Done"), message:langDicClass().getLocalizedTitle(sms) , type: .success)
            alert.show()
            return
        }
        guard title != "default" else {
             let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Something Went Wrong"), message:langDicClass().getLocalizedTitle("try again!!") , type: .warning)
            alert.show()
            return
        }
        guard title != "defaultTitle" else {
            let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Something Went Wrong With"), message:langDicClass().getLocalizedTitle(sms) , type: .warning)
            alert.show()
            return
        }
        let alert = CDAlertView(title: title, message:sms , type: .warning)
        alert.show()
    }
    
    func userOffline(_ view : UIViewController?) {
        guard let view = view else {
            return
        }
        let offline = NoNetConnectionVC(nibName:"NoNetConnectionVC",bundle: nil)
        view.present(offline, animated: true, completion: nil)
    }
    
    func saveUserLogginData(email:String?,photoUrl : String? , uid : Int?,name:String?) {
        print("saving User Data email: \(email) , photoUrl: \(photoUrl),uid: \(uid)")
        if email != "default" {
        if   let email = email   {
            UserDefaults.standard.setValue(email, forKey: "userEmail")
        }else{
            UserDefaults.standard.setValue(nil, forKey: "userEmail")
            
        }
        }
        if photoUrl != "default" {

        if  let photo = photoUrl {
            UserDefaults.standard.setValue(photo, forKey: "profileImage")
            print("saing this photo : \(photo)")
        }else {
            UserDefaults.standard.setValue(nil, forKey: "profileImage")
        }
        }
        if uid != -1 {

        if  let uid = uid {
            UserDefaults.standard.setValue(uid, forKey: "userId")
        }else {
            UserDefaults.standard.setValue(nil, forKey: "userId")
            UserDefaults.standard.setValue(nil, forKey: "FCMToken")
        }
        }
        if name != "default" {

        if let name = name {
            UserDefaults.standard.setValue(name, forKey: "usreName")
        }else {
            UserDefaults.standard.setValue(nil, forKey: "userName")
        }
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
    
    func loadingActivity(_ view : UIViewController) -> UIActivityIndicatorView{
        
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        myActivityIndicator.color = .green
        myActivityIndicator.center = view.view.center
        myActivityIndicator.hidesWhenStopped = true
        myActivityIndicator.alpha = 0
        myActivityIndicator.layer.masksToBounds = false
        myActivityIndicator.layer.cornerRadius = 3.0
        myActivityIndicator.layer.shadowOpacity = 0.8
        myActivityIndicator.layer.shadowRadius = 3.0
        myActivityIndicator.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        myActivityIndicator.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
        view.view.addSubview(myActivityIndicator)
        return myActivityIndicator

    }
}
let ad = UIApplication.shared.delegate as! AppDelegate


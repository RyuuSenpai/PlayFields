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
import FirebaseInstanceID
import FirebaseMessaging
import CDAlertView
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,
UNUserNotificationCenterDelegate, FIRMessagingDelegate  {
    
    var window: UIWindow?
    
    var production = true 
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
        
        //        FIRApp.configure()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
         setupFCM()
        
        if UserDefaults.standard.value(forKey: "FCMToken") as? String == nil || UserDefaults.standard.value(forKey: "userId") as? Int == nil {
            saveUserLogginData(email: nil, photoUrl: nil, uid: nil, name: nil)
        }
//         print("that is UDID : \(UIDevice.current.identifierForVendor!.uuidString)")
         return true
    }
    
    func reload() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateViewController(withIdentifier: "rootNav")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //        print(response)
        //            print("Handle push from background or closed\(response.notification.request.content.userInfo)")
        //write your action here
    }
    
     // This method will be called when app received push notifications in foreground
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
    
    
    
    func setupFCM() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            FIRMessaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)            }
        
        UIApplication.shared.registerForRemoteNotifications()
        FIRApp.configure()
        
        fcm()
    }
    //@NOtification
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
//        print(remoteMessage.appData)
    }
    //@ENd
    //    func fcm() { }
    func fcm() {
        guard let userID = UserDefaults.standard.value(forKey: "userId") as? Int else {
            UserDefaults.standard.setValue(nil, forKey: "FCMToken")
//            print("⚠️No userID Found  ❌ ");
            return }
        
        guard  let refreshedToken = FIRInstanceID.instanceID().token() else {
//            print("⚠️No Token Returned From FCM  ❌ ");
            return }
//        print("☢️☣️InstanceID token: 📴📳\(refreshedToken)📴📳")
        
        if     UserDefaults.standard.value(forKey: "FCMToken") as? String != refreshedToken {
//            print("✅Updating Token ✳️found  userId: \(String(describing: UserDefaults.standard.value(forKey: "userId") as? String))\n ,FCMToken \(String(describing: UserDefaults.standard.value(forKey: "FCMToken") as? String))\n, refreshedToken \(refreshedToken)\n")
            
            let userFCM = MUserData()
            userFCM.userFCMToken(userID: userID, token: refreshedToken, completed: { (state,sms) in
                
                if state {
                    UserDefaults.standard.setValue(refreshedToken, forKey: "FCMToken")
//                    print("✅Updated Token  ✅ ")
                    
                }
            })
        }else {
//            print("❌ Won't Update Token,it's Already in UserDefauls⚠️That's userId: \(String(describing: UserDefaults.standard.value(forKey: "userId") as? Int))\n ,♎️FCMTokenNSDefault  📴📳\(String(describing: UserDefaults.standard.value(forKey: "FCMToken") as? String)) 📴📳\n, ♎️updatedInstanceID token: 📴📳\(refreshedToken)📴📳\n")
        }
        
    }
    //    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    //        print(error.localizedDescription)
    //    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
//        print("that's the userInfo : \(userInfo)")
//        print("that's the message Id  : \(String(describing: userInfo["gcm_message_id"]))")
//        print("application.applicationState: \(application.applicationState)")
        //        if application.applicationState == .active {
        //            //write your code here when app is in foreground
        ////            print("User is in here")
        ////            if let title = userInfo["title"] as? String , let body = userInfo["body"] as? String {
        ////            showAlert( title , body)
        ////            }
        //        }
    }
    
    //@End Notification
    

    
    func showAlert(_ title : String,_ sms : String) {
        guard title != "√√" else {
            let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Done"), message:langDicClass().getLocalizedTitle(sms) , type: .success)
            alert.isUserInteractionEnabled = false
            alert.show()
            return
        }
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
        guard title != "X" else {
            let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Something Went Wrong With"), message:langDicClass().getLocalizedTitle(sms) , type: .warning)
            alert.show()
            return
        }
        guard title != "XX" else {
            let alert = CDAlertView(title: langDicClass().getLocalizedTitle("Error"), message:langDicClass().getLocalizedTitle(sms) , type: .warning)
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
//        print("saving User Data email: \(String(describing: email)) , photoUrl: \(String(describing: photoUrl)),uid: \(String(describing: uid)),  , photoUrl: \(String(describing: name))")
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
//                print("saing this photo : \(photo)")
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
                UserDefaults.standard.setValue(nil, forKey: "usreName")
            }
        }
    }
    
    func isUserLoggedIn() -> Bool {
        if (UserDefaults.standard.value(forKey: "userId") != nil) {
            return true
        }else {
            guard let _ = UserDefaults.standard.value(forKey: "usreName") as? String else {
                return false
            }
            saveUserLogginData(email: nil, photoUrl: nil, uid: nil, name: nil)
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
    
    
    func confirmationAlert(_ mainTitle : String ,_ smsTitle : String, _ functionality :  @escaping () -> Void ) {
        let alert = CDAlertView(title: langDicClass().getLocalizedTitle(mainTitle), message: langDicClass().getLocalizedTitle(smsTitle), type: .notification)
        
        let actopn = CDAlertViewAction(title: langDicClass().getLocalizedTitle("Confirm")) {  (_) in
            functionality()
        }
        alert.add(action: actopn)
        let nevermindAction = CDAlertViewAction(title: langDicClass().getLocalizedTitle("Cancel"))
        alert.add(action: nevermindAction)
        alert.show()
    }
    
    
}
let ad = UIApplication.shared.delegate as! AppDelegate

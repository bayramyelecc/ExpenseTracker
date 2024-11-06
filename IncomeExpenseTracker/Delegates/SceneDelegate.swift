//
//  SceneDelegate.swift
//  IncomeExpenseTracker
//
//  Created by Bayram Yeleç on 4.11.2024.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let isOnBoarding = UserDefaults.standard.bool(forKey: "isOnBoarding")
        
        if isOnBoarding {
            let authVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "authid")
            window.rootViewController = UINavigationController(rootViewController: authVc)
            if Auth.auth().currentUser != nil {
                
                let gelirVC = UserDefaults.standard.bool(forKey: "gelir")
                
                if gelirVC {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabbar")
                    window.rootViewController = UINavigationController(rootViewController: vc)
                } else {
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "gelir")
                    window.rootViewController = mainViewController
                }
                
                
            } else {
                let authStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = authStoryboard.instantiateViewController(withIdentifier: "authid")
                window.rootViewController = loginViewController
            }
        } else {
            let OnBoardVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "onboard")
            window.rootViewController = UINavigationController(rootViewController: OnBoardVc)
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}


//
//  AppDelegate.swift
//  LightCardTabBar
//
//  Created by Hussein AlRyalat on 05/06/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        setupStyleSwizzling()
        return true
    }
    
    
//    func setupStyleSwizzling(){
//        let originalMethod = class_getInstanceMethod(UIView.self, #selector(UIView.didMoveToSuperview))
//        let swizzledMethod = class_getInstanceMethod(UIView.self, #selector(UIView.swizzledDidMoveToSuperview))
//        method_exchangeImplementations(originalMethod!, swizzledMethod!)
//    }
    
}



//extension UIView {
//    @objc func swizzledDidMoveToSuperview(){
//        self.updateStyle()
//    }
//}
//
///**
// A Stylable represents any entity whishes to update it's attributes based on given style
// */
//@objc
//protocol Styleable: NSObjectProtocol {
//
//    @objc func updateStyle()
//}
//
//extension UIView: Styleable {
//
//    func updateStyle() {
//
//    }
//}
//
//extension Styleable where Self: UIView {
//    func tellChildrenUpdateStyle(){
//        self.subviews.forEach {
//            $0.updateStyle()
//            $0.tellChildrenUpdateStyle()
//        }
//    }
//}

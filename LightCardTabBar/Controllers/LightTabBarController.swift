//
//  LightTabBarController.swift
//  LightCardTabBar
//
//  Created by Hussein AlRyalat on 05/06/2021.
//

import UIKit

class LightTabBarController: TabBarController {

    override func makeTabBar() -> BaseCardTabBar {
        LightTabBar()
    }
}

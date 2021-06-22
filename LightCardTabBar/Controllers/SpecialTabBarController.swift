//
//  SpecialTabBarController.swift
//  LightCardTabBar
//
//  Created by Hussein AlRyalat on 05/06/2021.
//

import UIKit

class SpecialTabBarController: TabBarController {

    
    override func makeTabBar() -> BaseCardTabBar {
        SpecialCardTabBar()
    }
}

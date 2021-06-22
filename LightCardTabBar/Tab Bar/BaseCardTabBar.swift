//
//  BaseCardTabBar.swift
//  LightCardTabBar
//
//  Created by Hussein AlRyalat on 05/06/2021.
//

import UIKit

protocol CardTabBarDelegate: AnyObject {
    func cardTabBar(_ sender: BaseCardTabBar, didSelectItemAt index: Int)
    
    func didUpdateHeight()
}

class BaseCardTabBar: UIView {
    
    var preferredTabBarHeight: CGFloat {
        70
    }
    
    var preferredBottomBackground: UIColor {
        .clear
    }
    
    weak var delegate: CardTabBarDelegate?
    
    func select(at index: Int, animated: Bool, notifyDelegate: Bool) {
        
    }
    
    func set(items: [UITabBarItem]) {
        
    }
}

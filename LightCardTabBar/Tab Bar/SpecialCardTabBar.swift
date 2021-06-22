//
//  SpecialCardTabBar.swift
//  tweetly
//
//  Created by Hussein AlRyalat on 20/05/2021.
//

import Foundation
import UIKit

class SpecialCardTabBar: BaseCardTabBar {
    
    override var preferredBottomBackground: UIColor {
        .white
    }

    let textCotainerStackView = UIStackView()
    let rightButtonsContainerStackView = UIStackView()
    let indicatorView = IndicatorView()
    
    fileprivate(set) var selectedIndex: Int = 0
        
    fileprivate var buttons: [BaseButton] = []
    fileprivate var firstTrigger: Bool = false
    fileprivate var indicatorCenterXConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        subviewsPreparedAL {
            textCotainerStackView
            rightButtonsContainerStackView
            indicatorView
        }
        
        textCotainerStackView.distribution = .fill
        textCotainerStackView.alignment = .center
        textCotainerStackView.axis = .horizontal
        textCotainerStackView.spacing = 15
        
        rightButtonsContainerStackView.distribution = .fill
        rightButtonsContainerStackView.alignment = .center
        rightButtonsContainerStackView.axis = .horizontal
        rightButtonsContainerStackView.spacing = 15
        
        textCotainerStackView.pinToSuperView(top: 0, left: 20, bottom: nil, right: nil)
        textCotainerStackView.bottomAnchor.constraint(equalTo: indicatorView.topAnchor, constant: 10).isActive = true

        rightButtonsContainerStackView.pinToSuperView(top: 8, left: nil, bottom: nil, right: -20)
        rightButtonsContainerStackView.centerYAnchor.constraint(equalTo: textCotainerStackView.centerYAnchor).isActive = true
        rightButtonsContainerStackView.leadingAnchor.constraint(greaterThanOrEqualTo: textCotainerStackView.trailingAnchor, constant: 15).isActive = true
        

        updateStyle()
    }
    
    func updateStyle() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 12
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.3
        
        let selected = self.selectedIndex
        self.select(at: selected, notifyDelegate: false)
    }
    
    func select(at index: Int, notifyDelegate: Bool){
        self.select(at: index, animated: false, notifyDelegate: notifyDelegate)
    }
    
    override func select(at index: Int, animated: Bool, notifyDelegate: Bool) {
        guard textCotainerStackView.arrangedSubviews.count > 0,
              rightButtonsContainerStackView.arrangedSubviews.count > 0 else {
            return
        }
        
        self.selectedIndex = index
        
        buttons.forEach {
            $0._isSelected = false
        }
        
        switch index {
        case 0:
            indicatorView.isHidden = false
            let button = textCotainerStackView.arrangedSubviews[0] as! BaseButton
            
            indicatorCenterXConstraint?.isActive = false
            indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
            indicatorCenterXConstraint.isActive = true
            
            button._isSelected = true
        case 1:
            let button = textCotainerStackView.arrangedSubviews[1] as! BaseButton

            indicatorView.isHidden = false
            
            indicatorCenterXConstraint?.isActive = false
            indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
            indicatorCenterXConstraint.isActive = true
            
            button._isSelected = true
        case 2:
            let button = rightButtonsContainerStackView.arrangedSubviews[0] as! BaseButton
            indicatorView.isHidden = false
            
            indicatorCenterXConstraint?.isActive = false
            indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
            indicatorCenterXConstraint.isActive = true
            
            button._isSelected = true
        case 3:
            let button = rightButtonsContainerStackView.arrangedSubviews[1] as! BaseButton
            indicatorView.isHidden = true
            
            indicatorCenterXConstraint?.isActive = false
            indicatorCenterXConstraint = indicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
            indicatorCenterXConstraint.isActive = true
            
            button._isSelected = true
        default:
            break
        }
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }

        
        if notifyDelegate {
            delegate?.cardTabBar(self, didSelectItemAt: selectedIndex)
        }
    }
    
    override func set(items: [UITabBarItem]) {
        guard items.count > 4 else  {
            fatalError("A Special CardTabBar can't be initialized with less than 4 items")
        }
        
        var mutableItems = items
        
        let firstItem = mutableItems.removeFirst()
        let firstTextButton = TextOnlyButton(title: firstItem.title)
        firstTextButton.tag = 0
        
        buttons.append(firstTextButton)
        self.textCotainerStackView.addingArrangedSubviews {
            firstTextButton
        }
        
        let anotherFirstItem = mutableItems.removeFirst()
        let secondTextButton = TextOnlyButton(title: anotherFirstItem.title)
        secondTextButton.tag = 1

        buttons.append(secondTextButton)
        self.textCotainerStackView.addingArrangedSubviews {
            secondTextButton
        }
        
        let anotherLastItem = mutableItems.remove(at: mutableItems.count - 2)
        let withImageButton = IconOnlyButton(image: anotherLastItem.image, selectedImage: anotherLastItem.selectedImage)
        withImageButton.tag = 2

        
        buttons.append(withImageButton)
        self.rightButtonsContainerStackView.addingArrangedSubviews {
            withImageButton
        }
        
        let lastItem = mutableItems.removeLast()
        let specialButton = SpecialButton(image: lastItem.image, selectedImage: lastItem.selectedImage)
        specialButton.tag = 3

        
        buttons.append(specialButton)
        self.rightButtonsContainerStackView.addingArrangedSubviews {
            specialButton
        }
        
        
        buttons.forEach {
            $0.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        }
    }
    
    @objc func buttonTapped(sender: BaseButton){
        self.select(at: sender.tag, animated: true, notifyDelegate: true)
    }
}

extension SpecialCardTabBar {
    
    class IndicatorView: UIView {
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            updateStyle()
        }
        
        func updateStyle() {
            layer.cornerRadius = 2
            backgroundColor = .black
        }
        
        override var intrinsicContentSize: CGSize {
            .init(width: 4, height: 4)
        }
    }
    
    class BaseButton: UIButton {
        var _isSelected: Bool = false {
            didSet {
                updateStyle()
            }
        }
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            updateStyle()
        }
        
        
        func updateStyle(){
            
        }
    }
    
    class TextOnlyButton: BaseButton {
        
        let title: String?
        
        init(title: String?){
            self.title = title
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func updateStyle() {
            setTitle(title, for: .normal)
            setTitleColor(_isSelected ? .black : .lightGray, for: .normal)
            titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        }
    }

    class IconOnlyButton: BaseButton {

        let image: UIImage?
        let selectedImage: UIImage?
        
        init(image: UIImage?, selectedImage: UIImage?){
            self.image = image
            self.selectedImage = selectedImage
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func updateStyle(){
            setImage(_isSelected ? selectedImage : image, for: .normal)
            tintColor = _isSelected ? .black : .lightGray
        }
    }
    
    class SpecialButton: BaseButton {
        
        let image: UIImage?
        let selectedImage: UIImage?
        
        init(image: UIImage?, selectedImage: UIImage?){
            self.image = image
            self.selectedImage = selectedImage
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func updateStyle(){
            layer.cornerRadius = 6
            
            setImage(_isSelected ? selectedImage : image, for: .normal)
            tintColor = _isSelected ? .white : .black
            backgroundColor = _isSelected ? .black :  UIColor(white: 0.93, alpha: 1)
        }
        
        override var intrinsicContentSize: CGSize {
            .init(width: 50, height: 50)
        }
    }
}





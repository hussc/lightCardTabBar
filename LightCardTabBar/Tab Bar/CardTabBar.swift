//
//  CardTabBar.swift
//  LightCardTabBar
//
//  Created by Hussein AlRyalat on 05/06/2021.
//

import UIKit

class CardTabBar: BaseCardTabBar {
    
    override var preferredTabBarHeight: CGFloat {
        75
    }
    
    override var preferredBottomBackground: UIColor {
        .clear
    }
    
    lazy var containerView: UIView = UIView()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        return stackView
    }()
    
    
    lazy var indicatorView: PTIndicatorView = {
        let view = PTIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.constraint(width: 4)
        view.backgroundColor = .black
        view.makeWidthEqualHeight()
        
        return view
    }()
    
    
    private var indicatorViewXConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    deinit {
        stackView.arrangedSubviews.forEach {
            if let button = $0 as? UIControl {
                button.removeTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
            }
        }
    }
    
    private func setup(){
        translatesAutoresizingMaskIntoConstraints = false
        
        subviewsPreparedAL {
            containerView
        }
        
        containerView.subviewsPreparedAL {
            stackView
            indicatorView
        }
        
        containerView.pinToSuperView(top: 0, left: 20, bottom: -15, right: -20)
        stackView.pinToSuperView(top: 0, left: 20, bottom: nil, right: -20)
        stackView.centerInSuperView()
        
        indicatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -12).isActive = true
        
        updateStyle()
    }
    
    
    func updateStyle(){
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        containerView.layer.shadowRadius = 6
        containerView.layer.shadowOpacity = 0.15
    }
    
    
    override func set(items: [UITabBarItem]) {
        for button in (stackView.arrangedSubviews.compactMap { $0 as? PTBarButton }) {
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
            button.removeTarget(self, action: nil, for: .touchUpInside)
        }
        
        for item in items {
            if let image = item.image {
                addButton(with: image)
            } else {
                addButton(with: UIImage())
            }
        }
        
        layoutIfNeeded()
    }
    
    override func select(at index: Int, animated: Bool, notifyDelegate: Bool) {
        /* move the indicator view */
        if indicatorViewXConstraint != nil {
            indicatorViewXConstraint.isActive = false
            indicatorViewXConstraint = nil
        }
        
        for (bIndex, button) in buttons().enumerated() {
            button.selectedColor = .black
            button.isSelected = bIndex == index
            
            if bIndex == index {
                indicatorViewXConstraint = indicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
                indicatorViewXConstraint.isActive = true
            }
        }
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
        
        
        if notifyDelegate {
            self.delegate?.cardTabBar(self, didSelectItemAt: index)
        }
    }
    
    private func addButton(with image: UIImage){
        let button = PTBarButton(image: image)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.selectedColor = .black
        
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        self.stackView.addArrangedSubview(button)
    }
    
    private func buttons() -> [PTBarButton] {
        return stackView.arrangedSubviews.compactMap { $0 as? PTBarButton }
    }
    
    
    @objc func buttonTapped(sender: PTBarButton){
        if let index = stackView.arrangedSubviews.firstIndex(of: sender){
            select(at: index, animated: true, notifyDelegate: true)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = touches.first?.location(in: self) else {
            super.touchesEnded(touches, with: event)
            return
        }
        
        let buttons = self.stackView.arrangedSubviews.compactMap { $0 as? PTBarButton }.filter { !$0.isHidden }
        let distances = buttons.map { $0.center.distance(to: position) }
        
        let buttonsDistances = zip(buttons, distances)
        
        if let closestButton = buttonsDistances.min(by: { $0.1 < $1.1 }) {
            buttonTapped(sender: closestButton.0)
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = containerView.bounds.height / 2
    }
}

extension CardTabBar {
    open class PTIndicatorView: UIView {
        override open func layoutSubviews() {
            super.layoutSubviews()
            self.backgroundColor = .black
            self.layer.cornerRadius = self.bounds.height / 2
        }
    }

    
    public class PTBarButton: UIButton {
        
        var selectedColor: UIColor = .black {
            didSet {
                reloadApperance()
            }
        }
        
        var unselectedColor: UIColor = .lightGray {
            didSet {
                reloadApperance()
            }
        }
        
        init(forItem item: UITabBarItem) {
            super.init(frame: .zero)
            setImage(item.image, for: .normal)
        }
        
        init(image: UIImage){
            super.init(frame: .zero)
            setImage(image, for: .normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        
        override public var isSelected: Bool {
            didSet {
                reloadApperance()
            }
        }
        
        func reloadApperance(){
            self.tintColor = isSelected ? selectedColor : unselectedColor
        }
    }

}

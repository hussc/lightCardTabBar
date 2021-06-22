//
//  CardTabBar.swift
//  tweetly
//
//  Created by Hussein AlRyalat on 13/05/2021.
//

import UIKit


class SemiCardTabBar: BaseCardTabBar {
    
    struct TabBarItem: Equatable {
        var image: UIImage
    }
    
    override var preferredBottomBackground: UIColor {
        .white
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        
        self.addSubview(stackView)
        
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        
        return stackView
    }()
        
    private(set) var items: [TabBarItem] = []
    fileprivate(set) var selectedIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
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
        self.select(at: selected, animated: false, notifyDelegate: false)
    }
    
    func add(item: TabBarItem){
        self.items.append(item)
        self.addButton(with: item.image)
    }
    
    func hide(at index: Int){
        guard stackView.arrangedSubviews.count > index, index >= 0 else {
            return
        }
        
        stackView.arrangedSubviews[index].isHidden = true
    }
    
    func unhide(at index: Int){
        guard stackView.arrangedSubviews.count > index, index >= 0 else {
            return
        }
        
        stackView.arrangedSubviews[index].isHidden = false
    }
    
    func remove(item: TabBarItem){
        if let index = self.items.firstIndex(of: item) {
            self.items.remove(at: index)
            let view = self.stackView.arrangedSubviews[index]
            self.stackView.removeArrangedSubview(view)
        }
    }
    
    private func addButton(with image: UIImage){
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.tintColor = tintColor
        button.tag = self.items.count
        
        button.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        self.stackView.addArrangedSubview(button)
    }
    
    override func set(items: [UITabBarItem]) {
        items.compactMap { $0.image }.forEach {
            self.add(item: .init(image: $0))
        }
    }
    
    override func select(at index: Int, animated: Bool, notifyDelegate: Bool = true){
        selectedIndex = index
        for (bIndex, view) in stackView.arrangedSubviews.enumerated() {
            if let button = view as? UIButton {
                button.tintColor =  bIndex == index ? .black : UIColor.black.withAlphaComponent(0.4)
            }
        }
        
        if notifyDelegate {
            self.delegate?.cardTabBar(self, didSelectItemAt: index)
        }
    }
    
    @objc func buttonTapped(sender: UIButton){
        if let index = stackView.arrangedSubviews.firstIndex(of: sender){
            select(at: index, animated: true)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let position = touches.first?.location(in: self) else {
            super.touchesEnded(touches, with: event)
            return
        }
        
        let buttons = self.stackView.arrangedSubviews.compactMap { $0 as? UIButton }.filter { !$0.isHidden }
        let distances = buttons.map { $0.center.distance(to: position) }
        
        let buttonsDistances = zip(buttons, distances)
        
        if let closestButton = buttonsDistances.min(by: { $0.1 < $1.1 }) {
            buttonTapped(sender: closestButton.0)
        }
    }
}

//
//  LightTabBar.swift
//  LightCardTabBar
//
//  Created by Hussein AlRyalat on 05/06/2021.
//

import UIKit

class LightTabBar: BaseCardTabBar {
    
    override var preferredBottomBackground: UIColor {
        .clear
    }
    
    override var preferredTabBarHeight: CGFloat {
        75
    }

    let containerView = UIView()
    let containerStackView = UIStackView()
    let indicatorView = IndicatorView()
    
    fileprivate var buttons: [BaseButton] = []
    var selectedIndex: Int = 0
    
    fileprivate var indicatorCenterX: NSLayoutConstraint!
    fileprivate var indicatorWidth: NSLayoutConstraint!
    
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
            containerView
        }
        
        containerView.subviewsPreparedAL {
            containerStackView
            indicatorView
        }
        
        containerStackView.distribution = .fillEqually
        containerStackView.spacing = 15
        containerStackView.axis = .horizontal
        containerStackView.alignment = .fill
        
        indicatorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        indicatorView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.pinToSuperView(top: 7.5, left: 20, bottom: -7.5, right: -20)
        containerStackView.pinToSuperView(top: 10, left: 10, bottom: -10, right: -10)
        
        updateStyle()
    }
    
    func updateStyle() {
        backgroundColor = .clear
        
        containerView.backgroundColor = .black
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: -2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.3
    }

    override func select(at index: Int, animated: Bool, notifyDelegate: Bool) {
        guard !buttons.isEmpty else { return }
        
        self.selectedIndex = index
        let selectedButton = buttons[index]

        
        indicatorCenterX?.isActive = false
        indicatorWidth?.isActive = false
        
        indicatorCenterX = indicatorView.centerXAnchor.constraint(equalTo: selectedButton.centerXAnchor)
        indicatorCenterX.isActive = true
        
        indicatorWidth = indicatorView.widthAnchor.constraint(equalTo: selectedButton.widthAnchor)
        indicatorWidth.isActive = true

        let block = {
            self.buttons.forEach {
                $0._isSelected = false
            }
            
            selectedButton._isSelected = true
            
            self.containerView.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: block)
        } else {
            block()
        }

        if notifyDelegate {
            self.delegate?.cardTabBar(self, didSelectItemAt: index)
        }
    }
    
    override func set(items: [UITabBarItem]) {
        self.buttons = []
        self.containerStackView.arrangedSubviews.forEach {
            self.containerStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        
        let buttons: [IconOnlyButton] = items.enumerated().map {
            let button = IconOnlyButton(image: $0.element.image, selectedImage: $0.element.selectedImage)
            button.tag = $0.offset
            return button
        }
        
        
        buttons.forEach {
            $0.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
        }
        
        self.buttons = buttons
        self.containerStackView.addingArrangedSubviews(buttons)
    }
    
    @objc func buttonTapped(sender: BaseButton){
        self.select(at: sender.tag, animated: true, notifyDelegate: true)
    }
}


extension LightTabBar {
    class IndicatorView: UIView {
        
        let topView = UIView()
        let gradientView = GradientView()
        let gradientMask = CAShapeLayer()
        
        let offset: CGFloat = 4
        
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
                gradientView
                topView
            }
            
            gradientView.pinToSuperView()
            
            topView.pinToSuperView(top: 0, left: offset, bottom: nil, right: -offset)
            topView.constraint(height: 3)
            
            
            updateStyle()
        }
        
        func updateStyle() {
            gradientView.colors = [.white.withAlphaComponent(0.2), .white.withAlphaComponent(0)]
            gradientView.locations = [0, 0.8]
            gradientView.isOpaque = false
            
            topView.backgroundColor = .white
            topView.layer.cornerRadius = 1
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            self.gradientMask.path = pathForMask(in: bounds, offset: offset * 2).cgPath
            self.gradientView.layer.mask = gradientMask
        }
        
        func pathForMask(in rect: CGRect, offset: CGFloat) -> UIBezierPath {
            let path = UIBezierPath()
            
            path.move(to: CGPoint(x: offset, y: 0))
            path.addLine(to: CGPoint(x: rect.width - offset, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.close()

            return path
        }
    }
    
    class BaseButton: UIButton {
        var _isSelected: Bool = false {
            didSet {
                updateStyle()
            }
        }
        
        func updateStyle() {
            
        }
    }
    
    class IconOnlyButton: BaseButton {

        let image: UIImage?
        let selectedImage: UIImage?
        
        init(image: UIImage?, selectedImage: UIImage?){
            self.image = image
            self.selectedImage = selectedImage
            super.init(frame: .zero)
            
            
            translatesAutoresizingMaskIntoConstraints = false
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func updateStyle(){
            setImage(_isSelected ? selectedImage : image, for: .normal)
            tintColor = _isSelected ? .white : UIColor.white.withAlphaComponent(0.25)
        }
        
        override var intrinsicContentSize: CGSize {
            .init(width: 45, height: 45)
        }
    }
        
}

class GradientView: UIView {

    var colors: [UIColor]? {
        didSet {
            updateGradient()
        }
    }

    var locations: [CGFloat]? {
        didSet {
            updateGradient()
        }
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        let size = bounds.size

        // Gradient
        if let gradient = gradient {
            let options: CGGradientDrawingOptions = [.drawsAfterEndLocation]

            let startPoint = CGPoint.zero
            let endPoint = CGPoint(x: 0, y: size.height)
            context?.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: options)
        }
    }


    override func didMoveToWindow() {
        super.didMoveToWindow()
        contentMode = .redraw
    }

    // MARK: - Private
    private var gradient: CGGradient?

    private func updateGradient() {
        gradient = nil
        setNeedsDisplay()

        if let colors = self.colors {
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colorSpaceModel = colorSpace.model

            let gradientColors = colors.map { (color: UIColor) -> AnyObject in
                let cgColor = color.cgColor
                let cgColorSpace = cgColor.colorSpace ?? colorSpace

                if cgColorSpace.model == colorSpaceModel {
                    return cgColor as AnyObject
                }

                var red: CGFloat = 0
                var blue: CGFloat = 0
                var green: CGFloat = 0
                var alpha: CGFloat = 0
                color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
                return UIColor(red: red, green: green, blue: blue, alpha: alpha).cgColor as AnyObject
            } as NSArray

            gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors, locations: locations)
        }
    }
}

//
//  UIStackView+Additions.swift
//  talabyeh
//
//  Created by Hussein Work on 11/11/20.
//  Copyright © 2020 Dominate. All rights reserved.
//

import UIKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}


@resultBuilder public struct SubviewsBuilder {
    public static func buildBlock(_ content: UIView...) -> [UIView] {
        return content
    }
}

/**
 Creating a chainable stackview to make life easiere
 */

extension UIStackView {
    @discardableResult
    func alignment(_ alignment: Alignment) -> UIStackView {
        self.alignment = alignment
        return self
    }

    @discardableResult
    func distribution(_ distribution: Distribution) -> UIStackView {
        self.distribution = distribution
        return self
    }

    @discardableResult
    func spacing(_ spacing: CGFloat) -> UIStackView {
        self.spacing = spacing
        return self
    }

    @discardableResult
    func axis(_ axis: NSLayoutConstraint.Axis) -> UIStackView {
        self.axis = axis
        return self
    }

    @discardableResult
    func addingArrangedSubviews(_ arrangedSubviews: [UIView]) -> UIStackView {
        arrangedSubviews.forEach {
            self.addArrangedSubview($0)
        }

        return self
    }

    @discardableResult
    func preparedForAutolayout() -> UIStackView {
        translatesAutoresizingMaskIntoConstraints = false
        return self
    }

    @discardableResult
    func addingArrangedSubviews(@SubviewsBuilder content: () -> [UIView]) -> UIStackView {
        for sv in content() {
            addArrangedSubview(sv)
            sv.translatesAutoresizingMaskIntoConstraints = false
        }
        return self
    }
}

extension UIView {
    func subviewsPreparedAL(@SubviewsBuilder content: () -> [UIView]){
        for view in content() {
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
}

extension UIView {
    func pinToSafeArea(top: CGFloat? = 0, left: CGFloat? = 0, bottom: CGFloat? = 0, right: CGFloat? = 0){
        guard let superview = self.superview else { return }
        
        prepareForAutoLayout()
        
        var guide: UILayoutGuide
        if #available(iOS 11.0, *) {
            guide = superview.safeAreaLayoutGuide
        } else {
            guide = superview.layoutMarginsGuide
        }
        
        if let top = top {
            self.topAnchor.constraint(equalTo: guide.topAnchor, constant: top).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: bottom).isActive = true
        }
        
        if let left = left {
            self.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: left).isActive = true
        }
        
        if let right = right {
            self.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: right).isActive = true
        }
    }
    
    func pinToSuperView(top: CGFloat? = 0, left: CGFloat? = 0, bottom: CGFloat? = 0, right: CGFloat? = 0){
        guard let superview = self.superview else { return }
        
        prepareForAutoLayout()
        
        if let top = top {
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
        }
        
        if let left = left {
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: left).isActive = true
        }
        
        if let right = right {
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: right).isActive = true
        }
    }
    
    func centerInSuperView(){
        guard let superview = self.superview else { return }
        
        prepareForAutoLayout()
        
        self.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
    
    func constraint(width: CGFloat){
        prepareForAutoLayout()
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func constraint(height: CGFloat){
        prepareForAutoLayout()
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func makeWidthEqualHeight(){
        prepareForAutoLayout()
        self.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func prepareForAutoLayout(){
        translatesAutoresizingMaskIntoConstraints = false
    }
}


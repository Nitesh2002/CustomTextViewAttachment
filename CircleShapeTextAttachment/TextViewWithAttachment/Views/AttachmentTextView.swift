//
//  AttachmentTextView.swift
//  KPFlagship
//
//  Created by Nitesh MIshra on 3/26/21.
//  Copyright © 2021 Kaiser Permanente. All rights reserved.
//

import UIKit

protocol TextViewAttachmentDelegate: class {
    func didTapTextView(isAttachmentTapped: Bool)
}

class AttachmentTextView: UITextView {
    weak var textViewDelegate: TextViewAttachmentDelegate?
    private let attachmentBehavior = TextViewSubviewAttachingBehavior()
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(_ attachmenPadding: CGFloat = CGFloat(Int.valueFive)) {
        setUpDefaultAttributes()
    }
    
    private func setUpDefaultAttributes() {
        isScrollEnabled = false
        isSelectable = false
        isEditable = false
        adjustsFontForContentSizeCategory = true
        textContainerInset = .zero
        textContainer.lineFragmentPadding = .zero
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    func setAttachmentBehaviour(_ padding: CGFloat, _ cornerRadius: CGFloat? = nil) {
        self.attachmentBehavior.attachmentPadding = padding
        self.attachmentBehavior.attachmentCornerRadius = cornerRadius
        self.attachmentBehavior.textView = self
        self.layoutManager.delegate = self.attachmentBehavior
        self.textStorage.delegate = self.attachmentBehavior
    }
    
    open override var textContainerInset: UIEdgeInsets {
        didSet {
            // Text container insets are used to convert coordinates between the text container and text view, so a change to these insets must trigger a layout update
            self.attachmentBehavior.layoutAttachedSubviews()
        }
    }
    
    override func accessibilityActivate() -> Bool {
        textViewDelegate?.didTapTextView(isAttachmentTapped: false)
        return true
    }
}

extension AttachmentTextView {
    
    func addShapeLabelTextAttachment(text: String, label: UILabel, shapeType: Shape) {
        if let substringRange = text.range(of: label.text ?? Constants.empty) {
            let labelSize = label.size()
            
            let circleDiameter = max(labelSize.height, labelSize.width)
            let y = (label.font.capHeight - circleDiameter).rounded() / CGFloat(Int.valueTwo)
            let bounds = CGRect(x: .zero, y: y, width: circleDiameter , height: circleDiameter)
            setAttachmentBehaviour(.zero, cornerRadius(shape: shapeType, _diameter: circleDiameter))
            
            let textRange = NSRange(substringRange, in: text)
            setCircleLabelTextAttachment(text: text, label: label, bounds: bounds, range: textRange)
        } else {
            self.text = text
        }
    }
    
    func addCustomViewTextAttachment(text: String, attachmentView: UIView, range: NSRange) {
        let y = (UIFont.preferredFont(forTextStyle: .headline).xHeight   - Constant.height).rounded() / CGFloat(Int.valueTwo)
        let bounds = CGRect(x: .zero, y: y, width: Constant.height, height: Constant.height)
        setAttachmentBehaviour(.zero, nil)
        setTextAttachment(text: text, view: attachmentView, bounds: bounds,font: UIFont.preferredFont(forTextStyle: .headline), range: range)
    }
    
    func addCustomViewTextAttachmentAtEnd(text: String, attachmentView: UIView) {
        let y = (UIFont.preferredFont(forTextStyle: .headline).xHeight   - Constant.height).rounded() / CGFloat(Int.valueTwo)
        let bounds = CGRect(x: .zero, y: y, width: Constant.height, height: Constant.height)
        setAttachmentBehaviour(.zero, nil)
        setTextAttachmentInTheEnd(text: text, view: attachmentView, bounds: bounds,font: UIFont.preferredFont(forTextStyle: .headline))
    }
    
    private func cornerRadius(shape: Shape,_diameter: CGFloat) -> CGFloat {
        switch shape {
        case .circle:
            return _diameter/CGFloat(Int.valueTwo)
        case .square:
            return Constants.squareCornerRadius
        }
    }
}

extension AttachmentTextView {
    @objc private func tapped(sender: UITapGestureRecognizer) {
        
        var location = sender.location(in: self)
        location.x -= textContainerInset.left
        location.y -= textContainerInset.top
        
        let characterIndex = layoutManager.characterIndex(for: location,
                                                          in: textContainer,
                                                          fractionOfDistanceBetweenInsertionPoints: nil)
        
        if characterIndex < textStorage.length {
            let attributeValue = attributedText.attribute(.attachment, at: characterIndex, effectiveRange: nil) as? NSTextAttachment
            textViewDelegate?.didTapTextView(isAttachmentTapped: attributeValue != nil)
        }
    }
}

extension AttachmentTextView {
    
    private enum Constant {
        static let height: CGFloat = 32
    }
}

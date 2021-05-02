//
//  AttachmentTextView.swift
//  KPFlagship
//
//  Created by Nitesh MIshra on 3/26/21.
//  Copyright © 2021 Kaiser Permanente. All rights reserved.
//

import UIKit

class AttachmentTextView: UITextView {
    
    private let attachmentBehavior = TextViewSubviewAttachingBehavior()
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit(_ attachmenPadding: CGFloat = 5) {
        setUpDefaultAttributes()
    }
    
    private func setUpDefaultAttributes() {
        isScrollEnabled = false
        isSelectable = false
        isEditable = false
        adjustsFontForContentSizeCategory = true
        textContainerInset = .zero
        textContainer.lineFragmentPadding = .zero
    }
    
    func setAttachmentBehaviour(_ padding: CGFloat, _ cornerRadius: CGFloat) {
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
}

extension AttachmentTextView {
    
    func addShapeLabelTextAttachment(text: String, label: UILabel, shapeType: Shape) {
        if let substringRange = text.range(of: label.text ?? Constants.empty) {
            let labelSize = label.size()
            
            let circleDiameter = max(labelSize.height, labelSize.width)
            let y = (label.font.capHeight - circleDiameter).rounded() / 2
            let bounds = CGRect(x: .zero, y: y, width: circleDiameter , height: circleDiameter)
            setAttachmentBehaviour(.zero, cornerRadius(shape: shapeType, _diameter: circleDiameter))
            let textRange = NSRange(substringRange, in: text)
            setCircleLabelTextAttachment(text: text, label: label, bounds: bounds, range: textRange)
        } else {
            self.text = text
        }
    }
    
    private func cornerRadius(shape: Shape,_diameter: CGFloat) -> CGFloat {
        switch shape {
        case .circle:
            return _diameter/2
        case .square:
            return Constants.squareCornerRadius
        }
    }
}


import UIKit

open class TextViewSubviewAttachingBehavior: NSObject, NSLayoutManagerDelegate, NSTextStorageDelegate {
    
    @objc
    open weak var textView: UITextView? {
        willSet {
            // Remove all managed subviews from the text view being disconnected
            self.removeAttachedSubviews()
        }
        didSet {
            // Synchronize managed subviews to the new text view
            self.updateAttachedSubviews()
            self.layoutAttachedSubviews()
        }
    }
    
    var attachmentPadding: CGFloat = Constant.padding
    var attachmentCornerRadius: CGFloat?

    // MARK: Subview tracking
    
    private let attachedViews = NSMapTable<AnyObject, UIView>.strongToStrongObjects()
    private var attachedProviders: [TextAttachedViewProvider] {
        return Array(self.attachedViews.keyEnumerator()) as? [TextAttachedViewProvider] ?? []
    }
    
    @objc
    open func updateAttachedSubviews() {
        guard let textView = self.textView else {
            return
        }
        
        // Collect all TextSubviewAttachment attachments
        let subviewAttachments = textView.textStorage.subviewAttachmentRanges.map { $0.attachment }
        
        // Remove views whose providers are no longer attached
        for provider in self.attachedProviders {
            if (subviewAttachments.contains { $0.viewProvider === provider } == false) {
                self.attachedViews.object(forKey: provider)?.removeFromSuperview()
                self.attachedViews.removeObject(forKey: provider)
            }
        }
        
        // Insert views that became attached
        let attachmentsToAdd = subviewAttachments.filter {
            self.attachedViews.object(forKey: $0.viewProvider) == nil
        }
        
        for attachment in attachmentsToAdd {
            let provider = attachment.viewProvider
            let view = provider.instantiateView(for: attachment, in: self)
            view.translatesAutoresizingMaskIntoConstraints = true
            view.autoresizingMask = [ ]
            
            if let radius = attachmentCornerRadius {
                view.layer.cornerRadius = radius
                view.clipsToBounds = true
            }
           
            textView.addSubview(view)
            self.attachedViews.setObject(view, forKey: provider)
        }
    }
    
    private func removeAttachedSubviews() {
        for provider in self.attachedProviders {
            self.attachedViews.object(forKey: provider)?.removeFromSuperview()
        }
        self.attachedViews.removeAllObjects()
    }
    
    // MARK: Layout
    
    @objc
    open func layoutAttachedSubviews() {
        guard let textView = self.textView else {
            return
        }
        
        let layoutManager = textView.layoutManager
        let scaleFactor = textView.window?.screen.scale ?? UIScreen.main.scale
        
        // For each attached subview, find its associated attachment and position it according to its text layout
        let attachmentRanges = textView.textStorage.subviewAttachmentRanges
        for (attachment, range) in attachmentRanges {
            guard let view = self.attachedViews.object(forKey: attachment.viewProvider) else {
                // A view for this provider is not attached yet??
                continue
            }
            guard view.superview === textView else {
                // Skip views which are not inside the text view for some reason
                continue
            }
            guard let attachmentRect = TextViewSubviewAttachingBehavior.boundingRect(forAttachmentCharacterAt: range.location, layoutManager: layoutManager) else {
                // Can't determine the rectangle for the attachment: just hide it
                view.isHidden = true
                continue
            }
            
            let convertedRect = textView.convertRectFromTextContainer(attachmentRect)
            let integralRect = CGRect(origin: convertedRect.origin.integral(withScaleFactor: scaleFactor),
                                      size: convertedRect.size)
            
            UIView.performWithoutAnimation {
                view.frame = CGRect(x: integralRect.origin.x - attachmentPadding, y: integralRect.origin.y, width: integralRect.size.width, height: integralRect.size.height)
                view.isHidden = false
            }
        }
    }
    
    private static func boundingRect(forAttachmentCharacterAt characterIndex: Int, layoutManager: NSLayoutManager) -> CGRect? {
        let glyphRange = layoutManager.glyphRange(forCharacterRange: NSMakeRange(characterIndex, 1), actualCharacterRange: nil)
        let glyphIndex = glyphRange.location
        guard glyphIndex != NSNotFound && glyphRange.length == 1 else {
            return nil
        }
        
        let attachmentSize = layoutManager.attachmentSize(forGlyphAt: glyphIndex)
        guard attachmentSize.width > 0.0 && attachmentSize.height > 0.0 else {
            return nil
        }
        
        let lineFragmentRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: nil)
        let glyphLocation = layoutManager.location(forGlyphAt: glyphIndex)
        guard lineFragmentRect.width > 0.0 && lineFragmentRect.height > 0.0 else {
            return nil
        }
        
        return CGRect(origin: CGPoint(x: lineFragmentRect.minX + glyphLocation.x,
                                      y: lineFragmentRect.minY + glyphLocation.y - attachmentSize.height),
                      size: attachmentSize)
    }
    
    // MARK: NSLayoutManagerDelegate
    
    public func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        if layoutFinishedFlag {
            self.layoutAttachedSubviews()
        }
    }
    
    // MARK: NSTextStorageDelegate
    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        if editedMask.contains(.editedAttributes) {
            self.updateAttachedSubviews()
        }
    }
    
}

extension TextViewSubviewAttachingBehavior {
    
    private enum Constant {
        static let padding: CGFloat = 10
    }
}

private extension CGPoint {
    func integral(withScaleFactor scaleFactor: CGFloat) -> CGPoint {
        guard scaleFactor > 0.0 else {
            return self
        }
        
        return CGPoint(x: round(self.x * scaleFactor) / scaleFactor,
                       y: round(self.y * scaleFactor) / scaleFactor)
    }
}


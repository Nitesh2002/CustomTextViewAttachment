
import UIKit

open class TextSubviewAttachment: NSTextAttachment {
    
    public let viewProvider: TextAttachedViewProvider
   
    public init(viewProvider: TextAttachedViewProvider) {
        self.viewProvider = viewProvider
        super.init(data: nil, ofType: nil)
    }
    
    @objc
    public convenience init(view: UIView, size: CGSize) {
        let provider = DirectTextAttachedViewProvider(view: view)
        self.init(viewProvider: provider)
        self.bounds = CGRect(origin: .zero, size: size)
    }
    
    @objc
    public convenience init(view: UIView) {
        
        self.init(view: view, size: view.textAttachmentFittingSize)
    }
    
    // MARK: - NSTextAttachmentContainer
    
    open override func attachmentBounds(for textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint, characterIndex charIndex: Int) -> CGRect {
        return self.viewProvider.bounds(for: self, textContainer: textContainer, proposedLineFragment: lineFrag, glyphPosition: position)
    }
    
    open override func image(forBounds imageBounds: CGRect, textContainer: NSTextContainer?, characterIndex charIndex: Int) -> UIImage? {
        return nil
    }
    
    // MARK: NSCoding
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("TextSubviewAttachment cannot be decoded.")
    }
    
}

// MARK: - Internal view provider

final internal class DirectTextAttachedViewProvider: TextAttachedViewProvider {
    
    let view: UIView
    var makeCircular = true
    init(view: UIView) {
        self.view = view
    }
    
    func instantiateView(for attachment: TextSubviewAttachment, in behavior: TextViewSubviewAttachingBehavior) -> UIView {
        return self.view
    }
    
    func bounds(for attachment: TextSubviewAttachment, textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint) -> CGRect {
        return attachment.bounds
    }
}

public extension NSTextAttachment {
    
    convenience init(image: UIImage, size: CGSize? = nil) {
        self.init(data: nil, ofType: nil)
        
        self.image = image
        if let size = size {
            self.bounds = CGRect(origin: .zero, size: size)
        }
    }
}

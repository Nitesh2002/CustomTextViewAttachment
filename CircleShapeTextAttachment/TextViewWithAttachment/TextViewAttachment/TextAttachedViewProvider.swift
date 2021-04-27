
import UIKit

public protocol TextAttachedViewProvider: class {
    func instantiateView(for attachment: TextSubviewAttachment, in behavior: TextViewSubviewAttachingBehavior) -> UIView
    func bounds(for attachment: TextSubviewAttachment, textContainer: NSTextContainer?, proposedLineFragment lineFrag: CGRect, glyphPosition position: CGPoint) -> CGRect
}

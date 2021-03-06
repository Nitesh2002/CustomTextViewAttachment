//
//  UI+FoundationExtensions.swift
//  TextViewWithAttachment
//
//  Created by Nitesh MIshra on 2/9/21.
//
import UIKit
import Foundation

extension UIView {
    var textAttachmentFittingSize: CGSize {
        let fittingSize = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        if fittingSize.width > 1e-3 && fittingSize.height > 1e-3 {
            return fittingSize
        } else {
            return self.bounds.size
        }
    }
}

extension NSAttributedString {
    
    func insertingAttachment(_ attachment: NSTextAttachment, at index: Int, with paragraphStyle: NSParagraphStyle? = nil) -> NSAttributedString? {
        let copy = self.mutableCopy() as? NSMutableAttributedString
        copy?.insertAttachment(attachment, at: index, with: paragraphStyle)
        return copy?.copy() as? NSAttributedString
    }
    
    func addingAttributes(_ attributes: [NSAttributedString.Key: Any]) -> NSAttributedString? {
        let copy = self.mutableCopy() as? NSMutableAttributedString
        copy?.addAttributes(attributes)
        return copy?.copy() as? NSAttributedString
    }
    
    var subviewAttachmentRanges: [(attachment: TextSubviewAttachment, range: NSRange)] {
        var ranges = [(TextSubviewAttachment, NSRange)]()
        
        let fullRange = NSRange(location: 0, length: self.length)
        self.enumerateAttribute(NSAttributedString.Key.attachment, in: fullRange) { value, range, _ in
            if let attachment = value as? TextSubviewAttachment {
                ranges.append((attachment, range))
            }
        }
        
        return ranges
    }
}

extension NSMutableAttributedString {
    
    func insertAttachment(_ attachment: NSTextAttachment, at index: Int, with paragraphStyle: NSParagraphStyle? = nil) {
        let plainAttachmentString = NSAttributedString(attachment: attachment)
        
        if let paragraphStyle = paragraphStyle {
            let attachmentString = plainAttachmentString
                .addingAttributes([ .paragraphStyle: paragraphStyle ])
            let separatorString = NSAttributedString(string: Constants.paragraphSeparator)
            
            // Surround the attachment string with paragraph separators, so that the paragraph style is only applied to it
            let insertion = NSMutableAttributedString()
            insertion.append(separatorString)
            if let finalAttachmentString = attachmentString {
                insertion.append(finalAttachmentString)
            }
            insertion.append(separatorString)
            
            self.insert(insertion, at: index)
        } else {
            self.insert(plainAttachmentString, at: index)
        }
    }
    
    func addAttributes(_ attributes: [NSAttributedString.Key: Any]) {
        self.addAttributes(attributes, range: NSRange(location: 0, length: self.length))
    }
}
extension String {
    func attributedStringWithAttachment(view: UILabel, bounds: CGRect, font: UIFont,range: NSRange) -> NSAttributedString {
        
        let mutableAttributedString = NSMutableAttributedString(string: Constants.empty)
        let rightAttachment  = TextSubviewAttachment(view: view, size: CGSize(width: bounds.width, height: bounds.height))
        
        rightAttachment.bounds = bounds
        
        let rightAttachmentStr = NSAttributedString(attachment: rightAttachment)
        
        mutableAttributedString.append(NSAttributedString(string: self))
        mutableAttributedString.replaceCharacters(in: range, with: rightAttachmentStr)
        let nrange = NSRange(location: .zero, length: mutableAttributedString.length - 1)
        
        mutableAttributedString.addAttributes([.font: font], range: nrange)
        
        return mutableAttributedString
    }
    
    func customAttributedStringWithAttachment(view: UIView?, bounds: CGRect, font: UIFont,range: NSRange) -> NSAttributedString {
        
        let mutableAttributedString = NSMutableAttributedString(string: Constants.empty)
        let rightAttachment  = TextSubviewAttachment(view: view ?? UIView(), size: CGSize(width: bounds.width, height: bounds.height))
        
        rightAttachment.bounds = bounds
        
        let rightAttachmentStr = NSAttributedString(attachment: rightAttachment)
        
        mutableAttributedString.append(NSAttributedString(string: self))
        mutableAttributedString.append(NSAttributedString(string: Constants.whiteSpace))
        mutableAttributedString.insert(rightAttachmentStr, at: range.location)
        
        let nrange = NSRange(location: .zero, length: mutableAttributedString.length - 1)
        
        mutableAttributedString.addAttributes([.font: font], range: nrange)
        
        return mutableAttributedString
    }
    
    func customAttributedStringWithAttachmentInEnd(view: UIView?, bounds: CGRect, font: UIFont) -> NSAttributedString {
        
        let mutableAttributedString = NSMutableAttributedString(string: Constants.empty)
        let rightAttachment  = TextSubviewAttachment(view: view!, size: CGSize(width: bounds.width, height: bounds.height))
        
        rightAttachment.bounds = bounds
        
        let rightAttachmentStr = NSAttributedString(attachment: rightAttachment)
        
        mutableAttributedString.append(NSAttributedString(string: self))
        mutableAttributedString.append(rightAttachmentStr)
        mutableAttributedString.append(NSAttributedString(string: Constants.whiteSpace))
        let range = NSRange(location: 0, length: mutableAttributedString.length - 1)
        
        mutableAttributedString.addAttributes([.font: font], range: range)
        
        return mutableAttributedString
    }
}
extension UITextView {
    
    private enum Constant {
        // Padding value basically help us to determine when the String word needs to be divided and pushed into the next line in order to display the words correctly (without breaking the word's character to next line). This value is the sum of left, right margin and some extra value of UI component with respect to main screen.
        static let padding: CGFloat = 140
    }
    
    func setCircleLabelTextAttachment(text: String, label: UILabel, bounds: CGRect,range: NSRange) {
        let attributedText = text.attributedStringWithAttachment(view: label, bounds: bounds, font: label.font, range: range)
        self.attributedText = attributedText
    }
    
    func setTextAttachment(text: String, view: UIView, bounds: CGRect, font: UIFont = UIFont.systemFont(ofSize: 14), range: NSRange) {
        let attributedText = text.customAttributedStringWithAttachment(view: view, bounds: bounds, font: font, range: range)
        self.attributedText = attributedText
    }
    
    func setTextAttachmentInTheEnd(text: String, view: UIView, bounds: CGRect, maxWidth: CGFloat = UIScreen.main.bounds.width - Constant.padding, font: UIFont = UIFont.systemFont(ofSize: 14)) {
        let attributedText = text.customAttributedStringWithAttachmentInEnd(view: view, bounds: bounds, font: font)
        
        if attributedText.size().width > maxWidth {
            
            guard let lastWord = text.components(separatedBy: Constants.whiteSpace).last else { return }
            
            let attributedLastWord = lastWord.customAttributedStringWithAttachmentInEnd(view: view, bounds: bounds, font: font)
            
            if attributedLastWord.size().width < maxWidth {
                
                var fixedText = text
                let newLineIndex = text.index(text.endIndex, offsetBy: -lastWord.count)
                fixedText.insert(contentsOf: Constants.newLine, at: newLineIndex)
                self.attributedText = fixedText.customAttributedStringWithAttachmentInEnd(view: view, bounds: bounds, font: font)
            } else {
                self.attributedText = attributedText
            }
        } else {
            self.attributedText = attributedText
        }
    }
    
    func convertPointToTextContainer(_ point: CGPoint) -> CGPoint {
        let insets = self.textContainerInset
        return CGPoint(x: point.x - insets.left, y: point.y - insets.top)
    }
    
    func convertPointFromTextContainer(_ point: CGPoint) -> CGPoint {
        let insets = self.textContainerInset
        return CGPoint(x: point.x + insets.left, y: point.y + insets.top)
    }
    
    func convertRectToTextContainer(_ rect: CGRect) -> CGRect {
        let insets = self.textContainerInset
        return rect.offsetBy(dx: -insets.left, dy: -insets.top)
    }
    
    func convertRectFromTextContainer(_ rect: CGRect) -> CGRect {
        let insets = self.textContainerInset
        return rect.offsetBy(dx: insets.left, dy: insets.top)
    }
}

extension UIViewController {
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constants.alertOk, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIStoryboard {
    func instantiateVC<T: UIViewController>() -> T? {
        if let name = NSStringFromClass(T.self).components(separatedBy: Constants.dot).last {
            return instantiateViewController(withIdentifier: name) as? T
        }
        return nil
    }
}

extension UILabel {
    func size() -> CGSize {
        var rect: CGRect = self.frame
        rect.size = self.text?.size(withAttributes: [NSAttributedString.Key.font: self.font ?? 0]) ?? .zero
        return rect.size
    }
}

extension Int {
    static let valueHalf = 0.5
    static let valueOne = 1
    static let valueTwo = 2
    static let valueFour = 4
    static let valueFive = 5
}

extension AppDelegate {
    func hideBackButtonTitle()  {
        let barButtonItemAppearance = UIBarButtonItem.appearance()
        barButtonItemAppearance.setTitleTextAttributes([.foregroundColor: UIColor.clear], for: .normal)
    }
}

extension UIColor {
    static let primary: UIColor = .init(red: 0, green: 59/255, blue: 113/255, alpha: 1.0)
}

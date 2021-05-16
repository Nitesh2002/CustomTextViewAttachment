//
//  StaticData.swift
//  TextViewWithAttachment
//
//  Created by Nitesh on 01/05/21.
//

import Foundation
import UIKit

struct AttachmentList {
    var rows: [ListItem] = [ListItem(name: Constants.customeViewAttachment, type: .customView, shapeList: []),ListItem(name: Constants.shapeAttachment, type: .shaped, shapeList: [ShapeListItem(name: ShapeName.Circle.rawValue, type: .circle),ShapeListItem(name: ShapeName.Square.rawValue, type: .square)])]
}

struct ListItem {
    var name: String
    var type: AttachmentType
    var shapeList: [ShapeListItem]
}

struct ShapeListItem {
    var name: String
    var type: Shape
}

struct AttachmentInfo {
    var text: String
    var attachmentText: String
}

enum AttachmentType {
    case shaped
    case customView
}

enum Shape {
    case square
    case circle
}

enum ShapeName: String {
    case Circle
    case Square = "Square/Rectangle"
}

enum ScreenTitle: String {
    case List
    case Entry
    case View
    
    func GetTitle() -> String {
        switch self {
        case .List:
            return "Attachment List"
        case .Entry:
            return "Attachment Entry"
        case .View:
            return "Attachment"
        }
    }
}

enum Constants {
    static let empty = ""
    static let whiteSpace = " "
    static let doubleWhiteSpace = "  "
    static let dot = "."
    static let newLine = "\n"
    static let paragraphSeparator = "\u{2029}"
    
    static let estimatedRowHeight: CGFloat = 60
    static let squareCornerRadius: CGFloat = 5
    
    static let alertTitle = "TextViewAttachment"
    static let alertOk = "OK"
    static let tappedOnAttachmentMessage = "Tapped on Attachment"
    static let tappedOnTextMessage = "Tapped on TextView's text"
    
    static let actionSheetCancel = "Cancel"
    static let actionSheetOption = "Please Select Shape"
    static let actionSheetTitle = "Attachment"
    static let minRangeActionSheetTitle = "Min Range"
    static let maxRangeActionSheetTitle = "Max Range"
    
    
    static let defaultTextViewText = "There are 12 tasks you can take care of while you’re here today."
    static let defaultCustomAttachmentTextViewText = "This is the text attachment with custom UIView Component."
    static let defaultAttachmentText = "12"
    static let validRangeMessage = "Please select valid range"
    static let emptyMessage = "Please enter the attachment text."
    static let attachmentMismatchMessage = "Attachment text you entered does not belongs to the full text."
    
    
    
    static let customeViewAttachment =  "Custom View Attachment"
    static let shapeAttachment = "Shaped Attachment"
    
    static let listcell = "listCell"
    static let attachmentCell = "AttachmentCell"
    
    static let controlleDidNotFound = "Controller did not found"
    
    static let infoImage = "info"
}

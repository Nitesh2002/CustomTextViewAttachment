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
    
    static let actionSheetCancel = "Cancel"
    static let actionSheetOption = "Please Select Shape"
    static let actionSheetTitle = "Attachment"
    
    
    static let defaultTextViewText = "There are 12 tasks you can take care of while you’re here today."
    static let defaultAttachmentText = "12"
    
    static let customeViewAttachment =  "Custom View Attachment"
    static let shapeAttachment = "Shaped Attachment"
    
    static let listcell = "listCell"
    static let attachmentCell = "AttachmentCell"
    
    static let controlleDidNotFound = "Controller did not found"
}

//
//  StaticData.swift
//  TextViewWithAttachment
//
//  Created by Nitesh on 01/05/21.
//

import Foundation
import UIKit

struct AttachmentList {
    var rows: [ListItem] = [ListItem(name: Constants.customeViewAttachment, type: .customView, shapeList: []),ListItem(name: "Shaped Attachment", type: .shaped, shapeList: [ShapeListItem(name: "Circle", type: .circle),ShapeListItem(name: "Square/Rectangle", type: .square)])]
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

enum AttachmentType {
    case shaped
    case customView
}

enum Shape {
    case square
    case circle
}

enum Constants {
    static let empty = ""
    static let whiteSpace = " "
    static let doubleWhiteSpace = "  "
    static let dot = "."
    static let newLine = "\n"
    static let paragraphSeparator = "\u{2029}"
    static let defaultTextViewText = "There are 12 tasks you can take care of while you’re here today."
    static let attachmentCell = "AttachmentCell"
    static let estimatedRowHeight: CGFloat = 60
    static let squareCornerRadius: CGFloat = 5
    static let alertTitle = "TextViewAttachment"
    static let actionSheetCancel = "Cancel"
    static let alertOk = "OK"
    
    static let customeViewAttachment =  "Custom View Attachment"
    
    static let listcell = "listCell"
    
    static let attachment = "Attachment"
    static let actionSheetOption = "Please Select Shape"
    
    static let controlleDidNotFound = "Controller did not found"
}

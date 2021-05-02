//
//  ListTableViewCell.swift
//  TextViewWithAttachment
//
//  Created by Nitesh on 01/05/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIStackView!
    @IBOutlet weak var attachmentTypeLabel: UILabel!
    
    func configureCell()  {
        attachmentTypeLabel.adjustsFontForContentSizeCategory = true
        attachmentTypeLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        containerView.layoutIfNeeded()
    }
}

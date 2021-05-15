//
//  ListTableViewCell.swift
//  TextViewWithAttachment
//
//  Created by Nitesh on 01/05/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var attachmentTypeLabel: UILabel!
    
    func configureCell()  {
        attachmentTypeLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        attachmentTypeLabel.adjustsFontForContentSizeCategory = true
    }
}

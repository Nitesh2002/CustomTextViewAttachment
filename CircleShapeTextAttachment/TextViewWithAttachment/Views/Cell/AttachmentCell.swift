

import UIKit

class AttachmentCell: UITableViewCell {
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var titleTextView: AttachmentTextView!
    
    var textTapped: (() -> Void)?
    var attachmentTapped: (() -> Void)?
    
    private lazy var attachmentButton: UIButton = {
        
        let button = UIButton()
        button.setImage(UIImage(named: "info"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(attachmentButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    private lazy var attachmentLabel: UILabel = {
        
        let label = UILabel()
        label.backgroundColor = .white
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textColor = containerView.backgroundColor
        label.textAlignment = .center
        return label
        
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleTextView.backgroundColor = .clear
    }
    
    @objc private func containerTapped() {
        textTapped?()
    }
    
    @objc private func attachmentButtonTapped() {
        attachmentTapped?()
    }
    
    func addTextAttachment(text: String, count:String, shape:Shape) {
        
        if text.contains(count) {
            
            let replacingText = count + Constants.doubleWhiteSpace
            attachmentLabel.accessibilityLabel = Constants.empty
            attachmentLabel.text = replacingText
            
            let displaytext = text.replacingOccurrences(of: count, with: replacingText)
            titleTextView.addShapeLabelTextAttachment(text: displaytext, label: attachmentLabel, shapeType: shape)
            
        } else {
            
            titleTextView.text = text
        }
        
        setUpCell(text: text)
    }
    
    private func setUpCell(text: String) {
        containerView.layoutIfNeeded()
        
        titleTextView.isAccessibilityElement = true
        titleTextView.font = UIFont.preferredFont(forTextStyle: .headline)
        titleTextView.adjustsFontForContentSizeCategory = true
        
        containerView.isAccessibilityElement = false
        containerView.accessibilityElements = [titleTextView as Any]
        
        titleTextView.accessibilityValue = Constants.empty
        titleTextView.accessibilityLabel = text
        
        titleTextView.tintColor = .white
        titleTextView.textColor = .white
    }
}


// MARK: - Constants

extension AttachmentCell {
    
    private enum Constant {
        static let height: CGFloat = 48
    }
}

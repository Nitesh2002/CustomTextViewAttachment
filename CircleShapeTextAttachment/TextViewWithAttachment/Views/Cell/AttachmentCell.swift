

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
        label.backgroundColor = .systemPink
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
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
    
    func addTextAttachment(text: String,count:String) {
        attachmentLabel.accessibilityLabel = Constants.empty
        attachmentLabel.text = count
        titleTextView.addCircleLabelTextAttachment(text: text, label: attachmentLabel)
        setUpCell()
        
        titleTextView.accessibilityValue = Constants.empty
        titleTextView.accessibilityLabel = text
        titleTextView.tintColor = .white
        titleTextView.textColor = .white
    }
    
    private func setUpCell() {
        containerView.layoutIfNeeded()
        titleTextView.isAccessibilityElement = true
        titleTextView.font = UIFont.preferredFont(forTextStyle: .headline)
        titleTextView.adjustsFontForContentSizeCategory = true
        containerView.isAccessibilityElement = false
        containerView.accessibilityElements = [titleTextView as Any]
    }
}


// MARK: - Constants

extension AttachmentCell {
    private enum Constant {
        static let height: CGFloat = 48
    }
}


extension UILabel {
    func size() -> CGSize {
        var rect: CGRect = self.frame
        rect.size = self.text?.size(withAttributes: [NSAttributedString.Key.font: self.font ?? 0]) ?? .zero
        return rect.size
    }
}


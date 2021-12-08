//
//  CollectionViewCell.swift
//  ComparationTest
//
//  Created by gssolovev on 06.12.2021.
//

import Foundation
import UIKit

final class CollectionViewCell: UICollectionViewCell {
    private let label = UILabel()
    private let button = UIButton()
    private var isLockEnabled: Bool = false
    private var onTap: ((Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = .systemFont(ofSize: 36)
        contentView.addSubview(label)
        contentView.addSubview(button)
        button.imageView?.contentMode = .scaleToFill
        
        backgroundColor = .white
        
        button.setImage(UIImage(named: "lock"), for: .normal)
        button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                contentView.leftAnchor.constraint(equalTo: label.leftAnchor, constant: -4),
                contentView.topAnchor.constraint(equalTo: label.topAnchor, constant: -2),
                contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
                contentView.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 4),
                
                label.heightAnchor.constraint(equalToConstant: 22),
                label.widthAnchor.constraint(equalToConstant: 22),
                contentView.topAnchor.constraint(equalTo: button.topAnchor, constant: -2),
                contentView.rightAnchor.constraint(equalTo: button.rightAnchor, constant: 2)
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(text: String, isLockVisible: Bool, isLockEnabled: Bool, onTap: @escaping (Bool) -> Void) {
        button.setImage(nil, for: .normal)
        label.text = text
        button.isHidden = !isLockVisible
        self.isLockEnabled = isLockEnabled
        if isLockEnabled {
            button.setImage(UIImage(named: "lock"), for: .normal)
            button.imageView?.tintColor = .blue
        } else {
            button.setImage(UIImage(named: "lock"), for: .normal)
            button.imageView?.tintColor = .gray
        }
        self.onTap = onTap
    }
    
    @objc func onButtonTap() {
        onTap?(isLockEnabled)
        button.setImage(UIImage(named: "lock"), for: .normal)
        button.imageView?.tintColor = .blue
    }
}

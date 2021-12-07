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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = .systemFont(ofSize: 36)
        contentView.addSubview(label)
        
        backgroundColor = .white
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                contentView.leftAnchor.constraint(equalTo: label.leftAnchor, constant: -4),
                contentView.topAnchor.constraint(equalTo: label.topAnchor, constant: -2),
                contentView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
                contentView.rightAnchor.constraint(equalTo: label.rightAnchor, constant: 4)
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(text: String) {
        label.text = text
    }
}

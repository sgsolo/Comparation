//
//  HeaderView.swift
//  ComparationTest
//
//  Created by gssolovev on 06.12.2021.
//

import Foundation
import UIKit

final class HeaderView: UICollectionReusableView {
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        
        backgroundColor = .gray
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                leftAnchor.constraint(equalTo: label.leftAnchor, constant: -4),
                topAnchor.constraint(equalTo: label.topAnchor, constant: -2),
                bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
                rightAnchor.constraint(equalTo: label.rightAnchor, constant: 4)
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

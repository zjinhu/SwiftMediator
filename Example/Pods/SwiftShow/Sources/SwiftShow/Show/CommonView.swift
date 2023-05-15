//
//  CommonView.swift
//  SwiftShow
//
//  Created by 狄烨 on 2022/6/6.
//  Copyright © 2022 iOS. All rights reserved.
//

import Foundation
import UIKit

public class CommonView : UIStackView {
    
    lazy var imageView: UIImageView = {
        let vi = UIImageView()
        vi.contentMode = .scaleAspectFit
        return vi
    }()
    
    lazy var titleLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 14, weight: .bold)
        lab.numberOfLines = 2
        return lab
    }()
    
    lazy var subtitleLabel: UILabel = {
        let lab = UILabel()
        lab.font = .systemFont(ofSize: 12, weight: .bold)
        lab.numberOfLines = 0
        lab.textColor = .systemGray
        return lab
    }()
    
    public init(title: String? = nil,
                subtitle: String? = nil,
                image: UIImage? = nil,
                imageType : ImageLayoutType = .top,
                spaceImage: CGFloat = 5,
                spaceText: CGFloat = 5) {
        
        super.init(frame: CGRect.zero)
        
        axis = imageType == .left ? .horizontal : .vertical
        spacing = image != nil && title != nil ? spaceImage : 0
        alignment = .center
        distribution = .fill
        
        if let image = image{
            imageView.image = image
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: 28),
                imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 28)
            ])
            addArrangedSubview(imageView)
        }
        if let title = title {
            let vStack = UIStackView()
            vStack.axis = .vertical
            vStack.spacing = subtitle?.count == 0 ? 0 : spaceText
            vStack.alignment = .center
            
            titleLabel.text = title
            vStack.addArrangedSubview(titleLabel)
            
            if let subtitle = subtitle {
                subtitleLabel.text = subtitle
                vStack.addArrangedSubview(subtitleLabel)
            }

            addArrangedSubview(vStack)
        }

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

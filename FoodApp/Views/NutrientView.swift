//
//  NutrientView.swift
//  FoodApp
//
//  Created by Timmy Nguyen on 3/25/24.
//

import UIKit

class NutrientView: UIView {
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var amountLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var unitLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    var textContainer: UIStackView = {
        let container = UIStackView()
        container.spacing = 1
        return container
    }()
    
    var container: UIStackView = {
        let container = UIStackView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.spacing = 2
        return container
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textContainer.addArrangedSubview(amountLabel)
        textContainer.addArrangedSubview(unitLabel)
        
        container.addArrangedSubview(iconImageView)
        container.addArrangedSubview(textContainer)
        
        self.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: self.topAnchor),
            container.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(amount: Float, unit: String, iconImage: UIImage?, tintColor: UIColor) {
        var config = UIImage.SymbolConfiguration(pointSize: 12)
        let colors: [UIColor] = [.label, tintColor]
        config = config.applying(UIImage.SymbolConfiguration(paletteColors: colors))
        iconImageView.image = iconImage?.withConfiguration(config)
        
        amountLabel.text = "\(Int(amount))"
        unitLabel.text = unit
    }
}

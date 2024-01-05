//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Akbar Khusanbaev on 05/01/24.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    let regionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let conditionIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let learnMore: UILabel = {
        let lbl = UILabel()
        lbl.text = "Learn More ➡️"
        lbl.textColor = .systemBlue
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }
    
    private func setupViews() {
        addSubview(regionLabel)
        addSubview(temperatureLabel)
        addSubview(conditionIconImageView)
        addSubview(learnMore)

        // Constraints
        NSLayoutConstraint.activate([
            regionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            regionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            regionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            temperatureLabel.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 4),
            temperatureLabel.leadingAnchor.constraint(equalTo: regionLabel.leadingAnchor),

            conditionIconImageView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 4),
            conditionIconImageView.leadingAnchor.constraint(equalTo: regionLabel.leadingAnchor),
            conditionIconImageView.widthAnchor.constraint(equalToConstant: 30),
            conditionIconImageView.heightAnchor.constraint(equalToConstant: 30),
            conditionIconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            learnMore.centerYAnchor.constraint(equalTo: centerYAnchor),
            learnMore.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}

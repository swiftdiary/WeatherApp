//
//  DetailsTableViewCell.swift
//  WeatherApp
//
//  Created by Akbar Khusanbaev on 05/01/24.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let temperatureLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .boldSystemFont(ofSize: 20)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let iconImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(temperatureLabel)
        addSubview(iconImage)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: frame.width/2),
            
            temperatureLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            temperatureLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: iconImage.leadingAnchor, constant: -10),
            
            iconImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            iconImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 30),
            iconImage.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let data = data, error == nil else { return }

            DispatchQueue.main.async { [weak self] in
                self?.iconImage.image = UIImage(data: data)
            }
        }.resume()
    }
}

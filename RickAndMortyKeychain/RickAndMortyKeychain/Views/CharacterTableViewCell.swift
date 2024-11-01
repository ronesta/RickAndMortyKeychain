//
//  CharacterTableViewCell.swift
//  RickAndMortyKeychain
//
//  Created by Ибрагим Габибли on 01.11.2024.
//

import UIKit
import SnapKit

final class CharacterTableViewCell: UITableViewCell {
    static let id = "CharacterTableViewCell"

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    private let speciesAndGenderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    private let watchEpisodesButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 13
        button.backgroundColor = .orange.withAlphaComponent(0.1)
        button.setTitleColor(UIColor.orange, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.titleLabel?.textAlignment = .center
        button.clipsToBounds = true
        return button
    }()

    private let markerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black.withAlphaComponent(0.7)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    private let statusLabel: CustomUILabel = {
        let label = CustomUILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        customizeCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
    }

    private func customizeCell() {
        contentView.addSubview(activityIndicator)
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(speciesAndGenderLabel)
        contentView.addSubview(watchEpisodesButton)
        contentView.addSubview(markerImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(statusLabel)

        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalTo(characterImageView)
        }

        characterImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(17)
            make.height.equalTo(100)
            make.width.equalTo(characterImageView.snp.height)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView)
            make.leading.equalTo(characterImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(100)
        }

        speciesAndGenderLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(2.5)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().inset(10)
        }

        watchEpisodesButton.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(speciesAndGenderLabel.snp.bottom).offset(8)
            make.width.equalTo(130)
            make.height.equalTo(29)
        }

        markerImageView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(characterImageView).inset(2.5)
            make.height.width.equalTo(11)
        }

        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(markerImageView.snp.trailing).offset(3.5)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(characterImageView)
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImageView)
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(25)
        }
    }

    private func applyBlackAndWhiteFilter(to image: UIImage) -> UIImage? {
        guard let currentCIImage = CIImage(image: image) else {
            return nil
        }

        let filter = CIFilter(name: "CIColorMonochrome")
        filter?.setValue(currentCIImage, forKey: "inputImage")
        filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
        filter?.setValue(1.0, forKey: "inputIntensity")

        guard let outputImage = filter?.outputImage,
              let cgImage = CIContext().createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }

    func configure(with character: Character, image: UIImage?) {
        activityIndicator.startAnimating()
        characterImageView.image = image
        nameLabel.text = character.name
        speciesAndGenderLabel.text = "\(character.species), \(character.gender)"
        watchEpisodesButton.setTitle("▶ Watch episodes", for: .normal)
        markerImageView.image = UIImage(named: "marker")
        locationLabel.text = character.location.name
        statusLabel.text = character.status

        switch character.status {
        case "Dead":
            let filteredImage = self.applyBlackAndWhiteFilter(to: image ?? UIImage())
            characterImageView.image = filteredImage
            statusLabel.backgroundColor = .red.withAlphaComponent(0.1)
            statusLabel.textColor = .systemRed
        case "unknown":
            statusLabel.backgroundColor = .gray.withAlphaComponent(0.1)
            statusLabel.textColor = .systemGray
        default:
            statusLabel.backgroundColor = .green.withAlphaComponent(0.2)
            statusLabel.textColor = UIColor(red: 34/255, green: 139/255, blue: 34/255, alpha: 1)
        }
    }
}

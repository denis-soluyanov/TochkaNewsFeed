//
//  NewsFeedCell.swift
//  TochkaNewsFeed
//
//  Created by den on 22.02.2020.
//  Copyright © 2020 Denis Soluyanov. All rights reserved.
//

import UIKit

final class NewsFeedCell: UITableViewCell {
    
    var viewModel: NewsFeedCellViewModel! {
        didSet(viewModel) {
            bindViewModel()
        }
    }
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var previewImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(previewImageView)
        contentView.addSubview(activityIndicator)
        
        setConstraintsForPreviewImageView(size: CGSize(width: 100, height: 100))
        setConstraintsForTitleLabel()
        setConstraintsForDescriptionLabel()
        setConstraintsForActivityIndicator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraintsForPreviewImageView(size: CGSize) {
        previewImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10)
            .isActive = true
        previewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            .isActive = true
        previewImageView.widthAnchor.constraint(equalToConstant: size.width)
            .isActive = true
        previewImageView.heightAnchor.constraint(equalToConstant: size.height)
            .isActive = true
    }
    
    private func setConstraintsForTitleLabel() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
            .isActive = true
        titleLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 10)
            .isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
            .isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20)
            .isActive = true
    }
    
    private func setConstraintsForDescriptionLabel() {
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
            .isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 10)
            .isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
            .isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
            .isActive = true
    }
    
    private func setConstraintsForActivityIndicator() {
        activityIndicator.centerYAnchor.constraint(equalTo: previewImageView.centerYAnchor)
            .isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: previewImageView.centerXAnchor)
            .isActive = true
    }
    
    private func bindViewModel() {
        viewModel.title.bind { [unowned self] in
            self.titleLabel.text = $0
        }
        viewModel.description.bind { [unowned self] in
            self.descriptionLabel.text = $0
        }
        previewImageView.isImageLoaded.bind { [unowned self] in
            $0 ? self.activityIndicator.stopAnimating()
               : self.activityIndicator.startAnimating()
        }
        viewModel.imageURL.bind { [unowned self] in
            self.previewImageView.setImage(from: $0)
        }
    }
}

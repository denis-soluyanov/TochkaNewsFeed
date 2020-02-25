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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
//        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private lazy var previewImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
//        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
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
        
        activityIndicator.startAnimating()
    }
    
    override func layoutSubviews() {
//        if previewImageView.image == nil {
//            activityIndicator.startAnimating()
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NewsFeedCell {
    
    func setConstraintsForPreviewImageView(size: CGSize) {
        previewImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10)
            .isActive = true
        previewImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            .isActive = true
        previewImageView.widthAnchor.constraint(equalToConstant: size.width)
            .isActive = true
        previewImageView.heightAnchor.constraint(equalToConstant: size.height)
            .isActive = true
    }
    
    func setConstraintsForTitleLabel() {
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
            .isActive = true
        titleLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 10)
            .isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
            .isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30)
            .isActive = true
    }
    
    func setConstraintsForDescriptionLabel() {
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)
            .isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 10)
            .isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
            .isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
            .isActive = true
    }
    
    func setConstraintsForActivityIndicator() {
        activityIndicator.centerXAnchor.constraint(equalTo: previewImageView.centerXAnchor)
            .isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: previewImageView.centerYAnchor)
            .isActive = true
    }
    
    func bindViewModel() {
        viewModel.title.bind { [weak self] in
            self?.titleLabel.text = $0
        }
        viewModel.description.bind { [weak self] in
            self?.descriptionLabel.text = $0
        }
        viewModel.imageURL.bind { [weak self] in
            self?.previewImageView.setImage(from: $0)
            self?.activityIndicator.stopAnimating()
        }
    }
}

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
        willSet(viewModel) {
            bindViewModel()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(previewImageView)
        
        setConstraintsForPreviewImageView(size: CGSize(width: 100, height: 100))
        setConstraintsForTitleLabel()
        setConstraintsForDescriptionLabel()
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
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
            .isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: previewImageView.rightAnchor, constant: 10)
            .isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10)
            .isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 10)
            .isActive = true
    }
    
    func bindViewModel() {
        viewModel.title.bind { [weak self] in
            self?.titleLabel.text = $0
        }
        viewModel.description.bind { [weak self] in
            self?.descriptionLabel.text = $0
        }
        viewModel.image.bind { [weak self] in
            self?.previewImageView.image = $0
        }
    }
}

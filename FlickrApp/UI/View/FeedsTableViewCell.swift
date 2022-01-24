//
//  FeedsTableViewCell.swift
//  FlickrApp
//
//  Created by Tomashchik Daniil on 23/01/2022.
//
import UIKit

protocol FeedsTableViewCellDelegate: AnyObject {
    func pressButton(_ url: String)
}

final class FeedsTableViewCell: UITableViewCell {
    //MARK: - Private properties
    private var imageview: UIImageView!
    private var titleLabel: UILabel!
    private var seeMoreButton: UIButton!
    
    //MARK: - Internal properties
    weak var delegate: FeedsTableViewCellDelegate?
    
    var model: Model? {
        didSet {
            guard let model = model else {
                return
            }
            
            setImage(from: model.image)
            titleLabel.text = model.title
        }
    }
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        comminInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FeedsTableViewCell {
    //MARK: - Private methods
    func comminInit() {
        backgroundColor = .white
        
        titleLabel = .init()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: Constants.fontSize)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        imageview = .init()
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.layer.cornerRadius = Constants.cornerRadius
        
        contentView.addSubview(imageview)
        
        imageview.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        imageview.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        imageview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageview.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        seeMoreButton = .init()
        seeMoreButton.translatesAutoresizingMaskIntoConstraints = false
        seeMoreButton.backgroundColor = .systemGray
        seeMoreButton.layer.cornerRadius = Constants.cornerRadius
        seeMoreButton.setTitle(Constants.buttonTitle, for: .normal)
        seeMoreButton.addTarget(self, action: #selector(pressMoreButton), for: .touchUpInside)
        
        contentView.addSubview(seeMoreButton)
        
        seeMoreButton.topAnchor.constraint(equalTo: imageview.bottomAnchor, constant: 20).isActive = true
        seeMoreButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        seeMoreButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        seeMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30).isActive = true
        seeMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30).isActive = true
    }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else {
            return
            
        }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else {
                return
            }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.imageview.image = image
            }
        }
    }
    
    @objc func pressMoreButton() {
        guard let link = model?.link else {
            return
        }
        
        delegate?.pressButton(link)
    }
}

extension FeedsTableViewCell {
    //MARK: - Model
    struct Model {
        var title: String
        var link: String
        var image: String
        
        init(title: String, link: String, image: String) {
            self.title = title
            self.link = link
            self.image = image
        }
    }
}

private extension FeedsTableViewCell {
    //MARK: - Constants
    struct Constants {
        static let buttonTitle = "More info"
        static let cornerRadius = CGFloat(5)
        static let fontSize = CGFloat(20)
    }
}

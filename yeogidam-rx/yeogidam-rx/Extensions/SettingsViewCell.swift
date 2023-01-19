//
//  SettingsViewCell.swift
//  yeogidam-rx
//
//  Created by 이강욱 on 2023/01/20.
//

import Foundation
import UIKit

class SettingsViewCell: UITableViewCell {
    static let identifier = "SettingsViewCell"
    let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .black
        return label
    }()
    let arrowImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrow_navigation"))
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConstraints() {
        self.addSubview(label)
        self.addSubview(arrowImage)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(20)
        }
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(16)
            make.trailing.equalTo(-20)
        }
    }
    
}

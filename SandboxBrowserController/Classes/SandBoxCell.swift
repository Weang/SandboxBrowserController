//
//  SandBoxCell.swift
//  SandboxBrowserController
//
//  Created by Mr.Wang on 2020/1/6.
//

import UIKit

class SandBoxCell: UITableViewCell {

    let fileImageView = UIImageView()
    let nameLabel = UILabel()
    let createTimeLabel = UILabel()
    let selectButton = UIButton()
    
    var selectButtonClosure: (Bool) -> () = {_ in }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        fileImageView.contentMode = .scaleAspectFill
        fileImageView.clipsToBounds = true
        fileImageView.contentMode = .scaleAspectFit
        contentView.addSubview(fileImageView)
        fileImageView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.top.equalTo(8)
            make.bottom.equalTo(-8)
            make.width.equalTo(fileImageView.snp.height)
        }
        
        selectButton.isUserInteractionEnabled = false
        selectButton.isHidden = true
        selectButton.setImage(UIImage.init(named: "file_normal"), for: .normal)
        selectButton.setImage(UIImage.init(named: "file_selected"), for: .selected)
        contentView.addSubview(selectButton)
        selectButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
            make.left.equalTo(10)
        }
        
        nameLabel.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fileImageView.snp.top).offset(3)
            make.left.equalTo(fileImageView.snp.right).offset(10)
            make.right.equalTo(-5)
        }
        
        createTimeLabel.font = UIFont.systemFont(ofSize: 13)
        createTimeLabel.textColor = UIColor.lightGray
        contentView.addSubview(createTimeLabel)
        createTimeLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(fileImageView.snp.bottom).offset(-2)
            make.left.equalTo(fileImageView.snp.right).offset(10)
            make.right.equalTo(-5)
        }
        
        let sepator = UIView()
        sepator.backgroundColor = #colorLiteral(red: 0.8913096786, green: 0.8913096786, blue: 0.8913096786, alpha: 1)
        contentView.addSubview(sepator)
        sepator.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.left.equalTo(fileImageView.snp.left)
            make.height.equalTo(1 / UIScreen.main.scale)
        }
        
    }
    
    func setEditind(_ editing: Bool) {
        if selectButton.isHidden == editing {
            fileImageView.snp.updateConstraints { (make) in
                make.left.equalTo(editing ? 45 : 10)
            }
            selectButton.isHidden = !editing
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectButton.isSelected = selected
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

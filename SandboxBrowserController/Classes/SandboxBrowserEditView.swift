//
//  SandboxBrowserEditView.swift
//  SandboxBrowserController
//
//  Created by Mr.Wang on 2020/1/6.
//

import UIKit

class SandboxBrowserEditView: UIView{
    
    let selectButton = NoHighlightButton()
    let deleteButton = UIButton()
    
    var selectClosure: (Bool) -> () = {_ in}
    var deleteClosure: () -> () = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9178532958, green: 0.9178532958, blue: 0.9178532958, alpha: 1)
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        selectButton.setTitleColor(.darkGray, for: .normal)
        selectButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        selectButton.setTitle("全选", for: .normal)
        selectButton.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: -8)
        selectButton.setImage(BundleHelper.imageNamed("file_selected"), for: .selected)
        selectButton.setImage(BundleHelper.imageNamed("file_normal"), for: .normal)
        selectButton.addTarget(self, action: #selector(selectClick), for: .touchUpInside)
        self.addSubview(selectButton)
        selectButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.height.equalTo(26)
            make.width.equalTo(58)
            make.centerY.equalTo(self.snp.top).offset(25)
        }
        
        deleteButton.layer.cornerRadius = selectButton.layer.cornerRadius
        deleteButton.setTitleColor(.red, for: .normal)
        deleteButton.setTitleColor(.lightGray, for: .disabled)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        deleteButton.addTarget(self, action: #selector(deletetClick), for: .touchUpInside)
        deleteButton.setTitle("删除", for: .normal)
        deleteButton.setTitle("删除", for: .disabled)
        deleteButton.isEnabled = false
        self.addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.right.equalTo(-13)
            make.height.equalTo(selectButton.snp.height)
            make.centerY.equalTo(selectButton.snp.centerY)
        }
    }
    
    func setSelectCount(_ count: Int) {
        deleteButton.setTitle("删除 (\(count))", for: .normal)
        deleteButton.isEnabled = count > 0
    }
    
    @objc func selectClick() {
        selectButton.isSelected = !selectButton.isSelected
        selectClosure(selectButton.isSelected)
    }
    
    @objc func deletetClick() {
        deleteClosure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

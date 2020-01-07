//
//  SandboxBrowserController.swift
//  SandboxBrowserController
//
//  Created by Mr.Wang on 2020/1/6.
//

import UIKit
import SnapKit
import QuickLook

open class SandboxBrowserController: UIViewController {
    
    let tableView = UITableView.init(frame: .zero, style: .plain)
    
    let editButton = NoHighlightButton()
    let editView = SandboxBrowserEditView()
    
    let path: String
    var dataArray: [SandBoxModel] = []
    
    var isEditindFiles: Bool {
        return editButton.isSelected
    }
    
    public init(path: String, name: String) {
        self.path = path
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = name
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bindEvent()
        getData()
    }
    
    func setupView() {
        tableView.allowsMultipleSelection = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = 70
        tableView.register(SandBoxCell.self, forCellReuseIdentifier: "SandBoxCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        editButton.setTitle("编辑", for: .normal)
        editButton.setTitle("完成", for: .selected)
        editButton.setTitleColor(.black, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        editButton.addTarget(self, action: #selector(editButtonClick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: editButton)
        
        editView.isHidden = true
        self.view.addSubview(editView)
        editView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                make.height.equalTo(self.view.safeAreaInsets.bottom + 50)
            } else {
                make.height.equalTo(50)
            }
        }
    }
    
    func bindEvent() {
        editView.selectClosure = { [weak self] select in
            guard let self = self else { return }
            if select {
                (0..<self.dataArray.count)
                    .map{ IndexPath.init(row: $0, section: 0) }
                    .forEach {
                        self.tableView.selectRow(at: $0, animated: true, scrollPosition: .none)
                }
            } else {
                let selectedRows = self.tableView.indexPathsForSelectedRows ?? []
                selectedRows.forEach{
                    self.tableView.deselectRow(at: $0, animated: false)
                }
            }
            self.countSelectedRows()
        }
        
        editView.deleteClosure = { [weak self] in
            self?.deleteFiles()
        }
    }
    
    func deleteFiles() {
        let alert = UIAlertController.init(title: "确认删除", message: "删除后不可恢复，确认删除吗？", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "删除", style: .destructive, handler: { [weak self] (_) in
            guard let self = self,
                let selectedRows = self.tableView.indexPathsForSelectedRows else {
                    return
            }
            selectedRows.forEach{
                try? FileManager.default.removeItem(atPath: self.path + "/" + self.dataArray[$0.row].name)
            }
            self.getData()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func editButtonClick() {
        editButton.isSelected = !editButton.isSelected
        editView.isHidden = !editButton.isSelected
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: editButton.isSelected ? editView.bounds.size.height : 0, right: 0)
        if !editButton.isSelected {
            let selectedRows = tableView.indexPathsForSelectedRows ?? []
            selectedRows.forEach{
                tableView.deselectRow(at: $0, animated: false)
            }
            countSelectedRows()
        }
        tableView.reloadData()
    }
    
    func getData() {
        SandboxDataProvider.getFilesArray(at: path) { [weak self] (dataArray) in
            self?.dataArray = dataArray
            self?.tableView.reloadData()
            guard let self = self else { return }
            if self.editButton.isSelected {
                self.countSelectedRows()
            }
        }
    }
    
    func countSelectedRows() {
        let count = tableView.indexPathsForSelectedRows?.count ?? 0
        editView.selectButton.isSelected = dataArray.count == count
        editView.setSelectCount(count)
    }
}

extension SandboxBrowserController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if self.editButton.isSelected {
            countSelectedRows()
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditindFiles {
            countSelectedRows()
            return
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        let model = dataArray[indexPath.row]
        switch model.fileType {
        case .folder:
            let path = self.path + "/" + model.name
            let vc = SandboxBrowserController.init(path: path, name: model.name)
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = QLPreviewController()
            vc.view.backgroundColor = .clear
            vc.delegate = self
            vc.dataSource = self
            let fileArray = self.dataArray.filter{ $0.fileType != .folder }
            if let index = fileArray.firstIndex(where: { $0 == model }) {
                vc.currentPreviewItemIndex = index
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SandBoxCell") as? SandBoxCell else {
            fatalError()
        }
        let model = dataArray[indexPath.row]
        if model.fileType == .folder {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.accessoryType = .none
        }
        cell.setEditind(editButton.isSelected)
        if self.editButton.isSelected {
            cell.accessoryType = .none
        }
        cell.nameLabel.text = model.name
        cell.fileImageView.image = model.fileType.image
        cell.createTimeLabel.text = model.createTime + "    " + model.size
        return cell
    }
    
    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if isEditindFiles { return nil }
        
        let model = self.dataArray[indexPath.row]
        let viewController: UIViewController?
        
        switch model.fileType {
        case .folder:
            let path = self.path + "/" + model.name
            viewController = SandboxBrowserController.init(path: path, name: model.name)
        default:
            let previewVC = QLPreviewController()
            previewVC.delegate = self
            previewVC.dataSource = self
            let fileArray = self.dataArray.filter{ $0.fileType != .folder }
            if let index = fileArray.firstIndex(where: { $0 == model }) {
                previewVC.currentPreviewItemIndex = index
            }
            viewController = previewVC
        }
        return UIContextMenuConfiguration.init(identifier: nil, previewProvider: { () -> UIViewController? in
            return viewController
        })
    }
    
    @available(iOS 13.0, *)
    public func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        guard let viewController = animator.previewViewController else { return }
        animator.addAnimations {
            if viewController.isKind(of: SandboxBrowserController.self) {
                self.navigationController?.pushViewController(viewController, animated: true)
            } else {
                self.present(viewController, animated: true, completion: nil)
            }
        }
    }
    
}

extension SandboxBrowserController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return self.dataArray.filter{ $0.fileType != .folder }.count
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let dataArray = self.dataArray.filter{ $0.fileType != .folder }
        return NSURL.init(fileURLWithPath: path + "/" + dataArray[index].name)
    }
    
}

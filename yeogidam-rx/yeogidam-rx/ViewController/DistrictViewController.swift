//
//  DistrictViewController.swift
//  yeogidam-rx
//
//  Created by 이강욱 on 2023/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct Section {
    var isOpened = false
    var title: String
    var data: [String]
}

class DistrictViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var tableView = UITableView()
    private var sections: [Section] = [
        Section(title: "강남구", data: ["신사역", "압구정역", "강남역"].sorted()),
        Section(title: "광진구", data: ["구의역", "건대입구역", "강변역"].sorted()),
        Section(title: "노원구", data: ["월계역", "광운대역", "노원역", "석계역"].sorted())
    ]
    
    private var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ygdNavy
        // Do any additional setup after loading the view.
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        setNavigationBar()
        setConstraints()
    }
    private func setNavigationBar() {
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: view.frame.size.width, height:44))
        let navigationItem = UINavigationItem()
        navigationItem.title = "전체 목록"
        navigationBar.backgroundColor = .ygdNavy
        navigationBar.items = [navigationItem]
        
        // iOS15+에서 Navigation Bar 색상이 정상적으로 나오지 않을 때 처리
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ygdNavy
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        view.addSubview(navigationBar)
    }
    
    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(navigationBar.snp.bottom)
        }
    }
}

extension DistrictViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        if section.isOpened {
            return section.data.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        if indexPath.row == 0 {
            cell.label.text = sections[indexPath.section].title
            cell.label.font = .boldSystemFont(ofSize: 15)
            cell.arrowImage.image = UIImage(named: "arrow_expandable")
        } else {
            cell.label.text = sections[indexPath.section].data[indexPath.row - 1]
            cell.label.font = .systemFont(ofSize: 13)
            cell.arrowImage.image = nil
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            sections[indexPath.section].isOpened = !sections[indexPath.section].isOpened
            tableView.reloadSections([indexPath.section], with: .none)
        } else {
            print("tapped sub cells")
        }
        
    }
    
    
}


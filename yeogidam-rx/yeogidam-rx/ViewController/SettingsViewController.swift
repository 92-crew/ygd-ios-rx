//
//  SettingsViewController.swift
//  yeogidam-rx
//
//  Created by 이강욱 on 2023/01/08.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var tableView = UITableView()
    private var navigationBar: UINavigationBar!
    
    var data = ["공지사항", "알림설정", "개발자 문의", "서비스 정보", "앱 버전"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ygdNavy
        // Do any additional setup after loading the view.
        tableView.register(SettingsViewCell.self, forCellReuseIdentifier: "SettingsViewCell")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray5
        setNavigationBar()
        setConstraints()
    }
    private func setNavigationBar() {
        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: view.frame.size.width, height:44))
        let navigationItem = UINavigationItem()
        navigationItem.title = "환경 설정"
        navigationBar.backgroundColor = .ygdNavy
        navigationBar.items = [navigationItem]
        
        // iOS15+에서 Navigation Bar 색상이 정상적으로 나오지 않을 때 처리
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .ygdNavy
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
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

extension SettingsViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsViewCell", for: indexPath) as! SettingsViewCell
        if indexPath.row == 4 {
            cell.arrowImage.image = nil
        }
        cell.label.text = data[indexPath.row]
        return cell
    }
}

//
//  SettingsViewController.swift
//  yeogidam-rx
//
//  Created by 이강욱 on 2023/01/08.
//

import UIKit

class SettingsViewController: UIViewController {

    private var navigationBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .ygdNavy
        // Do any additional setup after loading the view.
        setNavigationBar()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  MainViewController.swift
//  yeogidam-rx
//
//  Created by 이강욱 on 2023/01/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import NMapsMap

class MainViewController: UIViewController, CLLocationManagerDelegate {
    let disposeBag = DisposeBag()
    
    var locationManager: CLLocationManager!
    var mapView: NMFMapView!
    var viewModel: MainViewModel!
    var locationOverlay: NMFLocationOverlay!
    
    let favoriteButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 0.5 * btn.bounds.width
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "button_favorite_unselected"), for: .normal)
        
        return btn
    }()
    let currentButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 0.5 * btn.bounds.width
        btn.clipsToBounds = true
        btn.setImage(UIImage(named: "button_current"), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewModel()
        initializeMapView()
        view.addSubview(mapView)
        view.addSubview(favoriteButton)
        view.addSubview(currentButton)
        setConstraints()
    }
    
    private func initializeMapView() {
        mapView = NMFMapView(frame: view.frame)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            print("GPS On")
            locationManager.startUpdatingLocation()
            mapView.latitude = locationManager.location?.coordinate.latitude ?? 0
            mapView.longitude = locationManager.location?.coordinate.longitude ?? 0
            
        } else {
            print("GPS Off")
            locationOverlay.hidden = true
            mapView.latitude = 37.54330366639085
            mapView.longitude = 127.04455548501139
        }
        
    }
    
    private func setConstraints() {
        favoriteButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        currentButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(favoriteButton.snp.top).offset(-20)
        }
    }
    
    
}


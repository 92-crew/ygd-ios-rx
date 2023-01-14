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
    
    private var locationManager: CLLocationManager!
    private var mapView: NMFMapView!
    private var viewModel: MainViewModel!
    private var locationOverlay: NMFLocationOverlay!
    private var favoriteMode: Bool = false
    
    private let searchBar: UIStackView = {
        let stackView = UIStackView()
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        imageView.tintColor = .ygdNavy
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 5
        textField.addLeftPadding()
        stackView.addSubview(textField)
        stackView.addSubview(imageView)
        textField.frame = stackView.frame
        textField.snp.makeConstraints { make in
            make.size.equalTo(stackView)
        }
        imageView.snp.makeConstraints { make in
            make.trailing.equalTo(stackView).offset(-10)
            make.centerY.equalTo(stackView)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        return stackView
    }()
    private let favoriteButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 0.5 * btn.bounds.width
        btn.clipsToBounds = true
        btn.setBackgroundImage(UIImage(named: "button_favorite_unselected"), for: .normal)
        
        return btn
    }()
    private let currentButton: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 0.5 * btn.bounds.width
        btn.clipsToBounds = true
        btn.setBackgroundImage(UIImage(named: "button_current"), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MainViewModel()
        initializeMapView()
        view.addSubview(mapView)
        view.addSubview(searchBar)
        view.addSubview(favoriteButton)
        view.addSubview(currentButton)
        setConstraints()
        setLocationOverlay()
        setBinding()
    }
    
    private func initializeMapView() {
        mapView = NMFMapView(frame: view.frame)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                print("GPS On")
                self.locationManager.startUpdatingLocation()
                self.mapView.latitude = self.locationManager.location?.coordinate.latitude ?? 0
                self.mapView.longitude = self.locationManager.location?.coordinate.longitude ?? 0
                
            } else {
                print("GPS Off")
                self.locationOverlay.hidden = true
                self.mapView.latitude = 37.54330366639085
                self.mapView.longitude = 127.04455548501139
            }
        }
        requestSmokingAreas()
    }
    
    private func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(40)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalTo(self.view.safeAreaLayoutGuide)
        }
        currentButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
        }
        favoriteButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.trailing.equalTo(view).offset(-20)
            make.bottom.equalTo(currentButton.snp.top).offset(-20)
        }
    }
    
    private func setLocationOverlay() {
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationOverlay = self.mapView.locationOverlay
                self.locationOverlay.location = NMGLatLng(lat: self.locationManager.location?.coordinate.latitude ?? 0, lng: self.locationManager.location?.coordinate.longitude ?? 0)
                self.locationOverlay.hidden = false
                self.mapView.positionMode = .normal
                
                let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: self.locationManager.location?.coordinate.latitude ?? 0, lng: self.locationManager.location?.coordinate.longitude ?? 0))
                cameraUpdate.animation = .easeIn
                self.mapView.moveCamera(cameraUpdate)
            } else {
                print("Please check GPS")
            }
            
        }
    }
    
    private func setBinding() {
        currentButton.rx.tap
            .bind(onNext: { event in
                self.setLocationOverlay()
            }).disposed(by: disposeBag)
        
        favoriteButton.rx.tap
            .bind(onNext: { event in
                if self.favoriteMode {
                    self.favoriteButton.setBackgroundImage(UIImage(named: "button_favorite_unselected"), for: .normal)
                    self.favoriteMode = false
                } else {
                    self.favoriteButton.setBackgroundImage(UIImage(named: "button_favorite_selected"), for: .normal)
                    self.favoriteMode = true
                }
                self.viewModel.isFavoriteMode.accept(!self.favoriteMode)
            }).disposed(by: disposeBag)
        
        viewModel.smokingAreaRelay
            .subscribe(onNext: { locations in
                DispatchQueue.global().async {
                    var markers = [NMFMarker]()
                    for i in 0..<locations.count {
                        let marker = NMFMarker()
                        let lat = locations[i].latitude
                        let lng = locations[i].longitude
                        print("Marker : \(lat), \(lng)")
                        marker.position = NMGLatLng(lat: lat, lng: lng)
                        marker.iconImage = NMFOverlayImage(name: "marker_unselected")
                        markers.append(marker)
                        
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self else { return }
                            markers[i].mapView = self.mapView
                        }
                    }
                }
        }).disposed(by: disposeBag)
    }
    
    private func requestSmokingAreas() {
        viewModel.requestSmokingAreas()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
}


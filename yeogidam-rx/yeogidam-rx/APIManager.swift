//
//  APIManager.swift
//  yeogidam-rx
//
//  Created by 이강욱 on 2023/01/13.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

class APIManager {
    static let shared = APIManager()
    func requestSmokingAreas() -> Observable<[Location]> {
        let url = "http://localhost:3000/smoking-areas"
        return Observable<[Location]>.create{ observer in
            let dataRequest = AF.request(url, method: .get, encoding: URLEncoding.default)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    var smokingAreas: [SmokingArea] = []
                    switch response.result {
                    case .success(let _):
                        if let jsonData = response.value {
                            let json = JSON(jsonData)
                            for (_, subJson) : (String, JSON) in json {
                                if let id = subJson["id"].int,
                                   let name = subJson["name"].string,
                                   let description = subJson["description"].string,
                                   let typeCode = subJson["type"]["code"].string,
                                   let typeName = subJson["type"]["name"].string,
                                   let categoryId = subJson["category"]["id"].int,
                                   let categoryName = subJson["category"]["name"].string,
                                   let siCode = subJson["location"]["si"]["code"].int,
                                   let siName = subJson["location"]["si"]["name"].string,
                                   let guCode = subJson["location"]["gu"]["code"].int,
                                   let guName = subJson["location"]["gu"]["name"].string,
                                   let road = subJson["location"]["road"].string,
                                   let roadCode = subJson["location"]["roadCode"].int,
                                   let building = subJson["location"]["building"].string,
                                   let detail = subJson["location"]["detail"].string,
                                   let latitude = subJson["location"]["latitude"].double,
                                   let longitude = subJson["location"]["longitude"].double
                                {
                                    let smokingArea = SmokingArea(id: id, name: name, description: description, type: AreaType(code: typeCode, name: typeName), category: Category(id: categoryId, name: categoryName), location: Location(si: Si(code: siCode, name: siName), gu: Gu(code: guCode, name: guName), road: road, roadCode: roadCode, building: building, detail: detail, latitude: latitude, longitude: longitude))
                                    smokingAreas.append(smokingArea)
                                } else {
                                    print(smokingAreas)
                                    continue
                                }
                            }
                        }
                        observer.onNext(smokingAreas.map{$0.location})
                    case .failure(let error):
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
}

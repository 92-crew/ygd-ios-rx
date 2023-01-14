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
        let url = "http://localhost:3000/data"
        return Observable<[Location]>.create{ observer in
            let dataRequest = AF.request(url, method: .get, encoding: URLEncoding.default)
                .validate(statusCode: 200..<300)
                .responseData { response in
                    var smokingAreas: [SmokingArea] = []
                    switch response.result {
                    case .success(let _):
                        // TODO: response가 success / data 형식으로 들어오면 약간의 수정 필요(실제 api요청 했을 때)
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
                                   let siId = subJson["location"]["si"]["id"].int,
                                   let siName = subJson["location"]["si"]["name"].string,
                                   let guId = subJson["location"]["gu"]["id"].int,
                                   let guName = subJson["location"]["gu"]["name"].string,
                                   let road = subJson["location"]["road"].string,
                                   let roadCode = subJson["location"]["roadCode"].int,
                                   let building = subJson["location"]["building"].string,
                                   let detail = subJson["location"]["detail"].string,
                                   let locationDisplayString = subJson["location"]["displayString"].string,
                                   let latitude = subJson["location"]["latitude"].double,
                                   let longitude = subJson["location"]["longitude"].double,
                                   let value = subJson["scale"]["value"].int,
                                   let unit = subJson["scale"]["unit"].string,
                                   let sclaeDisplayString = subJson["scale"]["displayString"].string,
                                   let isUnderManagement = subJson["management"]["isUnderManagement"].bool,
                                   let establishedAt = subJson["establishedAt"].string,
                                   let establishedBy = subJson["establishedBy"].string,
                                   let updatedAt = subJson["updatedAt"].string
                                {
                                    let managerName = subJson["management"]["managerName"].string
                                    let smokingArea = SmokingArea(id: id, name: name, description: description, type: AreaType(code: typeCode, name: typeName), category: Category(id: categoryId, name: categoryName), location: Location(si: Si(id: siId, name: siName), gu: Gu(id: guId, name: guName), road: road, roadCode: roadCode, building: building, detail: detail, displayString: locationDisplayString, latitude: latitude, longitude: longitude), scale: Scale(value: value, unit: unit, displayString: sclaeDisplayString), management: Management(isUnderManagement: isUnderManagement, managerName: managerName), establishedAt: establishedAt, establishedBy: establishedBy, updatedAt: updatedAt)
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

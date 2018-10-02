//
//  Api.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 03/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import Foundation
import Alamofire
import RxSwift

protocol Api {
    
    func allDeputies() -> Observable<[DeputySummary]>
    func deputies(forLatitude latitude:Double, andLongitude longitude:Double) -> Observable<[DeputySummary]>
    func deputy(forDepartmentId departmentId:Int, andDistrictNumber districtNumber:Int) -> Observable<Deputy>
    func deputyWithPhotoData(forDepartmentId departmentId:Int, andDistrictNumber districtNumber:Int) -> Observable<Deputy>
    func subscribeToPushNotifications(withToken token:String, instanceId:String, forDeputyId deputyId:Int) -> Observable<Bool>
    func unsubscribeToPushNotifications(withToken token:String, instanceId:String, forDeputyId deputyId:Int) -> Observable<Bool>
    func deputiesVotes(forBallotId ballotId:Int) -> Observable<BallotDeputiesVotes>
    func places(forText text: String) -> Observable<[Place]>
    func activityRatesByGroup() -> Observable<[ActivityRate]>
    
    func get(url: String, queryParameters:[String:Any]) -> Observable<Any>
    func post(url: String, bodyParameters:[String: Any]) -> Observable<Any>
    func downloadFile(url:String) -> Observable<URL>
    func downloadImage(url:String) -> Observable<Data>
    
}

protocol MockableApi: Api {
    func fakeJsonResponse(forUrl url:String) -> Any?
    func fakeJsonResponse(forFileName fileName: String) -> Any?
}

extension Api {
    
    func allDeputies() -> Observable<[DeputySummary]> {
        
        return Observable<[DeputySummary]>.create({ observer in
            
            let url = UrlBuilder.api().buildUrl(path: Constants.Api.allDeputiesPath)
            
            let disposable = self.get(url: url, queryParameters: [:])
                .subscribe(onNext: { deputiesJson in
                    
                    let deputies = DeputySummaryResponseHandler.deputies(fromJson: deputiesJson)
                        .sorted(by: { deputy1, deputy2 -> Bool in
                            return "\(deputy1.firstName) \(deputy1.lastName)" < "\(deputy2.firstName) \(deputy2.lastName)"
                        })
                    
                    observer.onNext(deputies)
                    observer.onCompleted()
                    
                }, onError: { error in
                    observer.onError(DAError(error: error, message:R.string.localizable.error_all_deputies()))
                })
            
            return Disposables.create([disposable])
        })
    }
    
    func deputies(forLatitude latitude:Double, andLongitude longitude:Double) -> Observable<[DeputySummary]> {
        
        return Observable<[DeputySummary]>.create({ observer in
            
            let url = UrlBuilder.api().buildUrl(path: Constants.Api.deputyByGpsPath)
            let parameters = ["latitude" : latitude, "longitude" : longitude]
            
            let disposable = self.get(url: url, queryParameters: parameters).subscribe(onNext: { deputiesJson in
                
                observer.onNext(DeputySummaryResponseHandler.deputies(fromJson: deputiesJson))
                observer.onCompleted()
                
            }, onError: { error in
                
                if let afError = (error as? AFError), afError.responseCode == 404 {
                    observer.onError(DAError(error: error, message:R.string.localizable.deputy_not_found()))
                } else {
                    observer.onError(DAError(error: error, message:R.string.localizable.error_deputies_list()))
                }
            })
            
            return Disposables.create([disposable])
        })
    }
    
    func deputiesVotes(forBallotId ballotId:Int) -> Observable<BallotDeputiesVotes> {
        
        return Observable<BallotDeputiesVotes>.create({ observer in
            
            let url = UrlBuilder.api().buildUrl(path: Constants.Api.ballotDeputiesVotesPath)
            let parameters = ["ballotId" : ballotId]
            
            let disposable = self.get(url: url, queryParameters: parameters).subscribe(onNext: { json in
                
                observer.onNext(BallotDeputiesVotesResponseHandler.ballotDeputiesVotes(fromJson: json))
                observer.onCompleted()
                
            }, onError: { error in
                observer.onError(DAError(error: error, message:R.string.localizable.error_ballot_votes_deputies()))
            })
            
            return Disposables.create([disposable])
        })
    }
    
    func deputy(forDepartmentId departmentId:Int, andDistrictNumber districtNumber:Int) -> Observable<Deputy> {
        
        return Observable<Deputy>.create({ observer in
            
            let url = UrlBuilder.api().buildUrl(path: Constants.Api.deputyDetailsPath)
            let parameters = ["departmentId" : departmentId, "district" : districtNumber]
            
            let disposable = self.get(url: url, queryParameters: parameters).subscribe(onNext: { deputyJson in
                
                if let deputy = DeputyResponseHandler.deputy(fromJson: deputyJson) {
                    observer.onNext(deputy)
                    observer.onCompleted()
                } else {
                    log.error("Can't parse deputy from JSON")
                    observer.onError(DAError(message:R.string.localizable.error_deputy_detail()))
                }
                
            }, onError: { error in
                observer.onError(DAError(error: error, message:R.string.localizable.error_deputy_detail()))
            })
            
            return Disposables.create([disposable])
            
        })
    }
    
    func deputyWithPhotoData(forDepartmentId departmentId:Int, andDistrictNumber districtNumber:Int) -> Observable<Deputy> {
        
        return self.deputy(forDepartmentId: departmentId, andDistrictNumber: districtNumber)
            .flatMap { deputy -> Observable<Deputy> in
                
                return self.downloadImage(url: deputy.photoUrl ?? "")
                    .catchErrorJustReturn(UIImagePNGRepresentation(UIImage(named: Constants.Image.deputyPhotoPlaceholderName)!)!)
                    .map({ data -> Deputy in
                        deputy.photoData = data
                        return deputy
                    })
        }
    }
    
    
    func timeline(forDeputy deputyId:Int, page:Int) -> Observable<[TimelineEvent]> {
        
        return Observable<[TimelineEvent]>.create({ observer in
            
            let url = UrlBuilder.api().buildUrl(path: Constants.Api.deputyTimelinePath)
            let parameters = ["deputyId" : deputyId, "page" : page]
            
            let observable = self.get(url: url, queryParameters: parameters).subscribe(onNext: { timelineEventsJson in
                observer.onNext(TimelineEventResponseHandler.timelineEvents(fromJson: timelineEventsJson))
                observer.onCompleted()
                
            }, onError: { error in
                observer.onError(DAError(error: error, message: R.string.localizable.error_timeline_events()))
            })
            
            return Disposables.create([observable])
            
        })
    }
    
    func subscribeToPushNotifications(withToken token:String, instanceId:String, forDeputyId deputyId:Int) -> Observable<Bool> {
        
        return Observable<Bool>.create({ observer in
            
            let url = UrlBuilder.api().buildUrl(path: Constants.Api.subscribePath.replacingOccurrences(of: "X", with: "\(deputyId)"))
            let parameters:[String:Any] = ["token" : token, "instanceId": instanceId]
            
            let disposable = self.post(url: url, bodyParameters: parameters).subscribe(onNext: { _ in
                observer.onNext(true)
                observer.onCompleted()
            }, onError: { error in
                observer.onError(DAError(error: error, message: R.string.localizable.error_subscribe()))
            })
            
            return Disposables.create([disposable])
            
        })
    }
    
    func unsubscribeToPushNotifications(withToken token:String, instanceId:String, forDeputyId deputyId:Int) -> Observable<Bool> {
        
        return Observable<Bool>.create({ observer in
            
            let url = UrlBuilder.api().buildUrl(path: Constants.Api.unsubscribePath.replacingOccurrences(of: "X", with: "\(deputyId)"))
            let postParameters:[String:Any] = ["token" : token, "instanceId": instanceId]
            
            let disposable = self.post(url: url, bodyParameters: postParameters).subscribe(onNext: { _ in
                observer.onNext(true)
                observer.onCompleted()
            }, onError: { error in
                observer.onError(DAError(error: error, message: R.string.localizable.error_unsubscribe()))
            })
            
            return Disposables.create([disposable])
            
        })
    }
    
    
    func places(forText text: String) -> Observable<[Place]> {
        
        return Observable<[Place]>.create({  observer in
            
            let url = Constants.ServicesUrl.placesUrl
            let parameters = ["q" : text, "type" : "housenumber", "limit": "10"]
            
            let disposable = self.get(url: url, queryParameters: parameters).subscribe(onNext: { placesJson in
                observer.onNext(PlacesResponseHandler.places(fromJson: placesJson))
                observer.onCompleted()
            }, onError: { error in
                observer.onError(DAError(error: error, message: R.string.localizable.error_retry()))
            })
            
            return Disposables.create([disposable])
        })
    }
    
    func activityRatesByGroup() -> Observable<[ActivityRate]> {
        
        return Observable<[ActivityRate]>.create({  observer in
            
            let url = UrlBuilder.api().buildUrl(path: Constants.Api.activityRatesByGroupPath)
            
            let disposable = self.get(url: url, queryParameters: [:]).subscribe(onNext: { json in
                
                //TEMP : TODO migrate all with Codable
                guard let data = try? JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted),
                    let activityRates = try? JSONDecoder().decode(Ranking.self, from: data) else {
                        observer.onNext([])
                        observer.onCompleted()
                        return
                }
                
                observer.onNext(activityRates.activityRatesByGroup)
                observer.onCompleted()
            }, onError: { error in
                observer.onError(DAError(error: error, message: R.string.localizable.error_retry()))
            })
            
            return Disposables.create([disposable])
        })
    }
    
    func downloadFile(url: String) -> Observable<URL> {
        
        guard let url = URL(string: url) else {
            return Observable<URL>.empty()
        }
        
        return Observable<URL>.create({ observer  in
            
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
            
            Alamofire.download(
                url,
                method: .get,
                to: destination)
                .response(completionHandler: {  downloadResponse in
                    
                    if let destinationURL = downloadResponse.destinationURL, downloadResponse.response?.statusCode == 200 {
                        log.debug("Download \(url) successfully")
                        observer.onNext(destinationURL)
                        observer.onCompleted()
                    } else if downloadResponse.error != nil || downloadResponse.response?.statusCode != 200 {
                        log.error("Download error : \(String(describing: downloadResponse.error))")
                        observer.onError(DAError(message: R.string.localizable.error_download()))
                    }
                })
            
            return Disposables.create()
        })
    }
    
    func downloadImage(url:String) -> Observable<Data> {
        
        guard let imageUrl = URL(string:url) else {
            return Observable<Data>.empty()
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: imageUrl))
            .catchErrorJustReturn(UIImagePNGRepresentation(UIImage(named: Constants.Image.deputyPhotoPlaceholderName)!)!)
    }
    
}

extension MockableApi {
    
    // MARK: - Mock management
    
    func fakeJsonResponse(forFileName fileName: String) -> Any? {
        
        guard let filePath = Bundle(for: type(of: self) as! AnyClass).url(forResource: fileName, withExtension: ".json"),
            let contentAsData = try? Data(contentsOf: filePath),
            let contentAsJson = try? JSONSerialization.jsonObject(with: contentAsData) else {
                return nil
        }
        
        return contentAsJson
    }
    
    func get(url: String, queryParameters:[String:Any] = [:]) -> Observable<Any> {
        return self.fakeRequest(url:url)
    }
    
    func post(url: String, bodyParameters:[String:Any]) ->  Observable<Any> {
        return self.fakeRequest(url:url)
    }
    
    private func fakeRequest(url:String) -> Observable<Any> {
        
        return Observable<Any>.create({ observer in
            
            if let response = self.fakeJsonResponse(forUrl:url) {
                observer.onNext(response)
                observer.onCompleted()
            } else {
                observer.onError(DAError(message: "Mocked file not found"))
            }
            
            return Disposables.create()
        }).delay(2, scheduler: MainScheduler.instance)
    }
}

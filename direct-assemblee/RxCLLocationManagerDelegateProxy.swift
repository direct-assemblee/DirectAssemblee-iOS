//
//  RxCLLocationManagerDelegateProxy.swift
//  RxExample
//
//  Created by Carlos García on 8/7/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

import CoreLocation
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

class RxCLLocationManagerDelegateProxy : DelegateProxy<CLLocationManager, CLLocationManagerDelegate>
    , CLLocationManagerDelegate
, DelegateProxyType {
    
    
    internal lazy var didUpdateLocationsSubject = PublishSubject<[CLLocation]>()
    internal lazy var didFailWithErrorSubject = PublishSubject<Error>()
    
    internal init(parentObject: CLLocationManager) {
        super.init(parentObject: parentObject, delegateProxy: RxCLLocationManagerDelegateProxy.self)
    }
    
    internal static func registerKnownImplementations() {
        self.register { RxCLLocationManagerDelegateProxy(parentObject: $0) }
    }
    
    static func currentDelegate(for object: CLLocationManager) -> CLLocationManagerDelegate? {
        let locationManager: CLLocationManager = object
        return locationManager.delegate
    }
    
    static func setCurrentDelegate(_ delegate: CLLocationManagerDelegate?, to object: CLLocationManager) {
        let locationManager: CLLocationManager = object
        if let delegate = delegate {
            locationManager.delegate = delegate
        } else {
            locationManager.delegate = nil
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _forwardToDelegate?.locationManager(manager, didUpdateLocations: locations)
        didUpdateLocationsSubject.onNext(locations)
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        _forwardToDelegate?.locationManager(manager, didFailWithError: error)
        didFailWithErrorSubject.onNext(error)
    }
    
    deinit {
        self.didUpdateLocationsSubject.on(.completed)
        self.didFailWithErrorSubject.on(.completed)
    }
}

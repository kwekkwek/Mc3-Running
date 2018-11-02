//
//  SetupAssistant.swift
//  TryConnectHealth
//
//  Created by Gun Eight  on 29/10/18.
//  Copyright © 2018 Gun Eight . All rights reserved.
//

import Foundation
import HealthKit

enum CheckHealthOnDecive : Error{
    case HealthNotAvaliableOndevice
    case DataTypeNotAvaliable
}
class SetupAssistant {
   
    class func AuthorizeHealthKit(completion : @escaping (Bool, Error?) -> Swift.Void) {
    guard HKHealthStore.isHealthDataAvailable() else {
        completion (false, CheckHealthOnDecive.HealthNotAvaliableOndevice)
        return
    }
        
    guard let weightUser  = HKObjectType.quantityType(forIdentifier: .bodyMass),
            let heightUser = HKObjectType.quantityType(forIdentifier: .height)
            
        else
    {
        completion(false,CheckHealthOnDecive.DataTypeNotAvaliable)
        return
   
}
        let HealthKitToWrite : Set<HKSampleType> = [heightUser,weightUser]
        
        let HealthKitToRead : Set<HKObjectType> = [heightUser,weightUser]
        HKHealthStore().requestAuthorization(toShare: HealthKitToWrite, read: HealthKitToRead){ (succes, error) in completion(succes, error)

        }
    }
}




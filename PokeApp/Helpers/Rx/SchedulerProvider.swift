//
//  SchedulerProvider.swift
//  PokeApp
//
//  Created by Taufik Rohmat on 19/08/21.
//  Copyright © 2021. All rights reserved.
//

import RxSwift

class SchedulerProvider {
    
    static let shared: SchedulerProvider = SchedulerProvider()
    
    let main = MainScheduler.instance
    let background = ConcurrentDispatchQueueScheduler(qos: DispatchQoS.background)
    
    private init() {
        
    }
    
}

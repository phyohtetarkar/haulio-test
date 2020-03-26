//
//  JobModel.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import Foundation

enum JobsModel {
    struct JobResponse: Decodable {
        var id: Int
        var jobId: Int
        var priority: Int
        var company: String
        var address: String
        var geolocation: Location
        
        enum CodingKeys: String, CodingKey {
            case id
            case jobId = "job-id"
            case priority
            case company
            case address
            case geolocation
        }
    }
    
    struct Location: Decodable {
        var latitude: Double
        var longitude: Double
    }
}

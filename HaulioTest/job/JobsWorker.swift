//
//  JobsWorker.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import Alamofire

typealias Success = ([JobsModel.JobResponse]) -> ()
typealias Failure = (_ error: Error) -> ()

class JobsWorker {
    
    func loadJobs(_ success: @escaping Success, _ failure: @escaping Failure) {
        
        AF.request("https://api.myjson.com/bins/8d195.json")
            .responseDecodable(of: [JobsModel.JobResponse].self) { resp in
                
                if let error = resp.error {
                    failure(error)
                } else {
                    success(try! resp.result.get())
                }
                
        }
        
    }
    
}

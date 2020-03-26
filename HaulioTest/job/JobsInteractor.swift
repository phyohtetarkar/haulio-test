//
//  JobsInteractor.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import Foundation

protocol JobsInteractor {
    func loadJobs()
}

class JobsInteractorImpl: JobsInteractor {
    
    var worker: JobsWorker?
    var presenter: JobsPresenter?
    
    func loadJobs() {
        worker?.loadJobs({ [weak self] in
            self?.presenter?.presentJobs($0)
        }, { [weak self] error in
            self?.presenter?.presentError(error)
        })
    }
}

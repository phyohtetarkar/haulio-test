//
//  JobsPresenter.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import Foundation

protocol JobsPresenter {
    func presentJobs(_ jobs: [JobsModel.JobResponse])
    func presentError(_ error: Error)
}

class JobsPresenterImpl: JobsPresenter {
    
    var view: JobsView?
    
    func presentJobs(_ jobs: [JobsModel.JobResponse]) {
        view?.showJobs(jobs)
    }
    
    func presentError(_ error: Error) {
        view?.showError(error.asAFError?.errorDescription ?? error.localizedDescription)
    }
}

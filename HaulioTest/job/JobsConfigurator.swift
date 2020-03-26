//
//  JobsConfigurator.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import Foundation

class JobsConfigurator: NSObject {
    
    static let instance = JobsConfigurator()
    
    private override init() {
        
    }
    
    func configure(_ viewController: JobsViewController) {
        let interactor = JobsInteractorImpl()
        let presenter = JobsPresenterImpl()
        let worker = JobsWorker()
        
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = worker
        presenter.view = viewController
    }
}

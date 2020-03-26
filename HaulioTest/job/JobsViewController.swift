//
//  JobsViewController.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import UIKit

private let reuseIdentifier = "JobTableViewCell"

protocol JobsView: AnyObject {
    func showJobs(_ jobs: [JobsModel.JobResponse])
    func showError(_ message: String)
}

class JobsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var jobsTableView: UITableView!
    
    var interactor: JobsInteractor?
    var jobs = [JobsModel.JobResponse]()
    var jobsLoaded = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        JobsConfigurator.instance.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        jobsTableView.dataSource = self
        jobsTableView.delegate = self
 
        interactor?.loadJobs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !jobsLoaded {
            LoadingView.instance.showLoading()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! JobTableViewCell
        
        cell.acceptButton.tag = indexPath.row
        cell.bind(jobs[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Jobs Available"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let dest = segue.destination as? JobDetailViewController else {
            fatalError("Unexpected destination: \(segue.destination)")
        }
        
        guard let button = sender as? HButton else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        
        
        let job = jobs[button.tag]
        dest.job = job
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        LoadingView.instance.refresh()
    }

}

extension JobsViewController: JobsView {
    func showJobs(_ jobs: [JobsModel.JobResponse]) {
        LoadingView.instance.dismiss()
        self.jobsLoaded = true
        self.jobs = jobs
        self.jobsTableView.reloadData()
    }
    
    func showError(_ message: String) {
        LoadingView.instance.dismiss()
        self.jobsLoaded = true
        let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

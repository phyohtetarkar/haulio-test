//
//  JobTableViewCell.swift
//  HaulioTest
//
//  Created by Phyo Htet Arkar on 3/25/20.
//  Copyright © 2020 Haulio. All rights reserved.
//

import UIKit

class JobTableViewCell: UITableViewCell {
    
    @IBOutlet weak var jobNumber: UILabel!
    @IBOutlet weak var company: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var acceptButton: HButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ job: JobsModel.JobResponse) {
        jobNumber.text = "Job Number: \(job.jobId)"
        company.text = "Company: \(job.company)"
        address.text = "Address: \(job.address)"
    }

}

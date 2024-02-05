//
//  DetailsViewController.swift
//  TargetTechTask
//
//  Created by Apple  on 03/02/2024.
//

import UIKit

class DetailsViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var DetailsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsView: UITextView!
    @IBOutlet weak var copyRights: UILabel!
    @IBOutlet weak var dateAndTime: UILabel!
    
    //MARK: - Variables
    var nyTimes : NYTimesModel!
    var resultData : [Results] = []

    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let result = resultData[0]
        titleLabel.text = result.title
        detailsView.text = result.abstract
        copyRights.text = nyTimes?.copyright
        dateAndTime.text = result.updated
    }

}

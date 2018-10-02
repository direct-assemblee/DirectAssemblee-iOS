//
//  ActivityRateTableViewCell.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 02/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import UIKit

class ActivityRateTableViewCell: BaseTableViewCell, BindableType {

    @IBOutlet weak var activityRateLabel: UILabel!
    @IBOutlet weak var parliamentGroupNameLabel: UILabel!

    typealias ViewModelType = ActivityRateViewModel
    var viewModel: ActivityRateViewModel! {
        didSet {
            self.bindViewModel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    // MARK: - Binding
    
    func bindViewModel() {
        self.viewModel.activityRateValue.asDriver().drive(self.activityRateLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.parliamentGroupName.asDriver().drive(self.parliamentGroupNameLabel.rx.text).disposed(by: self.disposeBag)
    }
    
}

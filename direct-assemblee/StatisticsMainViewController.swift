//
//  StatisticsViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 02/10/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//

import UIKit

class StatisticsMainViewController: BaseViewController, BindableType {

    typealias ViewModelType = StatisticsMainViewModel
    var viewModel: StatisticsMainViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.topItem?.title = "Statistiques"
    }
    
    // MARK: - Binding

    func bindViewModel() {
        
    }
    

}

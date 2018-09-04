//
//  DeputyTableViewCell.swift
//  direct-assemblee
//
//  Created by Julien Coudsi on 04/05/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift
import SDWebImage

class DeputyTableViewCell: BaseTableViewCell, BindableType {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var parliamentGroupLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    
    typealias ViewModelType = DeputySummaryViewModel
    var viewModel: DeputySummaryViewModel! {
        didSet {
           self.bindViewModel()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupColors()
        self.setupPhotoStyle()
    }
    
    func setupColors() {
        self.nameLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
        self.parliamentGroupLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
        self.districtLabel.textColor = UIColor(hex: Constants.Color.blackColorCode)
    }
    
    func setupPhotoStyle() {
        self.photo.layer.cornerRadius = self.photo.frame.width/2
        self.photo.clipsToBounds = true
        self.photo.layer.borderWidth = 2
        self.photo.layer.borderColor = UIColor(hex: Constants.Color.blueColorCode).cgColor
    }
    
    func setStarViewColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    func bindViewModel() {
        
        self.viewModel.completeNameText.asObservable().asObservable().bind(to: self.nameLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.parliamentGroupText.asObservable().bind(to: self.parliamentGroupLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.districtText.asObservable().bind(to: self.districtLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.departmentText.asObservable().bind(to: self.departmentLabel.rx.text).disposed(by: self.disposeBag)
        
        self.photo.sd_setImage(with: URL(string: self.viewModel.photoUrl.value), placeholderImage: R.image.no_photo_placeholder()) { [weak self] image, error, cacheType, url in
            
            guard let image = image else {
                return
            }
            
            self?.photo.image = image
            
            if let data = UIImagePNGRepresentation(image) {
                self?.viewModel.photoData.value = data
            }
        }
    }
    
}

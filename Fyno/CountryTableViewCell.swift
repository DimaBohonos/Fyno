//
//  CountryTableViewCell.swift
//  Fyno
//
//  Created by dima on 08.06.2024.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var countryInfo:CountryModel? = nil {
        didSet{
            setupView()
        }
    }
    
    var enable: Bool = false {
        didSet{
            if enable {
                selectedImageView.image = UIImage(named: "icon_selected")
            }else{
                selectedImageView.image = UIImage(named: "icon_selected_off")
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView() {
        if let countryInfo = countryInfo {
            self.titleLabel?.text = countryInfo.countryTitle
            self.flagImageView?.image = countryInfo.flag
        }
        
        if enable {
            selectedImageView?.image = UIImage(named: "icon_selected")
        }else{
            selectedImageView?.image = UIImage(named: "icon_selected_off")
        }
    }

}

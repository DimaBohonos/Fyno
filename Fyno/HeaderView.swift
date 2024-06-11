//
//  HeaderView.swift
//  Fyno
//
//  Created by dima on 08.06.2024.
//

import UIKit
import SnapKit

class HeaderView: UIView {
    
    var actionHandler: ((HeaderView) -> Void)?
    
    var title: String = "" {
        didSet{
            titleLabel.text = title
        }
    }
    
    lazy private var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexColor(hex: "#3C3C43").withAlphaComponent(0.36)
        return view
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.appTextFont(ofSize: 17, weight: .semibold)
        label.text = title
        return label
    }()
    
    lazy private var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue
        button.setTitle("Add country", for: .normal)
        button.setImage(UIImage(named: "icon_plus"), for: .normal)
        button.setTitleColor(UIColor.hexColor(hex: "#555ACF"), for: .normal)
        button.titleLabel?.font = UIFont.appTextFont(ofSize: 15, weight: .semibold)
        button.addTarget(self, action: #selector(self.addButtonAction(sender:)), for: .touchUpInside)
        button.backgroundColor = UIColor.hexColor(hex: "#F2F2F7")
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews() {
        // Only override draw() if you perform custom drawing.
        // An empty implementation adversely affects performance during animation.
        
        self.backgroundColor = .white
        self.addSubview(separatorView)
        self.addSubview(titleLabel)
        self.addSubview(addButton)
        
        separatorView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(8)
            make.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.top.equalTo(separatorView.snp.bottom).inset(-20)
        }
        
        addButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.top.equalTo(separatorView.snp.bottom).inset(-16)
            make.width.equalTo(138)
            make.height.equalTo(32)
        }
        
    }
    
    @IBAction func addButtonAction(sender: UIButton?) {
        actionHandler?(self)
    }

}

//
//  FormTextField.swift
//  MLModelCamera
//
//  Created by Hiền Đẹp Trai on 02/12/2020.
//  Copyright © 2020 Shuichi Tsutsumi. All rights reserved.
//

import UIKit

class FormTextFieldDemo: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = UIColor(red: 185/255.0, green: 185/255.0, blue: 185/255.0, alpha: 1)
        
        addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            
            underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
            ])
    }
    
}

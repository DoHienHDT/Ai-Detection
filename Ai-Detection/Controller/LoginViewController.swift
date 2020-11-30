//
//  LoginViewController.swift
//  Ai-Detection
//
//  Created by Hiền Đẹp Trai on 30/11/2020.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setImageBackground()
        
        let customColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 100)
        username.layer.borderColor = customColor.cgColor
        password.layer.borderColor = customColor.cgColor
        
        username.layer.borderWidth = 1.0
        password.layer.borderWidth = 1.0
        
        username.layer.cornerRadius = 10
        password.layer.cornerRadius = 10
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
    }
    

    func setImageBackground(){
        let background = UIImage(named: "login-4")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }

}

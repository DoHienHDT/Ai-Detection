//
//  LoginViewController.swift
//  Ai-Detection
//
//  Created by Hiền Đẹp Trai on 30/11/2020.
//

import UIKit

class LoginViewController: BaseViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var btnLogin: TKTransitionSubmitButton!
    
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
        
        username.text = "  Vmio_Ai_Detection"
        password.text = "  Vmio_Ai_Detection"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        btnLogin.animate(1, completion: { () -> () in
            let aiDetectVC = AiDetectionViewController()
            aiDetectVC.transitioningDelegate = self
            aiDetectVC.modalPresentationStyle = .fullScreen
            self.navigationController?.present(aiDetectVC, animated: true, completion: nil)
        })
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
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

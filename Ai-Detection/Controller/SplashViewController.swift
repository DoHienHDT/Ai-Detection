//
//  SplashViewController.swift
//  Ai-Detection
//
//  Created by Hiền Đẹp Trai on 30/11/2020.
//

import UIKit
import MHLoadingButton

class SplashViewController: BaseViewController {

    @IBOutlet weak var splashImageView: UIImageView!
    @IBOutlet weak var loadingSplashButton: LoadingButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadingSplashButton.indicator = MaterialLoadingIndicator(color: .blue)
        self.loadingSplashButton.showLoader(userInteraction: true)
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.loadingSplashButton.hideLoader()
    }

}

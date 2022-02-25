//
//  MainViewController+Extension.swift
//  cities-list
//
//  Created by Sunil Targe on 2022/2/26.
//

import UIKit

extension MainViewController {
    func showAlert( _ message: String ) {
         let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         self.present(alert, animated: true, completion: nil)
     }
    
    func showLoader() {
        activityView = UIActivityIndicatorView(style: .large)
        activityView?.center = self.view.center
        self.view.addSubview(activityView!)
        activityView?.startAnimating()
    }
    
    func hidLoader() {
        if (activityView != nil) {
            activityView?.stopAnimating()
        }
    }
    
    func gotoNext(with city: City) {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController {
            vc.city = city
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

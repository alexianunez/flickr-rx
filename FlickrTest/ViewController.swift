//
//  ViewController.swift
//  FlickrTest
//
//  Created by Alexia Nunez on 8/29/16.
//  Copyright © 2016 Alexia Nunez. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tapRecognizer: UITapGestureRecognizer!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupUIDrivers()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        
        
        
    }
    
    private func setupUIDrivers() {
        
        self.tapRecognizer.rx_event.asDriver()
            
            .driveNext { [unowned self] _ in
                
                print("tap gesture detected")
                
                self.view.endEditing(true)
                
            }
            .addDisposableTo(self.disposeBag)
        
        self.searchBar.rx_text.asDriver()
            
            .driveNext { (string: String) in
                
                print("\(string)")
            }
            
            .addDisposableTo(self.disposeBag)
        
    }

}


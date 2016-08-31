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
    
    @IBOutlet weak var tableView: UITableView!
    
    let data: Observable<[Photo]> = Observable.just([])
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupTableBindings()
        
        self.setupUIDrivers()
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    private func setupTableBindings() {
       
        self.data.bindTo(tableView.rx_itemsWithCellIdentifier("Cell")) {_, photo, cell in
            
                cell.textLabel?.text = photo.title
                cell.detailTextLabel?.text = photo.ID
            
            }
            .addDisposableTo(self.disposeBag)
        
        self.tableView.rx_modelSelected(Photo)
        .subscribeNext {
            
            print("you selected \($0)")
            
        }.addDisposableTo(self.disposeBag)
    }
    
    private func setupUIDrivers() {
        
        self.tapRecognizer.rx_event.asDriver()
            
            .driveNext { [unowned self] _ in
                
                print("tap gesture detected")
                
                self.view.endEditing(true)
                
            }
            .addDisposableTo(self.disposeBag)
        
        self.searchBar.rx_text.asDriver()
            
            .throttle(0.5)
            
            .distinctUntilChanged()
            
            .drive(self.searchBar.rx_text)
            
            .addDisposableTo(self.disposeBag)
        
    }

}



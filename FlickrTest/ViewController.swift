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
    
    var viewModel = FlickrViewModel()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupTableBindings()
        
        setupUIDrivers()
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
    }
    
    private func setupTableBindings() {
       
        viewModel.data
            .drive(tableView.rx_itemsWithCellIdentifier("Cell")) {_, photo, cell in
            
                cell.textLabel?.text = photo.title
                cell.detailTextLabel?.text = photo.ID
            
            }
            .addDisposableTo(self.disposeBag)
        
        tableView.rx_modelSelected(Photo)
        .subscribeNext {
            
            print("you selected \($0)")
            
        }.addDisposableTo(self.disposeBag)
    }
    
    private func setupUIDrivers() {
        
        tapRecognizer.rx_event.asDriver()
            
            .driveNext { [unowned self] _ in
                
                print("tap gesture detected")
                
                self.view.endEditing(true)
                
            }
            .addDisposableTo(self.disposeBag)
        
        searchBar.rx_text
                        
            .distinctUntilChanged()
            
            .bindTo(viewModel.searchText)
            
            .addDisposableTo(disposeBag)
        
    }

}



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
import Kingfisher

enum GeneralError {
    
    case TestError
    
}

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tapRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = FlickrViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "Alexia's Flickr RX App"
        
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
            
            .doOnNext({ _ in

                UIApplication.sharedApplication().networkActivityIndicatorVisible = false

            })
            .drive(tableView.rx_itemsWithCellIdentifier("Cell")) {_, photo, cell in
                
                cell.layoutMargins = UIEdgeInsetsZero
                
                cell.separatorInset = UIEdgeInsetsZero
                
                cell.textLabel?.text = photo.title
                
                cell.detailTextLabel?.text = "ID: \(photo.ID)"
                
                let r: Resource = Resource(downloadURL: NSURL(string: photo.url)!)
                
                cell.imageView!.kf_setImageWithResource(r, placeholderImage: nil, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                    
                        cell.setNeedsLayout()
                    
                    })
                                
                
            }
            .addDisposableTo(self.disposeBag)
        
        
    }
    
    private func setupUIDrivers() {
        
        tapRecognizer.rx_event.asDriver()
            
            .driveNext { [unowned self] _ in
                
                self.view.endEditing(true)
                
            }
            .addDisposableTo(self.disposeBag)
        
        searchBar.rx_text
            
            .distinctUntilChanged()
            
            .bindTo(viewModel.searchText)
            
            .addDisposableTo(disposeBag)
        
        searchBar.rx_text
        
            .subscribeNext { (str: String) in
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = !str.isEmpty
                
        }
            .addDisposableTo(disposeBag)
        
    }
    
}



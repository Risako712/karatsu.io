//
//  ThirdViewController.swift
//  MapDemo
//
//  Created by 安井 梨沙子 on 2016/01/24.
//  Copyright (c) 2016年 安井 梨沙子. All rights reserved.
//

import UIKit
import MapKit


class ThirdViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate, MKMapViewDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = myTitle.last
        detailLabel.text = myDetail.last
 
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
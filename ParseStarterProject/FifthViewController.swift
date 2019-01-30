//
//  FifthViewController.swift
//  MapDemo
//
//  Created by 安井 梨沙子 on 2016/01/26.
//  Copyright © 2016年 安井 梨沙子. All rights reserved.
//

import Foundation
import UIKit


class FifthViewController: UIViewController{
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UITextView!
    
    var thisTitle: String!
    var thisDetail: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = thisTitle
        
        detailLabel.text = thisDetail
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
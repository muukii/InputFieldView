//
//  ViewController.swift
//  InputFieldView
//
//  Created by Muukii on 11/2/14.
//  Copyright (c) 2014 Muukii. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var inputFieldView: InputFieldView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        inputFieldView = InputFieldView.instantiateFromNib()
        inputFieldView.attachView(self.view)
    }
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


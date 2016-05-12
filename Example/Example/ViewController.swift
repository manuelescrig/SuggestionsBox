//
//  ViewController.swift
//  Example
//
//  Created by Manuel Escrig Ventura on 12/05/16.
//  Copyright © 2016 Manuel Escrig Ventura. All rights reserved.
//

import UIKit
import SuggestionsBox

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        print("viewDidLoad")
        
        let test = MySwiftPodManager()
        test.getMyTest("Manuel")
        
    }



}


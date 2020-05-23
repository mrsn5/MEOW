//
//  ViewController.swift
//  MEOW
//
//  Created by San Byn Nguyen on 22.05.2020.
//  Copyright © 2020 San Byn Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let service = QuizService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        service.generateQuiz { result in
            print(result)
        }
    }
}




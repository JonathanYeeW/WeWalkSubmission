//
//  UserVC.swift
//  GreenHacksProject
//
//  Created by Jonathan Yee on 6/10/18.
//  Copyright © 2018 Jonathan Yee. All rights reserved.
//

import UIKit

class UserVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        profilePicture.layer.cornerRadius = 25
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Variables
    //Outlets
    @IBOutlet weak var profilePicture: UIImageView!
    
    //Functions
    
}

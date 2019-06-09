//
//  ChangeCityViewController
//  iOS-Weather-App
//
//  Created by Daniel Barclay.
//  Copyright © 2019 Daniel Barclay. All rights reserved.
//

import UIKit


class ChangeCityViewController: UIViewController {
    
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
    
        
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

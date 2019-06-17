//
//  ChangeCityViewController
//  iOS-Weather-App
//
//  Created by Daniel Barclay.
//  Copyright © 2019 Daniel Barclay. All rights reserved.
//

import UIKit

//MARK: Protocol declaration
protocol ChangeCityDelegate {
    func userEnteredANewCityName(city: String)
}


class ChangeCityViewController: UIViewController {
    
    var delegate: ChangeCityDelegate?
    
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
    
        let cityName = changeCityTextField.text!
        // check if delegate is not nill
        delegate?.userEnteredANewCityName(city: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

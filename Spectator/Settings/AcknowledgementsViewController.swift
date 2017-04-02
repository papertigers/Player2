//
//  AcknowledgementsViewController.swift
//  Player2
//
//  Created by Michael Zeller on 4/2/17.
//  Copyright © 2017 Lights and Shapes. All rights reserved.
//

import UIKit

class AcknowledgementsViewController: UIViewController {
    @IBOutlet weak var text: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        text.isUserInteractionEnabled = true
        text.isSelectable = true
        text.isScrollEnabled = true
        text.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouchType.indirect.rawValue)]
        
        if let filepath = Bundle.main.path(forResource: "Acknowledgements", ofType: "txt") {
            do {
                let contents = try String(contentsOfFile: filepath)
                self.text.text = contents
            } catch {
                self.text.text = "Acknowledgements"
            }
        } else {
            self.text.text = "Acknowledgements"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.text.setContentOffset(CGPoint.zero, animated: false)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

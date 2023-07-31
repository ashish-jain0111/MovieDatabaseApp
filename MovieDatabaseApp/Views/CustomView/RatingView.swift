//
//  RatingView.swift
//  MovieDatabaseApp
//
//  Created by Ashish Jain on 31/07/23.
//

import UIKit

class RatingView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingSourceTextField: UITextField!
    @IBOutlet weak var ratingLabel: UILabel!

    override init(frame: CGRect) {
            super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            let viewFromXib = Bundle.main.loadNibNamed("RatingView", owner: self, options: nil)![0] as! UIView
            viewFromXib.frame = self.bounds
            viewFromXib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(viewFromXib)
        }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

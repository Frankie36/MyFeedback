//
//  ResponseTableViewCell.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 05/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//

import UIKit

class ResponseTableViewCell: UITableViewCell {
    @IBOutlet weak var lblSurvey: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    
    var customQuery : CustomQuery?
    
    // the delegate, remember to set to weak to prevent cycles
    weak var delegate : ResponseTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Add action to perform when the button is tapped
        self.btnSend.addTarget(self, action: #selector(sendResponse(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sendResponse(_ sender: Any) {
        // ask the delegate (in most case, its the view controller) to
        // call the function 'subscribeButtonTappedFor' on itself.
        if let customQuery = customQuery,
           let delegate = delegate {
            self.delegate?.responseTableViewCell(self, subscribeButtonTappedFor: customQuery)
        }
    }
}

// Only class object can conform to this protocol (struct/enum can't)
protocol ResponseTableViewCellDelegate: AnyObject {
    func responseTableViewCell(_ responseTableViewCell: ResponseTableViewCell, subscribeButtonTappedFor customQuery: CustomQuery)
}


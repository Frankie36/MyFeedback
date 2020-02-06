//
//  SurveyTableViewCell.swift
//  MyFeedback
//
//  Created by Francis Ngunjiri on 05/02/2020.
//  Copyright © 2020 Francis Ngunjiri. All rights reserved.
//

import UIKit

class SurveyTableViewCell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

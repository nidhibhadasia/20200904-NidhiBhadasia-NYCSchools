//
//  SchoolTableViewCell.swift
//  20200904-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 9/4/20.
//  Copyright © 2020 Nidhi. All rights reserved.
//

import UIKit

protocol TableCellDelegate:AnyObject {
    //Delegate methods for tableview cell
    func tapToAddress(index:Int)
    func tapToCall(index:Int)
}

class SchoolTableViewCell: UITableViewCell {
    
    weak var delegate : TableCellDelegate?
    
    @IBOutlet weak var lblSchoolName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblTestTakers: UILabel!
    @IBOutlet weak var lblMath: UILabel!
    @IBOutlet weak var lblReading: UILabel!
    @IBOutlet weak var lblWriting: UILabel!
    @IBOutlet weak var lblTestNumbers: UILabel!
    @IBOutlet weak var lblMathNumber: UILabel!
    @IBOutlet weak var lblReadingNumber: UILabel!
    @IBOutlet weak var lblWritingNumber: UILabel!
    @IBOutlet weak var lblFooter: UILabel!
    @IBOutlet weak var separatorBottom: UIView!
    @IBOutlet weak var btnAddress: UIButton!
    @IBOutlet weak var btnPhoneNumber: UIButton!
    @IBOutlet weak var spacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var middleSpacingConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorSpacingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        //Set location image
        let imageAddress =  UIImage(systemName: "mappin.and.ellipse", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.customColor, renderingMode: .alwaysOriginal)
        self.btnAddress.setImage(imageAddress, for: .normal)
      
        //Set phone image
        let phoneImage = UIImage(systemName: "phone", withConfiguration: UIImage.SymbolConfiguration(weight: .regular))?.withTintColor(.customColor, renderingMode: .alwaysOriginal)
        self.btnPhoneNumber.setImage(phoneImage, for: .normal)
    }
    
    func configureCell(model: SchoolViewModel, detail: SchoolDetailModel?){
        //Configure Cell
        self.lblSchoolName.text = model.schoolName
        self.lblAddress.text = model.address
        self.lblPhoneNumber.text = model.phoneNumber
        self.lblTestTakers.text = ""
        self.lblMath.text = ""
        self.lblReading.text = ""
        self.lblWriting.text = ""
        self.lblTestNumbers.text = ""
        self.lblMathNumber.text = ""
        self.lblReadingNumber.text = ""
        self.lblWritingNumber.text = ""
        self.lblFooter.text = ""
        self.separatorBottom.isHidden = true;
        self.spacingConstraint.constant = 0
        self.middleSpacingConstraint.constant = 0
        self.separatorSpacingConstraint.constant = 0
        if let schoolDetail = detail {
            //Configure when cell is expanded
           self.spacingConstraint.constant = 10
           self.middleSpacingConstraint.constant = 8
           self.separatorSpacingConstraint.constant = 8
           self.separatorBottom.isHidden = false;
           self.lblFooter.text = "Average SAT results"
           self.lblTestTakers.text = "SAT Test Takers"
           self.lblMath.text = "Math\nScore"
           self.lblReading.text = "Reading\nScore"
           self.lblWriting.text = "Writing\nScore"
           self.lblTestNumbers.text = schoolDetail.testTakerNumber
           self.lblMathNumber.text = schoolDetail.mathScore
           self.lblReadingNumber.text = schoolDetail.readingScore
           self.lblWritingNumber.text = schoolDetail.writtenScore
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - IBAction
    @IBAction func addressTapped(_ sender: UIButton) {
        delegate?.tapToAddress(index: self.tag)
    }
    
    @IBAction func callTapped(_ sender: UIButton) {
        delegate?.tapToCall(index: self.tag)
    }
}

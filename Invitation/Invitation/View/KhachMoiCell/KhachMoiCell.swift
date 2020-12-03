//
//  KhachMoiCell.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

class KhachMoiCell: BaseTableViewCell, UITextViewDelegate {
    
//    @IBOutlet weak var titleNameTextView: UITextView!
    
    @IBOutlet weak var titleAgeTextView: UITextView!
    
    @IBOutlet weak var titleAddressTV: UITextView!
    
    @IBOutlet weak var titlePhoneTV: UITextView!
    
    @IBOutlet weak var titleStatusTV: UITextView!
    
    @IBOutlet weak var tenTextView: UITextView!
    
    @IBOutlet weak var tuoiTextView: UITextView!
    
    @IBOutlet weak var diaChiTextView: UITextView!
    
    @IBOutlet weak var quanHeTextView: UITextView!
    
    @IBOutlet weak var phoneTextView: UITextView!
    
    @IBOutlet weak var statusSwitch: UISwitch!
    
    fileprivate let application = UIApplication.shared
    var infoKhachMoi = ThongTinKhachMoiModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        phoneTextView.delegate = self
        setFont()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setFont() {
        quanHeTextView.setDefaultTitleField()
        titleAgeTextView.setDefaultTitleField()
        titleAddressTV.setDefaultTitleField()
        titlePhoneTV.setDefaultTitleField()
        titleStatusTV.setDefaultTitleField()
        
        statusSwitch.set(width: 45, height: 25)
    }
    
    func fillData() {
        tenTextView.text = infoKhachMoi.ten
        tuoiTextView.text = infoKhachMoi.tuoi
        diaChiTextView.text = infoKhachMoi.dia_chi
        quanHeTextView.text = infoKhachMoi.quan_he
        
        //fff
        statusSwitch.isOn = infoKhachMoi.status
        phoneTextView.text = "\(infoKhachMoi.phone)"
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == phoneTextView {
            phoneTextView.resignFirstResponder()
            calling()
        }
    }
    
    func calling() {
        let urlSchema = "tel:"
        let numberToCall = infoKhachMoi.phone
        if let numberToCallURL = URL(string: "\(urlSchema)\(String(describing: numberToCall))") {
            if UIApplication.shared.canOpenURL(numberToCallURL) {
                application.open(numberToCallURL, options: [:], completionHandler: nil)
            } else {
                // show alert
            }
        }
    }
    
}

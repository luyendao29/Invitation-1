//
//  ChiTietKhachMoiVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/2/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class ChiTietKhachMoiVC: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var quanHeTextView: UITextView!
    @IBOutlet weak var tenTextView: UITextView!
    @IBOutlet weak var tuoiTextView: UITextView!
    @IBOutlet weak var diaChiTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var longitudeTextView: UITextView!
    @IBOutlet weak var latitudeTextView: UITextView!
    @IBOutlet weak var switchStatus: UISwitch!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    fileprivate let application = UIApplication.shared
    var detailKhach = ThongTinKhachMoiModel()
    var closureUpdate: ((ThongTinKhachMoiModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillData()
        setDelegate()
        isEnableHideKeyBoardWhenTouchInScreen = true
        
        setShadowButton(button: cancelButton)
        setShadowButton(button: updateButton)
    }
    
    func setShadowButton(button: UIButton) {
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
    }
    
    func setDelegate() {
        quanHeTextView.delegate = self
        tenTextView.delegate = self
        tuoiTextView.delegate = self
        diaChiTextView.delegate = self
        phoneTextView.delegate = self
        longitudeTextView.delegate = self
        latitudeTextView.delegate = self
    }
    
    func fillData() {
        quanHeTextView.text = detailKhach.quan_he
        tenTextView.text = detailKhach.ten
        tuoiTextView.text = detailKhach.tuoi
        phoneTextView.text = "\(detailKhach.phone)"
        diaChiTextView.text = detailKhach.dia_chi
        longitudeTextView.text = "\(detailKhach.longitude)"
        latitudeTextView.text = "\(detailKhach.latitude)"
    }
    
    func editKhachMoi() -> ThongTinKhachMoiModel {
        let newInfo = ThongTinKhachMoiModel()
        newInfo.id = detailKhach.id
        newInfo.ten = tenTextView.text
        newInfo.tuoi = tuoiTextView.text
        newInfo.dia_chi = diaChiTextView.text
        newInfo.quan_he = quanHeTextView.text
        if let longitude = longitudeTextView.text.toDouble(), let latitude = latitudeTextView.text.toDouble() {
            newInfo.longitude = longitude
            newInfo.latitude = latitude
        }
        
        if let phone = phoneTextView.text.toInt() {
            newInfo.phone = phone
        }
        newInfo.status = switchStatus.isOn
        
        return newInfo
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapUpdate(_ sender: Any) {
        showAlertWithConfirm(type: .notice, message: "Bạn chắc chắn muốn cập nhật thông tin đã chỉnh sửa", cancel: {
            
        }, ok: {
            //            self.editKhachMoi()
            if let closureUpdate = self.closureUpdate {
                closureUpdate(self.editKhachMoi())
            }
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func tapSelectMap(_ sender: Any) {
        title = ""
        let vc = Storyboard.Main.chonDiaDiemVC()
        vc.titleString = "Nhà khách mời"
        vc.passCoordinate = { [weak self] infoKM in
            self?.longitudeTextView.text = "\(infoKM.longitude)"
            self?.latitudeTextView.text = "\(infoKM.latitude)"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapCalling(_ sender: Any) {
        calling()
    }
    
    func calling() {
        let urlSchema = "tel:"
        guard let numberToCall = phoneTextView.text.toDouble() else { return }
        if let numberToCallURL = URL(string: "\(urlSchema)\(String(describing: numberToCall))") {
            if UIApplication.shared.canOpenURL(numberToCallURL) {
                application.open(numberToCallURL, options: [:], completionHandler: nil)
            } else {
                // show alert
            }
        }
    }
    
    //MARK: Delegate TextView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        return true
    }
    
}

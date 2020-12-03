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
    
    @IBOutlet weak var titleNoteTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    fileprivate let application = UIApplication.shared
    var detailKhach = ThongTinKhachMoiModel()
    var closureUpdate: ((ThongTinKhachMoiModel) -> ())?
    
    var relationLabel = UILabel()
    var nameLabel = UILabel()
    var ageLabel = UILabel()
    var phoneLabel = UILabel()
    var addressLabel = UILabel()
    var noteLabel = UILabel()
    
    var scrollKeybard: CGFloat = 0 {
        didSet {
            self.view.frame.origin.y = scrollKeybard
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillData()
        setDelegate()
        isEnableHideKeyBoardWhenTouchInScreen = true
        
        setShadowButton(button: cancelButton)
        setShadowButton(button: updateButton)
        
        setPlaceholder(textView: quanHeTextView, label: relationLabel, text: "Quan hệ")
        setPlaceholder(textView: tenTextView, label: nameLabel, text: "Tên khách mời")
        setPlaceholder(textView: tuoiTextView, label: ageLabel, text: "Tuổi")
        setPlaceholder(textView: phoneTextView, label: phoneLabel, text: "Số điện thoại")
        setPlaceholder(textView: diaChiTextView, label: addressLabel, text: "Địa chỉ")
        setPlaceholder(textView: noteTextView, label: noteLabel, text: "Nhập ghi chú (không bắt buộc)")
        switchStatus.set(width: 45, height: 25)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Chi tiết khách mời"
    }
    
    func setPlaceholder(textView: UITextView, label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.italicSystemFont(ofSize: (textView.font?.pointSize)!)
        label.sizeToFit()
        textView.addSubview(label)
        label.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        label.textColor = UIColor.lightGray
        label.isHidden = !textView.text.isEmpty
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
        noteTextView.delegate = self
    }
    
    func fillData() {
        quanHeTextView.text = detailKhach.quan_he
        tenTextView.text = detailKhach.ten
        tuoiTextView.text = detailKhach.tuoi
        phoneTextView.text = detailKhach.phone.toString()
        diaChiTextView.text = detailKhach.dia_chi
        longitudeTextView.text = "\(detailKhach.longitude)"
        latitudeTextView.text = "\(detailKhach.latitude)"
        switchStatus.isOn = detailKhach.status
        noteTextView.text = detailKhach.note
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
        newInfo.note = noteTextView.text
        
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
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == noteTextView {
            scrollKeybard = -200
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
        }
        switch textView {
        case tuoiTextView:
            return tuoiTextView.text.count + (text.count - range.length) <= 2
        case phoneTextView:
            return phoneTextView.text.count + (text.count - range.length) <= 14
        default:
            break
        }
        return true
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        switch textView {
        case quanHeTextView:
            relationLabel.isHidden = !quanHeTextView.text.isEmpty
        case tenTextView:
            nameLabel.isHidden = !tenTextView.text.isEmpty
        case tuoiTextView:
            ageLabel.isHidden = !tuoiTextView.text.isEmpty
        case phoneTextView:
            phoneLabel.isHidden = !phoneTextView.text.isEmpty
        case diaChiTextView:
            addressLabel.isHidden = !diaChiTextView.text.isEmpty
        case noteTextView:
             noteLabel.isHidden = !noteTextView.text.isEmpty
        default:
            break
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollKeybard = 0
    }
    
}

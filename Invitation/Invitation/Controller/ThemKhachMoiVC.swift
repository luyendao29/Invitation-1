//
//  ThemKhachMoiVC.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import RealmSwift

class ThemKhachMoiVC: BaseViewController, UITextViewDelegate {
    @IBOutlet weak var titleNameInviteeTextView: UITextView!
    @IBOutlet weak var ageInviteeTextView: UITextView!
    @IBOutlet weak var titleAddressTextView: UITextView!
    @IBOutlet weak var titlePhoneTextView: UITextView!
    @IBOutlet weak var titleRelationTextView: UITextView!
    
    @IBOutlet weak var tenKhachMoiTextView: UITextView!
    
    @IBOutlet weak var tuoiTextView: UITextView!
    @IBOutlet weak var diaChiTextView: UITextView!
    @IBOutlet weak var phoneTextView: UITextView!
    
    @IBOutlet weak var quanHeTextView: UITextView!
    @IBOutlet weak var chiTietQuanHeTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    var totalItem: Int = 0
    let realm = try! Realm()
    var listKhachMoi = [ThongTinKhachMoiModel]()
    var dropdown = DropDown()
    var titleString: String?
    
    var tenLabel: UILabel!
    var tuoiLabel: UILabel!
    var diaChiLabel: UILabel!
    var dienThoaiLabel: UILabel!
    var quanHeLabel: UILabel!
    
    var dataKM = ThongTinKhachMoiModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isEnableHideKeyBoardWhenTouchInScreen = true
        print(Realm.Configuration.defaultConfiguration)
        
        generalPlaceHolder()
        setDelegate()
        setFont()
        setShadowButton(button: cancelButton)
        setShadowButton(button: addButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setDisplay()
    }
    
    func setShadowButton(button: UIButton) {
        button.layer.cornerRadius = 8
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.25
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
    }
    
    func setFont() {
        titleNameInviteeTextView.setDefaultTitleField()
        ageInviteeTextView.setDefaultTitleField()
        titleAddressTextView.setDefaultTitleField()
        titlePhoneTextView.setDefaultTitleField()
        titleRelationTextView.setDefaultTitleField()
        quanHeTextView.setDefaultTitleField()
        
        tenKhachMoiTextView.setDefaultFont()
        tuoiTextView.setDefaultFont()
        diaChiTextView.setDefaultFont()
        phoneTextView.setDefaultFont()
        chiTietQuanHeTextView.setDefaultFont()
    }
    
    func setDelegate() {
        tenKhachMoiTextView.delegate = self
        tuoiTextView.delegate = self
        diaChiTextView.delegate = self
        quanHeTextView.delegate = self
        chiTietQuanHeTextView.delegate = self
        phoneTextView.delegate = self
    }
    
    func setDisplay() {
        if let titleString = titleString {
            title = titleString
        }
    }
    
    func generalPlaceHolder() {
        tenLabel = UILabel()
        tuoiLabel = UILabel()
        diaChiLabel = UILabel()
        dienThoaiLabel = UILabel()
        quanHeLabel = UILabel()
        
        setPlaceholder(textView: tenKhachMoiTextView, label: tenLabel, text: "Tên khách mời")
        setPlaceholder(textView: tuoiTextView, label: tuoiLabel, text: "Tuổi khách mời")
        setPlaceholder(textView: diaChiTextView, label: diaChiLabel, text: "Địa chỉ")
        setPlaceholder(textView: phoneTextView, label: dienThoaiLabel, text: "Số điện thoại")
        setPlaceholder(textView: chiTietQuanHeTextView, label: quanHeLabel, text: "Chi tiết quan hệ")
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
    
    // MARK: - Action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func showRelation() {
        dropdown.dataSource = QuanHe.all.map { $0.value }
        
        dropdown.anchorView = quanHeTextView
        dropdown.direction = .bottom
        dropdown.bottomOffset = CGPoint(x: 0, y: quanHeTextView.bounds.size.height)
        //        dropDown.cellConfiguration = { [unowned self] (index, item) in
        //            return "- \(item) (option \(index))"
        //        }
        dropdown.dismissMode = .onTap
        
        //        dropdown.cellNib = UINib(nibName: CommissionTypeCell.identifier(), bundle: nil)
        
        //        dropdown.customCellConfiguration = { (Index, String, DropDownCell) -> Void in
        //            guard let cell = DropDownCell as? CommissionTypeCell else {
        //                return
        //            }
        //
        //            if let image = CommissionType.all[Index].image {
        //                cell.logoImageView.image = image
        //            }
        //            cell.backgroundColor = #colorLiteral(red: 0.3007350862, green: 0.5059738159, blue: 0.7095726132, alpha: 1)
        //        }
        
        //optional
        dropdown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            self.quanHeTextView.text = item
            self.chiTietQuanHeTextView.text = QuanHe.all[index].value
            self.chiTietQuanHeTextView.becomeFirstResponder()
            //            self.commissionType = CommissionType.all[index]
        }
        
        dropdown.show()
    }
    
    @IBAction func tapSelectInMap(_ sender: Any) {
        title = ""
        let vc = Storyboard.Main.chonDiaDiemVC()
        vc.titleString = "Nhà khách mời"
        vc.passCoordinate = { [weak self] infoKM in
            self?.dataKM.longitude = infoKM.longitude
            self?.dataKM.latitude = infoKM.latitude
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        switch textView {
        case quanHeTextView:
            quanHeTextView.resignFirstResponder()
            showRelation()
        default:
            break
        }
    }
    
    //    func textViewDidChange(_ textView: UITextView) {
    //        switch textView {
    //        case tenKhachMoiTextView:
    //            tenLabel.isHidden = !tenKhachMoiTextView.text.isEmpty
    //        case tuoiTextView:
    //            tuoiLabel.isHidden = !tuoiTextView.text.isEmpty
    //        case diaChiTextView:
    //            diaChiLabel.isHidden = !diaChiTextView.text.isEmpty
    //        case chiTietQuanHeTextView:
    //            quanHeLabel.isHidden = !chiTietQuanHeTextView.text.isEmpty
    //        default:
    //            break
    //        }
    //    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        switch textView {
        case tenKhachMoiTextView:
            tenLabel.isHidden = !tenKhachMoiTextView.text.isEmpty
        case tuoiTextView:
            tuoiLabel.isHidden = !tuoiTextView.text.isEmpty
        case diaChiTextView:
            diaChiLabel.isHidden = !diaChiTextView.text.isEmpty
        case chiTietQuanHeTextView:
            quanHeLabel.isHidden = !chiTietQuanHeTextView.text.isEmpty
        case phoneTextView:
            dienThoaiLabel.isHidden = phoneTextView.text != ""
        default:
            break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            switch textView {
            case tenKhachMoiTextView:
                tuoiTextView.becomeFirstResponder()
            case tuoiTextView:
                diaChiTextView.becomeFirstResponder()
            case quanHeTextView:
                phoneTextView.becomeFirstResponder()
            default:
                textView.resignFirstResponder()
            }
        }
        return true
    }
    
    @IBAction func tapGetContact(_ sender: Any) {
        title = ""
        let vc = Storyboard.Main.phonebookVC()
        vc.closureContact = { [weak self] contact in
            self?.phoneTextView.text = contact.telephone
            if self?.tenKhachMoiTextView.text == "" {
                self?.tenKhachMoiTextView.text = contact.firstName
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapCancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tapAdd(_ sender: Any) {
        let newUser = ThongTinKhachMoiModel()
        newUser.id = String.random()
        
        newUser.ten = tenKhachMoiTextView.text
        newUser.tuoi = tuoiTextView.text
        newUser.dia_chi = diaChiTextView.text
        newUser.quan_he = chiTietQuanHeTextView.text
        if let phone = phoneTextView.text.toInt() {
            newUser.phone = phone
        }
        
        newUser.longitude = dataKM.longitude
        newUser.latitude = dataKM.latitude
        
        try! realm.write {
            realm.add(newUser)
        }
        
        let results = realm.objects(ThongTinKhachMoiModel.self)
        if results.count == totalItem + 1 {
            totalItem += 1
            showAlert(type: .notice, message: "Thêm khách mời thành công", close: {
                self.cleanData()
            })
        }
    }
    
    func cleanData() {
        tenKhachMoiTextView.text = ""
        tuoiTextView.text = ""
        diaChiTextView.text = ""
        phoneTextView.text = ""
        quanHeTextView.text = ""
        chiTietQuanHeTextView.text = ""
    }
    
    func addObjectToRealm() {
//        https://stackoverflow.com/questions/58976630/swift-realm-completion-after-successfully-adding-item
    }

}

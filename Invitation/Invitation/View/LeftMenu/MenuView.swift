//
//  MenuView.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 12/4/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit

struct DataMenuView {
    var isOpen: Bool?
    var action: ActionMainMenuView?
}

enum ActionMainMenuView {
    case showImage    //hoa hong
    case showListInvitee  //diem ban
    case lich_su_moi_khach
    case sms
    case notice
    case tutorial
    case null
    
    static let all = [showImage, showListInvitee, lich_su_moi_khach, sms, notice, tutorial, null]
    
    var text: String {
        get {
            switch self {
            case .showImage:
                return "Ảnh cưới"
            case .showListInvitee:
                return "Danh sách khách mời"
            case .lich_su_moi_khach:
                return "Lịch sử mời khách"
            case .sms:
                return "Tin nhắn"
            case .notice:
                return "Lịch sử nợ"
            case .tutorial:
                return "Hướng dẫn sử dụng"
            case .null:
                return "Nothing"
            }
        }
    }
}
    
    class MenuView: UIView, UIPreviewActionItem, ToggleViewProtocol, UITableViewDataSource, UITableViewDelegate {
        
        
        @IBOutlet weak var tableView: UITableView!
        
        var title: String = ""
        
        var isOpen: Bool = false
        
        @IBOutlet weak var menu: UIView!
        
        var closureMenu: ((DataMenuView)->(Void))?
        
        
        var closeDistance: CGFloat = 0.0
        
        var showDistance: CGFloat = 0
        
        var view: UIView!
        
        var coverAlpha: CGFloat = 0.4
        
        @IBOutlet weak var controlConstraint: NSLayoutConstraint!
        
        @IBOutlet weak var effectView: UIVisualEffectView!
        
        @IBOutlet weak var corverButton: UIButton!
        
        @IBOutlet weak var revenueButton: UIButton!    //hoa hong
        @IBOutlet weak var sellPointButton: UIButton!  //diem ban
        @IBOutlet weak var historyButton: UIButton!
        @IBOutlet weak var smsButton: UIButton!
        @IBOutlet weak var noticeButton: UIButton!
        @IBOutlet weak var logoutButton: UIButton!
        
        var action = ActionMainMenuView.null
        var dataMenu = DataMenuView()
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            view = self
            setupToggleView(distance: menu.frame.height + 100)
            //         self.imageUpandDownOfSelect.transform = CGAffineTransform(rotationAngle: self.isOpen ? 0 : (45.0 * .pi) / 1.0)
            fillData()
            setDisplay()
            tableView.dataSource = self
            tableView.delegate = self
            
            tableView.register(MenuLeftCell.nib(), forCellReuseIdentifier: MenuLeftCell.identifier())
        }
        
        func setDisplay() {
            setShadowView(view: menu)
            effectView.isHidden = true
        }
        
        func setShadowView(view: UIView) {
            view.layer.cornerRadius = 16
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.5
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = 10
        }
        
        func fillData() {
            
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return ActionMainMenuView.all.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuLeftCell.identifier(), for: indexPath) as! MenuLeftCell
            cell.titleMenuTextView.text = ActionMainMenuView.all[indexPath.row].text
            //        cell.iconImageView.image = UIImage(named: arrayImage[indexPath.row])
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //        if role == "DIEMBAN" {
            //            selectMenu = MainLeftMenu.allDIEMBAN[indexPath.row]
            //        } else {
            //            selectMenu = MainLeftMenu.allDaiLy[indexPath.row]
            //        }
            //
            //        dataMenu.isOpen = true
            //        dataMenu.action = selectMenu
            //        closureMenu?(dataMenu)
        }
        
        
        @IBAction func onClickSelected(_ sender: UIButton) {
            
        }
        
        @IBAction func toggle(_ sender: UIButton! = nil) {
            isOpen = !isOpen
            dataMenu.isOpen = isOpen
            closureMenu?(dataMenu)
            performToggle(isOpen: isOpen)
            UIView.animate(withDuration: 0.35) {
                //            self.imageUpandDownOfSelect.transform = CGAffineTransform(rotationAngle: self.isOpen ? 0 : (45.0 * .pi) / 1.0)
                self.alpha = self.isOpen ? 1 : 0
                self.layoutIfNeeded()
            }
        }
        
        @IBAction func tapCoverButton(_ sender: UIButton!) {
            showHideMenu()
        }
        
        func showHideMenu() {
            isOpen = !isOpen
            dataMenu.isOpen = isOpen
            dataMenu.action = .null
            closureMenu?(dataMenu)
            performToggle(isOpen: isOpen)
            UIView.animate(withDuration: 0.35) {
                self.alpha = self.isOpen ? 1 : 0
                self.layoutIfNeeded()
            }
        }
        
        @IBAction func selectItemMenu(_ sender: UIButton!) {
            switch sender {
            case revenueButton:
                dataMenu.action = .showImage
            case sellPointButton:
                dataMenu.action = .showListInvitee
            case historyButton:
                dataMenu.action = .lich_su_moi_khach
            case smsButton:
                dataMenu.action = .sms
            case noticeButton:
                dataMenu.action = .notice
            case logoutButton:
                dataMenu.action = .tutorial
            default:
                dataMenu.action = .null
            }
            closureMenu?(dataMenu)
        }
        
        
}



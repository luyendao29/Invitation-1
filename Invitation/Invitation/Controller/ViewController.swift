//
//  ViewController.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

enum QuanHe {
    case ho_hang
    case ban_be
    case hang_xom
    case khac
    
    static var all = [ho_hang, ban_be, hang_xom, khac]
    
    var value: String {
        get {
            switch self {
            case .ho_hang:
                return "Họ hàng"
            case .ban_be:
                return "Bạn bè"
            case .hang_xom:
                return "Hàng xóm"
            case .khac:
                return "Khác"
            }
        }
    }
}

enum LoaiKhach {
    case chua_moi
    case da_moi
    case tat_ca
}

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var pageLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var addButton: UIButton!
    
    let realm = try! Realm()
    //    var totalKhach: Results<ThongTinKhachMoiModel>?
    var totalKhach = [ThongTinKhachMoiModel]()
    var listKM = [ThongTinKhachMoiModel]()
    var listKCM = [ThongTinKhachMoiModel]()
    var suggestKhachMoi = [ThongTinKhachMoiModel]()
    var countDisplay: Int = 0 {
        didSet {
            pageLabel.text = "\(countDisplay)"
        }
    }
    var loaiKhach = LoaiKhach.tat_ca
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEnableHideKeyBoardWhenTouchInScreen = true
        registerCell()
        segmentedControl.selectedSegmentIndex = 0
        
        setShadowView(view: searchView)
        searchTextField.delegate = self
        setShadowButton(button: addButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        title = "Minh Dương ❦ Minh Huyền"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        getAll()
        
        filterKhachMoi()
        tableView.reloadData()
    }
    
    func setShadowButton(button: UIButton) {
        
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 10
    }
    
    func getAll() {
        let results = realm.objects(ThongTinKhachMoiModel.self).sorted(byKeyPath: "ten", ascending: true).toArray(ofType: ThongTinKhachMoiModel.self)
        print(results.count)
        totalKhach = results
        
        var tempChuaMoi = [ThongTinKhachMoiModel]()
        var tempDaMoi = [ThongTinKhachMoiModel]()
        
        for item in results {
            if item.status {
                tempDaMoi.append(item)
            } else {
                tempChuaMoi.append(item)
            }
        }
        listKM = tempDaMoi
        listKCM = tempChuaMoi
//        suggestKhachMoi = totalKhach
//        tableView.reloadData()
    }
    
    func registerCell() {
        tableView.register(KhachMoiCell.nib(), forCellReuseIdentifier: KhachMoiCell.identifier())
    }
    
    func setShadowView(view: UIView) {
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestKhachMoi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KhachMoiCell.identifier(), for: indexPath) as! KhachMoiCell
        
        cell.infoKhachMoi = suggestKhachMoi[indexPath.row]
        cell.fillData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = Storyboard.Main.chiTietKhachMoiVC()
        
        vc.detailKhach = suggestKhachMoi[indexPath.row]
        title = ""
        vc.title = "Thông tin chi tiết"
        vc.closureUpdate = { [weak self] user in
            self?.suggestKhachMoi[indexPath.row] = user
            
            let realm = try! Realm()
            //                let offers = realm.... look up your objects
            let offers = realm.objects(ThongTinKhachMoiModel.self)
            realm.beginWrite()
            for offer in offers {
                if offer.id == user.id {
                    offer.ten = user.ten
                    offer.tuoi = user.tuoi
                    offer.dia_chi = user.dia_chi
                    offer.quan_he = user.quan_he
                    
                    offer.phone = user.phone
                    offer.status = user.status
                    offer.longitude = user.longitude
                    offer.latitude = user.latitude
                    offer.note = user.note
                }
            }
            try! realm.commitWrite()
            
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                let book = suggestKhachMoi[indexPath.row]
                // realm
                let realm = try Realm()

                // edit book
                try realm.write {
                    realm.delete(book)
//                    suggestKhachMoi.remove(at: indexPath.row)
                    getAll()
                    filterKhachMoi()
                }
            } catch {
                print("Lỗi Delete đối tượng")
            }
            
            
        }
    }
    
    @IBAction func tapSegmentedControl(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            loaiKhach = .tat_ca
        case 1:
            loaiKhach = .da_moi
        case 2:
            loaiKhach = .chua_moi
        default:
            break
        }
        getAll()
        filterKhachMoi()
        countDisplay = suggestKhachMoi.count
    }
    
    //them khach moi
    @IBAction func tapNextAdd(_ sender: Any) {
        let vc = Storyboard.Main.themKhachMoiVC()
        title = ""
        vc.totalItem = totalKhach.count
        vc.titleString = "Thêm khách mời"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterKhachMoi() {
        switch loaiKhach {
        case .da_moi:
            if searchTextField.text == "" {
                suggestKhachMoi = listKM
            } else {
                getResultFilter(array: listKM)
            }
        case .chua_moi:
            if searchTextField.text == "" {
                suggestKhachMoi = listKCM
            } else {
                getResultFilter(array: listKCM)
            }
        case .tat_ca:
            if searchTextField.text == "" {
                suggestKhachMoi = totalKhach
            } else {
                getResultFilter(array: totalKhach)
            }
        }
        countDisplay = suggestKhachMoi.count
        tableView.reloadData()
    }
    
    func getResultFilter(array: [ThongTinKhachMoiModel]) {
        guard let text = searchTextField.text?.lowercased() else {
            return
        }
        suggestKhachMoi = array.filter { (data: ThongTinKhachMoiModel) in
            if let name = data.ten?.lowercased(), let address = data.dia_chi?.lowercased()  {
                let phone = data.phone.toString()
                if name.range(of: text) != nil || address.range(of: text) != nil || phone.range(of: text) != nil {
                    return true
                }
                
            }
            return false
        }
        countDisplay = suggestKhachMoi.count
    }
    //MARK: UITextField Delegate
    func textFieldDidChangeSelection(_ textField: UITextField) {
        filterKhachMoi()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


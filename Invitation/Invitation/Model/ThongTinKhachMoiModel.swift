//
//  ThongTinKhachMoiModel.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import RealmSwift
import UIKit

class ThongTinKhachMoiModel: Object {
    @objc dynamic var id: String?
    @objc dynamic var ten: String?
    @objc dynamic var tuoi: String?
    @objc dynamic var dia_chi: String?
    @objc dynamic var phone: Int = 0
    @objc dynamic var quan_he: String?
    @objc dynamic var status: Bool = false
    
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    @objc dynamic var note: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
}


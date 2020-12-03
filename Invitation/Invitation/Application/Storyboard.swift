//
//  Storyboard.swift
//  Invitation
//
//  Created by Dang Duy Cuong on 11/26/20.
//  Copyright © 2020 Dang Duy Cuong. All rights reserved.
//

import UIKit
struct Storyboard {
    
}

extension Storyboard {
    
    struct Main {
        static let manager = UIStoryboard(name: "Main", bundle: nil)
        
        static func themKhachMoiVC() -> ThemKhachMoiVC {
            return manager.instantiateViewController(withIdentifier: "ThemKhachMoiVC") as! ThemKhachMoiVC
        }
        
        static func chonDiaDiemVC() -> ChonDiaDiemVC {
            return manager.instantiateViewController(withIdentifier: "ChonDiaDiemVC") as! ChonDiaDiemVC
        }
        
        static func chiTietKhachMoiVC() -> ChiTietKhachMoiVC {
            return manager.instantiateViewController(withIdentifier: "ChiTietKhachMoiVC") as! ChiTietKhachMoiVC
        }
        
        static func phonebookVC() -> PhonebookVC {
            return manager.instantiateViewController(withIdentifier: "PhonebookVC") as! PhonebookVC
        }
    }

}

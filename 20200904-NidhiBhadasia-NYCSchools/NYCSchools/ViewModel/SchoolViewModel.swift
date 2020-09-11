//
//  SchoolViewModel.swift
//  20200904-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 9/4/20.
//  Copyright © 2020 Nidhi. All rights reserved.
//

import Foundation
struct  SchoolViewModel {
    var dbn: String? = nil
    var schoolName: String? = nil
    var phoneNumber: String? = nil
    var address :String? = nil
    var schoolModel: SchoolModel? = nil
    
    // MARK: - Initialization
    init(model: SchoolModel) {
        self.schoolModel = model
        self.dbn = schoolModel?.dbn
        self.schoolName = schoolModel?.school_name
        self.phoneNumber = schoolModel?.phone_number
        self.address = getAddress()
    }
    // MARK: - Custom functions
    func getAddress()-> String {
        if let addressLine = schoolModel?.primary_address_line_1, let city = schoolModel?.city, let state = schoolModel?.state_code, let zip = schoolModel?.zip  {
            //let schoolname = schoolModel?.school_name  
            return "\(addressLine)\n\(city), \(state) \(zip)"
        }
        return ""
    }
}


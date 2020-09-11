//
//  Constant.swift
//  20200904-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 9/5/20.
//  Copyright © 2020 Nidhi. All rights reserved.
//

import Foundation

struct Constant {
    //Application Name
    static let AppName = "NYC High Schools"
    
    //API Token
    static let AppToken = "s5hI64TJ2g385BwnkHegjIZny"
    
    //API URL and Paging Limit
    struct API {
        static let pagingLimit = 10
        static let schoolListURL =
        "https://data.cityofnewyork.us/resource/s3k6-pzi2.json?$select=dbn,school_name,primary_address_line_1,city,state_code,zip,phone_number&$order=school_name%20ASC&$$app_token=\(AppToken)&$limit=\(pagingLimit)&$offset="
        static let schoolSATDataURL = "https://data.cityofnewyork.us/resource/f9bf-2cp4.json?&$$app_token=\(AppToken)&dbn="
        static let appleMapURL = "http://maps.apple.com/?address="
    }
    
    //Custom message
    struct AlertMessage {
        static let noSATDataFound = "The SAT results are not available."
        static let urlNotFound = "The requested URL cannot be found."
    }
}

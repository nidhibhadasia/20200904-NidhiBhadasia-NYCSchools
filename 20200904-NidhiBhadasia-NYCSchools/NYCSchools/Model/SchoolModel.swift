//
//  SchoolModel.swift
//  20200904-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 9/4/20.
//  Copyright © 2020 Nidhi. All rights reserved.
//

import Foundation

public struct SchoolModel: Codable {
    let dbn: String?
    let school_name: String?
    let primary_address_line_1: String?
    let city: String?
    let state_code: String?
    let zip: String?
    let phone_number: String?
}

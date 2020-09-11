//
//  SchoolDetailModel.swift
//  20200904-NidhiBhadasia-NYCSchools
//
//  Created by Guest1 on 9/4/20.
//  Copyright © 2020 Nidhi. All rights reserved.
//

import Foundation
public struct SchoolDetailModel: Codable {
    let dbn: String?
    let schoolName: String?
    let testTakerNumber: String?
    let writtenScore: String?
    let readingScore: String?
    let mathScore: String?
    
  enum CodingKeys: String, CodingKey {
        case dbn
        case schoolName = "school_name"
        case testTakerNumber = "num_of_sat_test_takers"
        case writtenScore = "sat_writing_avg_score"
        case readingScore = "sat_critical_reading_avg_score"
        case mathScore = "sat_math_avg_score"
   }
}

//
//  SchoolListViewControllerTests.swift
//  20200904-NidhiBhadasia-NYCSchoolsTests
//
//  Created by Guest1 on 9/6/20.
//  Copyright © 2020 Nidhi. All rights reserved.
//

import XCTest
@testable import _0200904_NidhiBhadasia_NYCSchools

class SchoolListViewControllerTests: XCTestCase {
    var schoolListVC: SchoolListViewController!
    let indexPath = IndexPath(row: 0, section: 0)
    let indexPath1 = IndexPath(row: 1, section: 0)

    let schoolModel1 = SchoolModel(dbn: "21K410", school_name: "Lincoln High School", primary_address_line_1: "2800 Ocean Parkway", city: "Brooklyn", state_code: "NY", zip: "11235", phone_number: "718-333-7400")
    let schoolModel2 = SchoolModel(dbn: "05M367", school_name: "Academy for Social Action", primary_address_line_1: "509 West 129th Street", city: "Manhattan", state_code: nil, zip: "10027", phone_number: "212-543-6301")
  
    let schoolDetail = SchoolDetailModel(dbn: "21K410", schoolName: "Lincoln High School", testTakerNumber: "33", writtenScore: "342", readingScore: "354", mathScore: "366")
      
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController:SchoolListViewController =     storyboard.instantiateViewController(withIdentifier: "SchoolListViewController") as! SchoolListViewController
        self.schoolListVC = viewController
        self.schoolListVC.loadView()
        self.schoolListVC.arSchoolVM = [SchoolViewModel(model: schoolModel1),SchoolViewModel(model: schoolModel2)]
        self.schoolListVC.arSchoolDetailModel = [self.schoolDetail]
    }
    func testViewDidLoad() {
        self.schoolListVC.viewDidLoad()
    }
    func testViewWillAppear() {
        self.schoolListVC.viewWillAppear(true)
    }
    func testVCHasATableView() {
        XCTAssertNotNil(self.schoolListVC.tableView)
        XCTAssertNotNil(self.schoolListVC.spinner)
        XCTAssertNotNil(self.schoolListVC.refreshCntl)
    }
    func testTableViewConfromsToTableViewDelegateProtocol() {
        XCTAssertTrue(self.schoolListVC.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(self.schoolListVC.responds(to: #selector(self.schoolListVC.tableView(_:didSelectRowAt:))))
    }
    
    func testTableViewHasDataSource() {
        XCTAssertNotNil(self.schoolListVC.tableView.dataSource)
    }
    
    func testTableViewConformsToTableViewDataSourceProtocol() {
        XCTAssertTrue(self.schoolListVC.conforms(to: UITableViewDataSource.self))
        XCTAssertTrue(self.schoolListVC.responds(to: #selector(self.schoolListVC.numberOfSections(in:))))
        XCTAssertTrue(self.schoolListVC.responds(to: #selector(self.schoolListVC.tableView(_:numberOfRowsInSection:))))
        XCTAssertTrue(self.schoolListVC.responds(to: #selector(self.schoolListVC.tableView(_:cellForRowAt:))))
    }
    func testTableViewConformsToTableViewDelegatProtocol() {
        XCTAssertTrue(self.schoolListVC.conforms(to: UITableViewDelegate.self))
        XCTAssertTrue(self.schoolListVC.responds(to: #selector(self.schoolListVC.tableView(_:didSelectRowAt:))))
    }

    func testTableViewCellHasReuseIdentifier() {
        let cell = self.schoolListVC.tableView(self.schoolListVC.tableView, cellForRowAt: indexPath) as? SchoolTableViewCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "SchoolTableViewCell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    func testTableViewCellDidSelect() {
        self.schoolListVC.tapOnSelectedIndexPath(indexPath: indexPath)
        XCTAssertEqual(self.schoolListVC.selectedRowIndex, -1, "not")
    }
    
    func testTableCellHasCorrectSchoolInfo() {
        //Test for cell 0
        let schoolVM = self.schoolListVC.arSchoolVM[indexPath.row]
        let cell = self.schoolListVC.tableView(self.schoolListVC.tableView, cellForRowAt: indexPath) as? SchoolTableViewCell
        guard let schoolName = schoolVM.schoolName else {
            XCTAssertEqual(cell?.lblSchoolName.text, "Lincoln High School")
            return
        }
        XCTAssertEqual(cell?.lblSchoolName.text, schoolName)
        XCTAssertEqual(cell?.lblAddress.text, schoolVM.getAddress())

        //Test for cell 1
        let schoolVM1 = self.schoolListVC.arSchoolVM[indexPath1.row]
        let cell1 = self.schoolListVC.tableView(self.schoolListVC.tableView, cellForRowAt: indexPath1) as? SchoolTableViewCell
        guard let schoolName1 = schoolVM1.schoolName else {
            XCTAssertEqual(cell1?.lblSchoolName.text, "Academy for Social Action")
            return
        }
        XCTAssertEqual(cell1?.lblSchoolName.text, schoolName1)
    }
    
    func testTableCellSATData() {
          //Test for cell 0
        self.schoolListVC.selectedRowIndex = 0
        let cell = self.schoolListVC.tableView(self.schoolListVC.tableView, cellForRowAt: indexPath) as? SchoolTableViewCell
    
          guard let mathScore = schoolDetail.mathScore else {
              XCTAssertEqual(cell?.lblMathNumber.text, "366")
              return
          }
          XCTAssertEqual(cell?.lblMathNumber.text, mathScore)
    }
   
    func testTableCellAction() {
        let cell = self.schoolListVC.tableView(self.schoolListVC.tableView, cellForRowAt: indexPath) as? SchoolTableViewCell
        cell?.btnAddress.sendActions(for: .touchUpInside)
        XCTAssert(cell?.btnAddress.image(for: .normal) != nil, "Image is not set")
        let actions = buttonActions(button: cell?.btnAddress)
          if let actions = actions {
            XCTAssert(actions.count > 0)
            XCTAssert(actions.contains("addressTapped:"))
          }
        
        cell?.btnPhoneNumber.sendActions(for: .touchUpInside)
        XCTAssert(cell?.btnPhoneNumber.image(for: .normal) != nil, "Image is not set")
             let actionsPhone = buttonActions(button: cell?.btnPhoneNumber)
             if let actionsPhone = actionsPhone {
               XCTAssert(actionsPhone.count > 0)
               XCTAssert(actionsPhone.contains("callTapped:"))
             }
    }
    func buttonActions(button: UIButton?) -> [String]? {
        return button?.actions(forTarget: self.schoolListVC, forControlEvent: .touchUpInside)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.schoolListVC = nil
        super.tearDown()
    }
}

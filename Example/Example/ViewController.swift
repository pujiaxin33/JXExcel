//
//  ViewController.swift
//  Example
//
//  Created by jiaxin on 2019/9/12.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit
import JXExcel

class ViewController: UIViewController {
    var excel: ExcelView!
    var dataSource = [[String]]()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false

        for row in 0..<50 {
            var rowData = [String]()
            for column in 0..<10 {
                rowData.append("r:\(row) c:\(column) grid")
            }
            dataSource.append(rowData)
        }

        excel = ExcelView(frame: CGRect.zero)
        excel.dataSource = self
        excel.delegate = self
        view.addSubview(excel)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        excel.frame = view.bounds
    }
}

extension ViewController: ExcelViewDataSource {
    func numberOfRows(in excelView: ExcelView) -> Int {
        return 50
    }

    func numberOfColumns(in excelView: ExcelView) -> Int {
        return 10
    }

    func excelView(_ excelView: ExcelView, columnNameAt column: Int) -> String {
        return "col:\(column)"
    }

    func excelView(_ excelView: ExcelView, rowDataAt row: Int) -> [String] {
        return dataSource[row]
    }

    func excelView(_ excelView: ExcelView, rowHeightAt row: Int) -> CGFloat {
        return 40
    }

    func excelView(_ excelView: ExcelView, columnWidthAt column: Int) -> CGFloat {
        return 120
    }

    func widthOfLeftHeader(in excelView: ExcelView) -> CGFloat {
        return 50
    }

    func heightOfTopHeader(in excelView: ExcelView) -> CGFloat {
        return 40
    }

//    func excelView(_ excelView: ExcelView, rowNameAt row: Int) -> String {
//        return "row:\(row)"
//    }
}

extension ViewController: ExcelViewDelegate {
    func excelView(_ excelView: ExcelView, didTapGridWith content: String) {
        print("didTapGridWith:\(content)")
    }

    func excelView(_ excelView: ExcelView, didTapColumnHeaderWith name: String) {
        print("didTapColumnHeaderWith:\(name)")
    }
}


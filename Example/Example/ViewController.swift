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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = false

        excel = ExcelView(frame: CGRect.zero)
        excel.dataSource = self
        excel.delegate = self
        view.addSubview(excel);
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

    func excelView(_ excelView: ExcelView, rowNameAt row: Int) -> String {
        return "row:\(row) 测试文本测试文本测试文本"
    }

    func excelView(_ excelView: ExcelView, columnNameAt column: Int) -> String {
        return "col:\(column) 测试文本测试文本测试文本测试文本"
    }

    func excelView(_ excelView: ExcelView, rowDatasAt row: Int) -> [String] {
        return ["r:\(row) 0 测试文本测试文本", "r:\(row) 1 测试文本测试文本", "r:\(row) 2 测试文本测试文本", "r:\(row) 3 测试文本测试文本", "r:\(row) 4 测试文本测试文本", "r:\(row) 5 测试文本测试文本", "r:\(row) 6 测试文本测试文本", "r:\(row) 7 测试文本测试文本", "r:\(row) 8 测试文本测试文本", "r:\(row) 9 测试文本测试文本", ]
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
}

extension ViewController: ExcelViewDelegate {
    func excelView(_ excelView: ExcelView, didTapGridWith content: String) {
        print("didTapGridWith:\(content)")
    }

    func excelView(_ excelView: ExcelView, didTapColumnNameWith name: String) {
        print("didTapColumnNameWith:\(name)")
    }
}


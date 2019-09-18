//
//  ExcelView.swift
//  JXExcel
//
//  Created by jiaxin on 2019/9/12.
//  Copyright © 2019 jiaxin. All rights reserved.
//

import UIKit

public protocol ExcelViewDataSource: AnyObject {
    func numberOfRows(in excelView: ExcelView) -> Int
    func numberOfColumns(in excelView: ExcelView) -> Int
    func excelView(_ excelView: ExcelView, rowNameAt row: Int) -> String
    func excelView(_ excelView: ExcelView, columnNameAt column: Int) -> String
    func excelView(_ excelView: ExcelView, rowDatasAt row: Int) -> [String]
    func excelView(_ excelView: ExcelView, rowHeightAt row: Int) -> CGFloat
    func excelView(_ excelView: ExcelView, columnWidthAt column: Int) -> CGFloat
    func widthOfLeftHeader(in excelView: ExcelView) -> CGFloat
    func heightOfTopHeader(in excelView: ExcelView) -> CGFloat
}

public protocol ExcelViewDelegate: AnyObject {
    func excelView(_ excelView: ExcelView, didTapGridWith content: String)
    func excelView(_ excelView: ExcelView, didTapColumnNameWith name: String)
}

open class ExcelView: UIView {
    open weak var dataSource: ExcelViewDataSource? {
        didSet {
            reloadData()
        }
    }
    open weak var delegate: ExcelViewDelegate?
    let topHeaderScrollView: UIScrollView
    let topHeaderBottomLine: UIView
    let topHeaderVerticalLine: UIView
    let leftHeaderTableView: UITableView
    let contentScrollView: UIScrollView
    let contentTableView: UITableView
    var contentWidth: CGFloat = 0
    var columnWidths = [CGFloat]()
    var columnNameLabels = [UILabel]()

    public override init(frame: CGRect) {
        topHeaderScrollView = UIScrollView(frame: CGRect.zero)
        topHeaderBottomLine = UIView()
        topHeaderVerticalLine = UIView()
        leftHeaderTableView = UITableView(frame: CGRect.zero, style: .plain)
        contentScrollView = UIScrollView(frame: CGRect.zero)
        contentTableView = UITableView(frame: CGRect.zero, style: .plain)
        super.init(frame: frame)
        setupViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        topHeaderScrollView = UIScrollView(frame: CGRect.zero)
        topHeaderBottomLine = UIView()
        topHeaderVerticalLine = UIView()
        leftHeaderTableView = UITableView(frame: CGRect.zero, style: .plain)
        contentScrollView = UIScrollView(frame: CGRect.zero)
        contentTableView = UITableView(frame: CGRect.zero, style: .plain)
        super.init(coder: aDecoder)
        setupViews()
    }

    func setupViews() {
        topHeaderScrollView.scrollsToTop = false
        topHeaderScrollView.showsHorizontalScrollIndicator = false
        topHeaderScrollView.bounces = false
        topHeaderScrollView.delegate = self
        addSubview(topHeaderScrollView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTopHeader(_:)))
        topHeaderScrollView.addGestureRecognizer(tap)

        topHeaderBottomLine.backgroundColor = .lightGray
        addSubview(topHeaderBottomLine)

        topHeaderVerticalLine.backgroundColor = .lightGray
        addSubview(topHeaderVerticalLine)

        leftHeaderTableView.scrollsToTop = false
        leftHeaderTableView.separatorStyle = .none
        leftHeaderTableView.showsVerticalScrollIndicator = false
        leftHeaderTableView.bounces = false
        leftHeaderTableView.register(LeftHeaderCell.self, forCellReuseIdentifier: "leftHeaderCell")
        leftHeaderTableView.dataSource = self
        leftHeaderTableView.delegate = self
        addSubview(leftHeaderTableView)

        contentScrollView.scrollsToTop = false
        contentScrollView.bounces = false
        contentScrollView.delegate = self
        addSubview(contentScrollView)

        contentTableView.scrollsToTop = true
        contentTableView.separatorStyle = .none
        contentTableView.bounces = false
        contentTableView.dataSource = self
        contentTableView.delegate = self
        contentScrollView.addSubview(contentTableView)

        if #available(iOS 11.0, *) {
            topHeaderScrollView.contentInsetAdjustmentBehavior = .never
            contentScrollView.contentInsetAdjustmentBehavior = .never
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard let dataSource = dataSource else {
            return
        }
        let leftHeaderWidth = dataSource.widthOfLeftHeader(in: self)
        let topHeaderHeight = dataSource.heightOfTopHeader(in: self)
        topHeaderScrollView.frame = CGRect(x: leftHeaderWidth, y: 0, width: bounds.size.width - leftHeaderWidth, height: topHeaderHeight)
        topHeaderScrollView.contentSize = CGSize(width: contentWidth, height: topHeaderHeight)
        topHeaderVerticalLine.frame = CGRect(x: leftHeaderWidth - 1/UIScreen.main.scale, y: 0, width: 1/UIScreen.main.scale, height: topHeaderHeight)
        let topHeaderBottomLineHeight = 1/UIScreen.main.scale
        topHeaderBottomLine.frame = CGRect(x: 0, y: topHeaderScrollView.bounds.size.height - topHeaderBottomLineHeight, width: bounds.size.width, height: topHeaderBottomLineHeight)
        leftHeaderTableView.frame = CGRect(x: 0, y: topHeaderHeight, width: leftHeaderWidth, height: bounds.size.height - topHeaderHeight)
        contentScrollView.frame = CGRect(x: leftHeaderWidth, y: topHeaderHeight, width: topHeaderScrollView.bounds.size.width, height: leftHeaderTableView.bounds.size.height)
        contentScrollView.contentSize = CGSize(width: contentWidth, height: contentScrollView.bounds.size.height)
        contentTableView.frame = CGRect(x: 0, y: 0, width: contentWidth, height: contentScrollView.bounds.size.height)
    }

    func reloadData() {
        reloadTopHeader()
        reloadLeftHeader()
    }

    func reloadTopHeader() {
        guard let dataSource = dataSource else {
            return
        }
        topHeaderScrollView.subviews.forEach { $0.removeFromSuperview() }
        let columnCount = dataSource.numberOfColumns(in: self)
        guard columnCount > 0 else {
            return
        }
        let headerHeight = dataSource.heightOfTopHeader(in: self)
        contentWidth = 0
        columnWidths.removeAll()
        columnNameLabels.removeAll()
        let labelMargin: CGFloat = 5
        for index in 0..<columnCount {
            let label = UILabel()
            label.font = .systemFont(ofSize: 13)
            let columnWidth = dataSource.excelView(self, columnWidthAt: index)
            columnWidths.append(columnWidth)
            label.frame = CGRect(x: contentWidth + labelMargin, y: 0, width: columnWidth - 2*labelMargin, height: headerHeight)
            label.text = dataSource.excelView(self, columnNameAt: index)
            topHeaderScrollView.addSubview(label)
            columnNameLabels.append(label)

            contentWidth += columnWidth

            let lineWidth = 1/UIScreen.main.scale
            let line = UIView()
            line.frame = CGRect(x: contentWidth, y: 0, width: lineWidth, height: headerHeight)
            line.backgroundColor = .lightGray
            topHeaderScrollView.addSubview(line)
        }
    }

    func reloadLeftHeader() {
        leftHeaderTableView.reloadData()
    }

    @objc func didTapTopHeader(_ tap: UITapGestureRecognizer) {
        guard let dataSource = dataSource else {
            return
        }
        let point = tap.location(in: topHeaderScrollView)
        for (index, label) in columnNameLabels.enumerated() {
            if label.frame.contains(point) {
                delegate?.excelView(self, didTapColumnNameWith: dataSource.excelView(self, columnNameAt: index))
                break
            }
        }
    }
}

extension ExcelView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        if tableView == leftHeaderTableView {
            return dataSource.numberOfRows(in: self)
        }else if tableView == contentTableView {
            return dataSource.numberOfRows(in: self)
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dataSource = dataSource else {
            return UITableViewCell(style: .default, reuseIdentifier: "default")
        }
        var cell: UITableViewCell?
        if tableView == leftHeaderTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "leftHeaderCell", for: indexPath)
            let headerCell = cell as! LeftHeaderCell
            headerCell.titleLabel.text = "\(indexPath.row)"
        }else if tableView == contentTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: ContentCell.cellIdentifier(columnCount: dataSource.numberOfColumns(in: self)))
            if cell == nil {
                cell = ContentCell(columnCount: dataSource.numberOfColumns(in: self))
            }
            let contentCell = cell as! ContentCell
            contentCell.reloadData(rowDatas: dataSource.excelView(self, rowDatasAt: indexPath.row), columnWidths: columnWidths)
            contentCell.didTapClosure = {[weak self] (itemContent) in
                self?.delegate?.excelView(self!, didTapGridWith: itemContent)
            }
        }else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        }
        cell?.selectionStyle = .none
        if indexPath.row%2 == 0 {
            cell?.contentView.backgroundColor = .white
        }else {
            cell?.contentView.backgroundColor = UIColor(white: 0.95, alpha: 0.75)
        }
        return cell!
    }
}

extension ExcelView: UITableViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == contentTableView {
            leftHeaderTableView.contentOffset = scrollView.contentOffset
        }else if scrollView == leftHeaderTableView {
            contentTableView.contentOffset = scrollView.contentOffset
        }else if scrollView == contentScrollView {
            topHeaderScrollView.contentOffset = scrollView.contentOffset
        }else if scrollView == topHeaderScrollView {
            contentScrollView.contentOffset = scrollView.contentOffset
        }
    }
}

class LeftHeaderCell: UITableViewCell {
    let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.font = .systemFont(ofSize: 13)
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = contentView.bounds
    }
}

class ContentCell: UITableViewCell {
    var didTapClosure: ((String)->())?
    var itemLabels = [UILabel]()
    private var rowDatas: [String]?

    deinit {
        didTapClosure = nil
    }

    init(columnCount: Int) {
        super.init(style: .default, reuseIdentifier: ContentCell.cellIdentifier(columnCount: columnCount))

        for _ in 0..<columnCount {
            let label = UILabel()
            label.font = .systemFont(ofSize: 13)
            contentView.addSubview(label)
            itemLabels.append(label)
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        contentView.addGestureRecognizer(tap)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func cellIdentifier(columnCount: Int) -> String {
        return "contentCell-\(columnCount)"
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        itemLabels.forEach { (label) in
            label.frame.size.height = self.contentView.bounds.size.height
        }
    }

    @objc func didTap(_ tap: UITapGestureRecognizer) {
        guard rowDatas != nil else {
            return
        }
        let point = tap.location(in: contentView)
        for (index, label) in itemLabels.enumerated() {
            if label.frame.contains(point) {
                didTapClosure?(rowDatas![index])
                break
            }
        }
    }

    func reloadData(rowDatas: [String], columnWidths: [CGFloat]) {
        self.rowDatas = rowDatas

        var itemWidth: CGFloat = 0
        let labelMargin: CGFloat = 5
        for index in 0..<itemLabels.count {
            let label = itemLabels[index]
            label.text = rowDatas[index]
            let columnWidth = columnWidths[index]
            label.frame = CGRect(x: itemWidth + labelMargin, y: 0, width: columnWidth - labelMargin*2, height: 0)

            itemWidth += columnWidth
        }
    }

}

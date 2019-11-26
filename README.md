# JXExcel

A lightweight table view，like Excel！

# Preview

![](https://github.com/pujiaxin33/JXExampleImages/blob/master/JXExcel/JXExcel.gif)

# Requirements

- iOS 9.0+
- XCode 10.2.1+
- Swift 5.0+

# Install

## CocoaPods

```ruby
Target '<Your Target Name>' do
     Pod 'JXExcel'
End
```
Execute `pod repo update` first, then execute `pod install`

# Usage

## init `ExcelView`

```Swift
        excel = ExcelView(frame: CGRect.zero)
        excel.dataSource = self
        excel.delegate = self
        view.addSubview(excel)
```

## implement `ExcelViewDataSource`
```Swift
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
```

## implement `ExcelViewDelegate`

```Swift
    func excelView(_ excelView: ExcelView, didTapGridWith content: String) {
        print("didTapGridWith:\(content)")
    }

    func excelView(_ excelView: ExcelView, didTapColumnHeaderWith name: String) {
        print("didTapColumnHeaderWith:\(name)")
    }
```






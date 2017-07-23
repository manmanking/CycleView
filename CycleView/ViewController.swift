//
//  ViewController.swift
//  CycleView
//
//  Created by manman on 2017/7/16.
//  Copyright © 2017年 Apress. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit


let ScreenWindowWidth = UIScreen.main.bounds.width

class ViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
    
    
    public var titleTopCategoryListDataSources:[String] = Array()
    
    
    private let leftTableViewCellIdentify:String = "leftTableViewCellIdentify"
    private let midTableViewCellIdentify:String = "midTableViewCellIdentify"
    private let rightTableViewCellIdentify:String = "rightTableViewCellIdentify"
    private var allButtonWidth:CGFloat = 0
    private let categoryWidth:CGFloat = 30
    private let categorySpace:CGFloat = 10
    private let categoryHeight:CGFloat = 32
    private var titleCustomView:UIView = UIView()
    private var titleTopCategoryListBackgroundScrollView:UIScrollView = UIScrollView()
    //指示器
    private var titleTopCategoryViewScrollIndicator:UILabel = UILabel()
    private var selectedCategoryButtonIndexButton = UIButton()
    private var titleTopCategoryList:[(index:NSInteger,localFrame:CGRect)] = Array()
    //默认显示全部
    private var currentIndex:NSInteger = 0
    private var leftIndex:NSInteger = 0
    private var rightIndex:NSInteger = 0
    private var contentBackgroundScrollView:UIScrollView = UIScrollView()
    
    private var leftTableView:UITableView = UITableView()
    private var midTableView:UITableView = UITableView()
    private var rightTableView:UITableView = UITableView()
    private var tableViewDataSources:[[String]] = [[]]
    private var scaleScrollIndicator:CGFloat = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "切换控制器"
        // Do any additional setup after loading the view.
        //现设置模拟数据
        titleTopCategoryListDataSources = ["全部","机+酒","机票","机+专车","机+签证","酒+门票","酒+餐券","度假产品","旅游产品"]
        tableViewDataSources = Array.init(repeating: [], count: 9)
        for index in 0...8 {
            tableViewDataSources[index] = setSimulateData(title: titleTopCategoryListDataSources[index])
        }
        setUIViewAutolayout()
//        
//        let testView:UIView = UIView.init(frame:CGRect.init(x: 0, y: 0, width: ScreenWindowWidth, height:100))
//        contentBackgroundScrollView.addSubview(testView)
//        testView.backgroundColor = UIColor.green
        
        
    }
    
    func setSimulateData(title:String)-> Array<String> {
        
        var tmpArr:[String] = Array()
        for index in 0...15
        {
            let tmp = title + index.description
            tmpArr.append(tmp)
        }
        return tmpArr
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUIViewAutolayout() {
        setContentView()
        setTopCategoryListView(categoryDataSources: titleTopCategoryListDataSources)
        
        setTableView()
        
    }
    
    func setContentView() {
        contentBackgroundScrollView.showsHorizontalScrollIndicator = false
        contentBackgroundScrollView.isPagingEnabled = true
        contentBackgroundScrollView.isScrollEnabled = true
        contentBackgroundScrollView.bounces = false
        contentBackgroundScrollView.delegate = self
        contentBackgroundScrollView.contentOffset = CGPoint.zero
        contentBackgroundScrollView.backgroundColor = UIColor.red
        self.view.addSubview(contentBackgroundScrollView)
        contentBackgroundScrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(categoryHeight)
            make.left.bottom.right.equalToSuperview()
        }
    }
    func setTableView() {
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        leftTableView.frame = CGRect(x:ScreenWindowWidth * 0,y:0,width:self.view.frame.width,height:self.view.frame.height - categoryHeight)
        leftTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:leftTableViewCellIdentify)
        contentBackgroundScrollView.addSubview(leftTableView)
        midTableView.delegate = self
        midTableView.dataSource = self
        midTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        midTableView.frame = CGRect(x:ScreenWindowWidth * 1,y:0,width:ScreenWindowWidth,height:self.view.frame.height - categoryHeight)
        midTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:midTableViewCellIdentify)
        midTableView.register(UINib(nibName: "TableNoDateView", bundle: nil), forHeaderFooterViewReuseIdentifier: "TableNoDateView")
        contentBackgroundScrollView.addSubview(midTableView)

        midTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction:#selector(midTableViewRefreshAction))
        midTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(midTableViewGetMoreAction))
        
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        rightTableView.frame = CGRect(x:ScreenWindowWidth * 2,y:0,width:self.view.frame.width,height:self.view.frame.height - categoryHeight)
        rightTableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:rightTableViewCellIdentify)
        contentBackgroundScrollView.addSubview(rightTableView)
        contentBackgroundScrollView.contentSize = CGSize.init(width: ScreenWindowWidth * 3, height: 0)
        
    }
    
    
    
    
    
    private func setTopCategoryListView(categoryDataSources:[String]) {
        titleTopCategoryListBackgroundScrollView.bounces = false
        titleTopCategoryListBackgroundScrollView.backgroundColor = UIColor.white
        titleTopCategoryListBackgroundScrollView.showsHorizontalScrollIndicator = false
        titleTopCategoryListBackgroundScrollView.frame = CGRect(x:0,y:64,width:ScreenWindowWidth,height:32)
        self.view.addSubview(titleTopCategoryListBackgroundScrollView)
        titleTopCategoryViewScrollIndicator.backgroundColor = UIColor.blue
        titleTopCategoryViewScrollIndicator.frame = CGRect(x:categorySpace,y:categoryHeight - 1,width:categoryWidth,height:1)
        titleTopCategoryListBackgroundScrollView.addSubview(titleTopCategoryViewScrollIndicator)
        
        
        
        for (index,value) in categoryDataSources.enumerated() {
            let buttonWidth =  getTextWidth(textStr: value, font: UIFont.systemFont(ofSize: 14), height: categoryHeight - 1)
            let button = UIButton()
            button.tag = index + 1
            button.setTitle(value, for: UIControlState.normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.setTitleColor(UIColor.black, for: UIControlState.normal)
            button.setTitleColor(UIColor.blue, for: UIControlState.selected)
            button.addTarget(self, action: #selector(categoryButtonAction(sender:)), for: UIControlEvents.touchUpInside)
            if index == 0 {
                button.isSelected = true
                selectedCategoryButtonIndexButton = button
                
            }
            var currentButtonWidth:CGFloat = categoryWidth
            if currentButtonWidth >= buttonWidth + 2 * categorySpace {
                allButtonWidth += currentButtonWidth
            }else
            {
                currentButtonWidth = buttonWidth + 2 * categorySpace
                allButtonWidth += currentButtonWidth
            }
            
            
            
            let buttonFrame:CGRect = CGRect(x: categorySpace * ( CGFloat( index + 1 ))  + allButtonWidth - currentButtonWidth , y:0,width:currentButtonWidth,height:categoryHeight - 1)
            button.frame = buttonFrame
            titleTopCategoryListBackgroundScrollView.addSubview(button)
            titleTopCategoryList.append((index: button.tag, localFrame: button.frame))
            if index == 0 {
                titleTopCategoryViewScrollIndicator.frame = CGRect(x:categorySpace,y:categoryHeight - 1,width:currentButtonWidth,height:1)
            }
        }
        
        
        let contenWidth:CGFloat = categorySpace * ( CGFloat(categoryDataSources.count + 1)) + allButtonWidth
        titleTopCategoryListBackgroundScrollView.contentSize = CGSize.init(width: contenWidth, height: categoryHeight)
        
        
    }
    
    
    func getTextWidth(textStr:String?,font:UIFont,height:CGFloat) -> CGFloat {
        
        if textStr?.characters.count == 0 || textStr == nil {
            return 0.0
        }
        let normalText: NSString = textStr! as NSString
        let size = CGSize(width:10000,height:height)
        let dic = NSDictionary(object: font, forKey: NSFontAttributeName as NSCopying)
        let stringSize = normalText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
        return stringSize.width
    }
    //简单X轴平移动画 更正
    func basicAnimate(toFrame:CGRect) {
        UIView.animate(withDuration: 1) { () -> Void in
            self.titleTopCategoryViewScrollIndicator.frame.origin.x = toFrame.origin.x
            self.titleTopCategoryViewScrollIndicator.frame.origin.y = toFrame.origin.y + toFrame.size.height
            self.titleTopCategoryViewScrollIndicator.frame.size.width = toFrame.size.width
        }
    }
    //当前刷新数据
    func midTableViewRefreshAction() {
        print("refresh data ")
        weak var weakSelf = self
        
        weakSelf?.midTableView.mj_header.endRefreshing()
    }
    //当前加载更多
    func midTableViewGetMoreAction() {
        print("get more data  ")
        weak var weakSelf = self
        weakSelf?.midTableView.mj_footer.endRefreshing()
    }
    
    
    //MARK:---- UIScrollViewDelegate
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView != contentBackgroundScrollView {
            return
        }
        let currentIndexTagForButton:NSInteger = currentIndex + 1
        let currentButton:UIButton = self.titleTopCategoryListBackgroundScrollView.viewWithTag(currentIndexTagForButton) as! UIButton
        var nextButton:UIButton = UIButton()
        var offset:CGFloat = scrollView.contentOffset.x
        if scrollView.contentOffset.x > ScreenWindowWidth {
            offset = offset - ScreenWindowWidth
            print("左滑","offset",offset)
            if currentIndex != 8 {
                nextButton = self.titleTopCategoryListBackgroundScrollView.viewWithTag(currentIndexTagForButton + 1) as! UIButton
            }
        }else
        {
            print("右滑","offset",offset)
            if currentIndex != 0 && offset < ScreenWindowWidth {
                nextButton = self.titleTopCategoryListBackgroundScrollView.viewWithTag(currentIndexTagForButton - 1) as! UIButton
            }
        }
        //第一次
        if nextButton.frame.origin.x == 0 {
            return
        }
        let frame = self.titleTopCategoryViewScrollIndicator.frame
        var pointX = frame.origin.x
        //滑动比例
        let indexScale = offset / ScreenWindowWidth
        // 修改wayLength  左滑  右滑 分开
        var wayLengthNew:CGFloat = 0
        if nextButton.frame.origin.x > currentButton.frame.origin.x {
            wayLengthNew = nextButton.frame.origin.x - currentButton.frame.origin.x - currentButton.frame.size.width
            if indexScale < scaleScrollIndicator {
                pointX = pointX - (indexScale - scaleScrollIndicator ) * wayLengthNew
            }else
            {
                pointX = pointX + (indexScale - scaleScrollIndicator ) * wayLengthNew
            }
        }
        else
        {
            wayLengthNew = currentButton.frame.origin.x - nextButton.frame.origin.x - nextButton.frame.size.width
            if indexScale < scaleScrollIndicator {
                pointX = pointX + (indexScale - scaleScrollIndicator ) * wayLengthNew
            }else
            {
                pointX = pointX - (indexScale - scaleScrollIndicator ) * wayLengthNew
            }
        }
        scaleScrollIndicator = indexScale
        self.titleTopCategoryViewScrollIndicator.frame = CGRect.init(x: pointX , y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        
        
        if scrollView == contentBackgroundScrollView {
            
            let point:CGPoint = scrollView.contentOffset
            print("content scrollView ...",point)
            // judge critical value，first and third imageView's contentoffset
            let criticalValue:CGFloat = 2.0
            
            // scroll right, judge right critical value
            if (point.x > 2 * scrollView.bounds.width - criticalValue) {
                currentIndex = (currentIndex + 1) % tableViewDataSources.count;
            } else if (point.x < criticalValue) {
                // scroll left，judge left critical value
                currentIndex = (currentIndex + tableViewDataSources.count - 1) % tableViewDataSources.count
                
                
            }
            //            let page:Int = Int(point.x/ScreenWindowWidth)
            let button:UIButton = self.titleTopCategoryListBackgroundScrollView.viewWithTag(currentIndex + 1) as! UIButton
            categoryButtonAction(sender: button)
            //   caculateShowTime(current: currentIndex)
        }
    }
    
    
    func catoryAndContentAccord(){
        titleTopCategoryListBackgroundScrollView.scrollRectToVisible(titleTopCategoryViewScrollIndicator.frame, animated: true)
    }
    
    
    
    
    //
    func caculateShowTime(current:NSInteger) {
        if current >= 0
        {
            currentIndex = current
            let categoryCount:NSInteger = tableViewDataSources.count
            leftIndex = (current + categoryCount - 1)%categoryCount
            rightIndex = (current + 1)%categoryCount
            leftTableView.reloadData()
            midTableView.reloadData()
            rightTableView.reloadData()
            setContentViewOffsetView()
        }
    }
    
    
    func setContentViewOffsetView() {
        contentBackgroundScrollView.contentOffset = CGPoint.init(x: ScreenWindowWidth, y: 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tableViewDataSources.count > leftIndex && tableViewDataSources.count > currentIndex && tableViewDataSources.count > rightIndex else {
            return 0
        }
        switch tableView {
        case leftTableView:
            return tableViewDataSources[leftIndex].count
        case midTableView:
            return tableViewDataSources[currentIndex].count
        case rightTableView:
            return tableViewDataSources[rightIndex].count
        default:
            return 0
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case leftTableView:
            return configLeftTableView(indexPath: indexPath)
        case midTableView:
            return configCurrentTableView(indexPath: indexPath)
        case rightTableView:
            return configRightTableView(indexPath: indexPath)
            
        default:
            break
        }
        
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"placeHolder")
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "placeHolder")
            
        }
        
        
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected ",indexPath)
    }
    
   
    
    
    
    func  configLeftTableView(indexPath:IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = leftTableView.dequeueReusableCell(withIdentifier: leftTableViewCellIdentify)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = tableViewDataSources[leftIndex][indexPath.row]
        return cell
    }
    func  configCurrentTableView(indexPath:IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = midTableView.dequeueReusableCell(withIdentifier: midTableViewCellIdentify)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = tableViewDataSources[currentIndex][indexPath.row]
        return cell
    }
    func  configRightTableView(indexPath:IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = rightTableView.dequeueReusableCell(withIdentifier: rightTableViewCellIdentify)!
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.textLabel?.text = tableViewDataSources[rightIndex][indexPath.row]
        return cell
    }
    
    
    
    
    //MARK:----Action
    
    //MARK:----分类标签事件
    func categoryButtonAction(sender:UIButton) {
        print(sender.tag)
        selectedCategoryButtonIndexButton.isSelected = false
        selectedCategoryButtonIndexButton = sender
        selectedCategoryButtonIndexButton.isSelected = true
        let targetFrame =  titleTopCategoryList[sender.tag - 1].localFrame
        caculateShowTime(current: sender.tag - 1)
        basicAnimate(toFrame: targetFrame)
        catoryAndContentAccord()
        
    }


}


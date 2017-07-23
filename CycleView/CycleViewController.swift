//
//  CycleViewController.swift
//  CycleView
//
//  Created by manman on 2017/7/16.
//  Copyright © 2017年 Apress. All rights reserved.
//

import UIKit

class CycleViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    private let tableViewCellIdentify:String = "tableViewCellIdentify"
    private let tableView:UITableView = UITableView()
    private var dataSourcesArr:[(title:String,className:String)] = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        dataSourcesArr = [("cycle + SliderBar","ViewController"),("Test Scroll","TableViewController")]
        setUIViewAutolayout()
        
        
    }
    
    func setUIViewAutolayout()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: tableViewCellIdentify)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        
        
    }
    
    //MARK:----- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourcesArr.count
        //测试
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)!
        cell.textLabel?.text = dataSourcesArr[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let className:String = getAPPName() + "." + dataSourcesArr[indexPath.row].className
        let viewController = NSClassFromString(className) as! BaseViewController.Type
        self.navigationController?.pushViewController(viewController.init(), animated: true)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  TableViewController.swift
//  CycleView
//
//  Created by manman on 2017/7/18.
//  Copyright © 2017年 Apress. All rights reserved.
//

import UIKit

class TableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{

    private let tableViewCellIdentify:String = "placeHolder"
    
    private var baseBackgroundView:UIScrollView = UIScrollView()
    private var tableView:UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(baseBackgroundView)
        baseBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        baseBackgroundView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier:tableViewCellIdentify)
        
        
        
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentify)!
        cell.textLabel?.text = indexPath.row.description
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

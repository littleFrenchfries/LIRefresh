//
//  ViewController.swift
//  LIRefresh
//
//  Created by wangxu on 2020/5/14.
//  Copyright © 2020 wangxu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.backgroundColor = .green
        cell.textLabel?.text = "\(indexPath.row)"
        cell.detailTextLabel?.text = "\(indexPath.section)"
        return cell
    }
    

    @IBOutlet weak var tablview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        tablview.backgroundColor = .blue
        self.tablview.delegate = self
        self.tablview.dataSource = self
//        self.tablview.tableHeaderView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 40))
        self.tablview.li.header = NormalRefreshHeader.headerWithRefreshing(block: {[weak self] in
            self?.loadMoreData()
        })
        self.tablview.li.footer = NormalRefreshFooter.footerWithRefreshing(block: {[weak self] in
            self?.loadMoreData()
        })
        self.tablview.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        // Do any additional setup after loading the view.
    }
    /// 加载更多的数据 footer
    private func loadMoreData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {[weak self] in
            self?.tablview.li.header?.endRefreshing()
            self?.tablview.li.footer?.endRefreshing()
        }
    }
}


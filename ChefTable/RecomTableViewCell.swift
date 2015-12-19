//
//  RecomTableViewCell.swift
//  ChefTable
//
//  Created by Yangye Zhu on 11/13/15.
//  Copyright © 2015 Yangye Zhu. All rights reserved.
//

import UIKit

class RecomTableViewCell: UITableViewCell {
    
    var recomType: String? {
        get { return recomTypeLabel?.text}
        set {recomTypeLabel?.text = newValue}
    }

    // MARK: - UI
    
    @IBOutlet private weak var recomTypeLabel: UILabel!
    
    @IBOutlet private weak var recomCollectionView: UICollectionView!
    
    
    // MARK: - Set up the data source, delegate, and tag of our collection view
    
    func setCollectionViewDataSourceDelegate<P: protocol<UICollectionViewDataSource,UICollectionViewDelegate>>(dataSourceDelegate: P, forRow row: Int) {
        
        recomCollectionView.delegate = dataSourceDelegate
        recomCollectionView.dataSource = dataSourceDelegate
        recomCollectionView.tag = row
        recomCollectionView.reloadData()
        
    }
    
}
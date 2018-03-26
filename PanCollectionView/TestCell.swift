//
//  TestCell.swift
//  PanCollectionView
//
//  Created by leezb101 on 2017/5/19.
//  Copyright © 2017年 AsiaInfo. All rights reserved.
//

import UIKit

class TestCell: UICollectionViewCell {
    let label: UILabel
    
    override init(frame: CGRect) {
        label = UILabel()
        super.init(frame: frame)
        label.frame = contentView.frame
        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

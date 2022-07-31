//
//  SegmentedTableViewCell.swift
//  ToDo
//
//  Created by murphy on 7/30/22.
//

import UIKit

class SegmentedTableViewCell: UITableViewCell {

    static let identifier = "SegmentedTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["one", "two"])
        
        return segmentedControl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(segmentedControl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 0, width: 50, height: contentView.frame.size.height)
        
        segmentedControl.sizeToFit()
        segmentedControl.frame = CGRect(x: contentView.frame.size.width - segmentedControl.frame.size.width - 20,
                               y: (contentView.frame.size.height - segmentedControl.frame.size.height)/2, width: segmentedControl.frame.size.width,
                               height: segmentedControl.frame.size.height)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil

        
    }
    
    public func configure() {
        label.text = "hello"
    }
}


//
//  DateTableViewCell.swift
//  ToDo
//
//  Created by murphy on 7/30/22.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    static let identifier = "DateTableViewCell"
    
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        return datePicker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(datePicker)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        

        datePicker.sizeToFit()
        datePicker.frame = CGRect(x: 0, y: 0, width: datePicker.frame.size.width, height: datePicker.frame.size.height)

    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        

        
    }
    
    public func configure() {
        
    }
}


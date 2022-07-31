//
//  DetailTableViewCell.swift
//  ToDo
//
//  Created by murphy on 7/30/22.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {

    static let identifier = "DetailTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        return mySwitch
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        return datePicker
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(datePicker)
        contentView.addSubview(mySwitch)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = CGRect(x: 0, y: 0, width: 50, height: contentView.frame.size.height / 2)
        datePicker.frame = CGRect(x: 50, y: label.frame.size.height, width: 50, height: contentView.frame.size.height / 2)
        mySwitch.sizeToFit()
        mySwitch.frame = CGRect(x: contentView.frame.size.width - mySwitch.frame.size.width - 20,
                               y: (contentView.frame.size.height - mySwitch.frame.size.height)/2, width: mySwitch.frame.size.width,
                               height: mySwitch.frame.size.height)
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        mySwitch.isOn = false
    }
    
    public func configure() {
        label.text = "hello"
    }
}


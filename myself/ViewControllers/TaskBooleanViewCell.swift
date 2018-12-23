//
//  TaskNumericViewCell.swift
//  myself
//
//  Created by Kemal Taskin on 30.11.18.
//  Copyright © 2018 Kelpersegg. All rights reserved.
//

import UIKit

class TaskBooleanViewCell: UITableViewCell {
    
    @IBOutlet weak var lblLabel: UILabel!
    @IBOutlet weak var imgDone: UIImageView!
    
    public var entry: Entry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgDone.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        imgDone.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        imgDone.image = imgDone.image?.withRenderingMode(.alwaysTemplate)
        if (imgDone.tintColor == UIColor.green) {
            imgDone.tintColor = UIColor.black
            entry?.Value = 0
        }
        else {
            imgDone.tintColor = UIColor.green
            entry?.Value = 1
        }
        
        entry?.ModificationDate = Date()
        
        DispatchQueue.main.async {
            RealmHelper.SaveEntry(entry: self.entry!)
            
            HttpRequest.send(url: "entries",
                             method: "POST",
                             data: self.entry,
                             cbSuccess: self.CallbackSuccess,
                             cbError: self.CallbackError);
        }
    }
    
    func CallbackError(statusCode:Int, message: String)
    {
    }
    
    func CallbackSuccess(result: JsonResult<UploadEntryResponse>)
    {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func initCell(taskEntry: TaskEntry) {
        
        self.entry = taskEntry.entry!
        
        self.lblLabel?.text = taskEntry.task?.Label
        
        imgDone.image = imgDone.image?.withRenderingMode(.alwaysTemplate)
        if (entry?.Value == 0) {
            imgDone.tintColor = UIColor.black
        }
        else {
            imgDone.tintColor = UIColor.green
        }
        
    }

}

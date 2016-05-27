//
//  Comment.swift
//  SuggestionsBox
//
//  Created by Manuel Escrig Ventura on 30/04/16.
//
//


public struct Comment {
    
    var commentId : Int
    var description: String
    var author: String
    var createdAt : NSDate
    
    public init(commentId : Int,
         description: String,
         author: String,
         createdAt: NSDate) {
        
        self.commentId = commentId
        self.description = description
        self.author = author
        self.createdAt  = createdAt
    }
    
    func dateString() -> String {
        let format = SuggestionsBoxTheme.detailDateFormat
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(createdAt)
    }
}

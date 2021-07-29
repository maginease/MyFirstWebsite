//
//  File.swift
//  
//
//  Created by Minseo Kim on 7/27/21.
//

import Vapor
import Fluent

final class CommunityPost:Content,Model {
   
    static let schema = "CommunityPost"
    
    @ID(key: .id)
    var id:UUID?
    
    @Field(key:"content")
    var content:String
    
    @Field(key: "username")
    var username:String?
    
    weak var user:UserInfo?
    
    init() {}
   
    init(id:UUID? = nil,content:String,username:String? = nil) {
        
        self.id = id
        self.content = content
        self.username = ""
    }
    
   
}

struct createPost:Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("CommunityPost").id().field("content",.string).field("username",.string).create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("CommunityPost").delete()
    }
    
}

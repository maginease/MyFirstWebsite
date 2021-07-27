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
    
    @Field(key: "name")
    var name:String
    
    init() {}
    
    init(id:UUID? = nil,content:String,name:String) {
        
        self.id = id
        self.content = content
        self.name = name
    }
}

struct createPost:Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("CommunityPost").id().field("content",.string).field("name",.string).create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("CommunityPost").delete()
    }
    
}

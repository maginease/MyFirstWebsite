//
//  File.swift
//  
//
//  Created by Minseo Kim on 7/26/21.
//

import Vapor
import Fluent


final class UserInfo:Content,Model {
    
    static let schema = "UserInfo"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username:String
    
    @Field(key: "password")
    var password:String
    
    var posts:[CommunityPost] = []
    
    init(password:String ,id:UUID? = nil,username:String) {
        self.username = username
        self.password = password
        self.id = id
    }
    init() {}
}

struct createUserInfo:Migration {
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("UserInfo").id().field("username", .string).field("password",.string).create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("UserInfo").delete()
    }
    
    
}

struct registerInfo:Content {
    
    var username:String
    var password:String
    var cfmpwd:String
}

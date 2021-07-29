import Fluent
import Vapor

var currentLogin:UserInfo? = nil

func routes(_ app: Application) throws {
    
    app.get { req in
        return req.view.render("main")
    }
    
    app.get("myThread") { req in
        return req.view.render("index",["name":"Fellas"])
    }
    
    app.get("HotGirls") { req in
        return req.view.render("page2")
    }
    
    app.get("login") { req in

        return req.view.render("login")
    }

    app.get("register") { req in
        return req.view.render("register")
    }

    app.get("community") { req->EventLoopFuture<View> in
        
        return CommunityPost.query(on: req.db).all().flatMap { posts in
            
         
            return req.view.render("community",["posts":posts])
        }
    }

  
    
    app.post("lrdb") { req->EventLoopFuture<Response> in

        let userinfo = try req.content.decode(UserInfo.self)

        currentLogin = userinfo

        return userinfo.create(on: req.db).map { userinfo in
            return req.redirect(to: "/community")
        }
    }
    
    app.get("logOut") { req->Response in

        currentLogin = nil

        return req.redirect(to: "/")
    }
    
    app.post("post") { req->EventLoopFuture<Response> in
        
        let post = try req.content.decode(CommunityPost.self)
        
        post.user = currentLogin
        post.username = currentLogin!.username
        //assigns user to the post
        
        return post.create(on: req.db).map { post in
            return req.redirect(to: "/community")
        }
    }
}

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
        
        if currentLogin == nil {
            
            return req.view.render("login")
            
        }
        
        let userForPassing = CommunityPost(content: "", username: "", user: nil)
        userForPassing.username = currentLogin!.username
        
        return CommunityPost.query(on: req.db).all().flatMap { posts in
            
         
            return req.view.render("community",["posts":posts,"currentUser":[userForPassing]])
        }
    }

  
    
    app.post("lrdb") { req->EventLoopFuture<Response> in
        
        //get register form data
        let registerInfo = try req.content.decode(registerInfo.self)
        //redirects to register page if cfmpwd is not equal to pwd
        guard registerInfo.cfmpwd == registerInfo.password else {
            
            return registerInfo.encodeResponse(for: req).map { _ in
                return req.redirect(to: "/register")
            }
        }
        
        //assigns UserInfo if confirm password and password is the same.
        let userinfo = UserInfo(password: registerInfo.password, username: registerInfo.username)
        
        return UserInfo.query(on: req.db).all().flatMap { users in
            
            for user in users {
                
                if user.username == userinfo.username {
                    
                    return userinfo.encodeResponse(for: req).map { i in
                        return req.redirect(to: "register")
                        //used this to make req.redirect to be of type EventLoopFuture<Response>
                    }
                }
                
            }
            
            currentLogin = userinfo

            return userinfo.create(on: req.db).map { userinfo in
                return req.redirect(to: "/community")
            
        }
        
        
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
        
        return post.create(on: req.db).map { _ in
            return req.redirect(to: "/community")
        }
    }
    
    app.post("loginverify") { req-> EventLoopFuture<View> in
        
        let data = try req.content.decode(login.self)
        
        //create userForPassing to send [CommunityPost] data to html through leaf
        let userForPassing = CommunityPost(content: "", username: "", user: nil)
        userForPassing.username = data.username
        //assign the username
        
        return UserInfo.query(on: req.db).all().flatMap { userinfo in
            
            for user in userinfo {
                
                if user.username == data.username && user.password == data.password {
                    
                    return CommunityPost.query(on: req.db).all().flatMap { posts in
                        
                        currentLogin = user
                        
                        return req.view.render("community",["posts":posts,"currentUser":[userForPassing]])
                    }
                }
                
                if user.username == data.username && user.password != data.password {
                    
                    return req.view.render("login",["errorMessage":"Wrong Password"])
                }
            }
            
            return req.view.render("login",["errorMessage":"Username Not Found"])
        }
    }
    
    
    app.post("deletePost",":id") { req->EventLoopFuture<Response> in
        
        let postId = req.parameters.get("id")
        
        return CommunityPost.query(on: req.db).all().map { posts in
            
            for post in posts {
                
                if "\(post.id!)" == postId {
                    
                    _ = post.delete(on: req.db)
                    
                    return req.redirect(to: "/community")
                }
                
                
            }
            return req.redirect(to: "/")
        }
    }
   
}

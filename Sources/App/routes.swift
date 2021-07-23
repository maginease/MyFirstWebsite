import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.get { req in
        return req.view.render("index",["name":"Fellas"])
    }
    
    app.get("hello") { req in
        return req.view.render("page2")
    }
}

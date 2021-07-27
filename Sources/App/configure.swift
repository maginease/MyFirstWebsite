import Fluent
import FluentPostgresDriver
import Leaf
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    app.views.use(.leaf)
    app.databases.use(.postgres(hostname: "localhost", username:"minseo", password: "minseo"), as: .psql)
//    app.migrations.add(createUserInfo())
    app.migrations.add(createPost())
}

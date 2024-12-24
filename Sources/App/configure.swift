import Vapor
import Fluent
import FluentSQLiteDriver


public func configure(_ app: Application) async throws {
    
//    app.http.server.configuration.hostname = "0.0.0.0"
//    app.http.server.configuration.port = 80
    
    // serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // register routes
    try routes(app)
    app.routes.defaultMaxBodySize = "20MB"
    

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(MyMigration())
}

import Vapor
import Fluent
import FluentSQLiteDriver


public func configure(_ app: Application) async throws {
    
    // serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // register routes
    try routes(app)
    app.routes.defaultMaxBodySize = "20mb"
    

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    // `swift run App migrate`
    app.migrations.add(TemplateMigration())
}

import Vapor
import Fluent
// import FluentMongoDriver
import FluentSQLiteDriver


// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    try routes(app)
    app.routes.defaultMaxBodySize = "20mb"
    
    // db
    //.. try app.databases.use(.mongo(connectionString: "mongodb://localhost:27017/vapor"), as: .mongo)
    

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    app.migrations.add(CreateTemplate())
}

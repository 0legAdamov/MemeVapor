import Vapor
import Fluent

func routes(_ app: Application) throws {
    
    app.get() { req in
        return "Hello!"
    }
    
    
    app.get("users") { req in
        return try await User.query(on: req.db).all()
    }
    
    
    app.post("favorite") { req in
        let request = try req.query.decode(FavoriteRequest.self)
        
        guard let _ = try await Template.query(on: req.db).filter(\.$id == request.template_id).first() else {
            throw Abort(.notFound)
        }
        
        if let user = try? await User.query(on: req.db).filter(\.$id == request.uid).first() {
            if request.is_favorite {
                if user.favorites.contains(request.template_id) {
                    return Response(status: .notModified)
                } else {
                    user.favorites.append(request.template_id)
                    try await user.save(on: req.db)
                    return Response()
                }
            } else {
                if let index = user.favorites.firstIndex(of: request.template_id) {
                    user.favorites.remove(at: index)
                    try await user.save(on: req.db)
                    return Response()
                } else {
                    return Response(status: .notModified)
                }
            }
        } else {
            if request.is_favorite {
                let user = User(id: request.uid)
                user.favorites.append(request.template_id)
                try await user.create(on: req.db)
                return Response()
            } else {
                return Response(status: .notModified)
            }
        }
    }
    
    
    app.get("all") { req in
        let templates = try await Template.query(on: req.db)
            .sort(\.$createdAt, .descending)
            .all()
        
        guard let allRequest = try? req.query.decode(AllRequest.self),
              let user = try? await User.query(on: req.db).filter(\.$id == allRequest.uid).first()
        else {
            let all = templates.map { TemplateResponse(template: $0, frames: []) }
            return AllResponse(my: [], other: all)
        }
        
        var my = [TemplateResponse]()
        var other = [TemplateResponse]()
        
        templates.filter { $0.id != nil }.forEach { template in
            let tResponse = TemplateResponse(template: template, frames: user.textFrames)
            if user.favorites.contains(template.id!) {
                my.append(tResponse)
            } else {
                other.append(tResponse)
            }
        }
        return AllResponse(my: my, other: other)
    }
    
    
    app.post("create") { req in
        let create = try req.query.decode(CreateRequest.self)
        
        guard let buffer = req.body.data else {
            throw CreateError.noBodyData
        }
        guard let data = buffer.getData(at: 0, length: buffer.readableBytes), data.count > 0 else {
            throw CreateError.emptyData
        }
        
        let id = UUID()
        
        let path = req.application.directory.publicDirectory + id.uuidString
        try await req.fileio.writeFile(ByteBuffer(data: data), at: path)
        
        let template = Template(id: id, ownerId: create.owner_id, ownerName: create.owner_name)
        try await template.create(on: req.db)
        
        let user = User(id: create.owner_id)
        user.favorites.append(id)
        try await user.create(on: req.db)
        
        return template
    }
}

//.. sync

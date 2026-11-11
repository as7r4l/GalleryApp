import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    private init() {
        container = NSPersistentContainer(name: "GalleryDataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Ошибка инициализации Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Ошибка сохранения Core Data: \(error.localizedDescription)")
            }
        }
    }
    
    func savePhoto(_ photo: UnsplashPhoto) {
            let newFavorite = FavoritePhotoEntity(context: context)
            newFavorite.id = photo.id
            newFavorite.urlString = photo.urls.regular
            newFavorite.photoDescription = photo.description ?? photo.altDescription
            newFavorite.authorName = photo.user.name
            newFavorite.savedDate = Date()
            
            saveContext()
            print("Фото \(photo.id) сохранено в избранное!")
        }
    
    func deletePhoto(withId id: String) {
            let request = FavoritePhotoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %@", id)
            
            do {
                let results = try context.fetch(request)
                for object in results {
                    context.delete(object)
                }
                saveContext()
                print("Фото \(id) удалено из избранного.")
            } catch {
                print("Ошибка при удалении: \(error.localizedDescription)")
            }
        }
}

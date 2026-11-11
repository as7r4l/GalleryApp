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
}

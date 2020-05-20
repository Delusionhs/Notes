import Foundation
import CoreData
import UIKit

class LoadNotesDBOperation: BaseDBOperation {
    
    var backgroundContext: NSManagedObjectContext
    
    init(notesbook: FileNotebook,
         backgroundContext: NSManagedObjectContext) {
        self.backgroundContext = backgroundContext
        super.init(notebook: notesbook)
    }
    
    override func main() {
    //notebook.loadFromFile()
        let fetchRequest = NSFetchRequest<NoteEntity>(entityName: "NoteEntity")
        do {
            let fetchResults = try self.backgroundContext.fetch(fetchRequest)
            for object in fetchResults {
                let color = UIColor(red: CGFloat(object.colorRed),
                                    green: CGFloat(object.colorGreen),
                                    blue: CGFloat(object.colorBlue),
                                    alpha: CGFloat(object.colorAlpha))
                
                
                let note = Note(uid: object.uid!,
                                            title: object.title!,
                                            content: object.content!,
                                            color: color, importance:
                                            Importance(rawValue: object.importance!)!,
                                            selfDestructionDate: object.destructionDate)
                
                notebook.add(note)
            }
        } catch {
            print(error)
        }
        finish()
    }
}

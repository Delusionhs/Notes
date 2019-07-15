import UIKit
//import CocoaLumberjack

class FileNotebook {
    
    private(set) var notes: [Note] = []
    
    init() {
        //DDLog.add(DDOSLogger.sharedInstance)
        //DDLogInfo("Init")
    }
    
    init(withNotes: [Note]) {
        self.notes = withNotes
    }
    
    public func add(_ note: Note) {
        if let noteOffset = self.notes.firstIndex(where: {$0.uid == note.uid}) {
            self.notes[noteOffset] = note
        } else {
            self.notes.append(note)
        }
    }
    
    public func remove(with uid: String) {
        if let noteOffset = self.notes.firstIndex(where: {$0.uid == uid}) {
            self.notes.remove(at: noteOffset)
        }
    }
    
    public func saveToFile(fileName: String = "Notebook") {
        var json: Data = Data()
        var jsonArr: [[String: Any]] = []
        
        for notes in self.notes {
            jsonArr.append(notes.json)
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonArr, options: [])
            json.append(data)
        } catch {}
        
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let dirBooks = path!.appendingPathComponent("Notebooks")
        
        var isDir: ObjCBool = false
        if !FileManager.default.fileExists(atPath: dirBooks.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirBooks, withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {}
        } else {
            //DDLogWarn("Directory already exists")
        }
    
        let filepath = dirBooks.appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: filepath.path, isDirectory: &isDir) {
            FileManager.default.createFile(atPath: filepath.path, contents: json, attributes: nil)
        } else {
            //DDLogError("File already exists")
            return
        }
    }
    
    public func loadFromFile(fileName: String = "Notebook") {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        let dirBooks = path!.appendingPathComponent("Notebooks")
        let filepath = dirBooks.appendingPathComponent(fileName, isDirectory: false)
        let url = URL(fileURLWithPath: filepath.path)
        
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: filepath.path, isDirectory: &isDir) {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: [])
                if let dictionary = object as? [[String: Any]] {
                    self.notes = []
                    for dict in dictionary {
                        self.add(Note.parse(json: dict)!)
                    }
                }
            } catch {
                //DDLogError("Error!! Unable to parse")
            }
        } else {
            //DDLogError("No file at dir")
            return
        }
    }
}

extension FileNotebook {
    static var myNotebook: FileNotebook {
        let notes = [Note(title: "Первая заметка",
                          content: "Очень важная заметка",
                          importance: .important),
                     Note(title: "Вторая заметка",
                          content: "Обычная заметка",
                          importance: .ordinary),
                     Note(title: "Третья заметка",
                          content: "Совсем не важная заметка но синяя",
                          color: .blue,
                          importance: .unimportant,
                          selfDestructionDate: nil)]
        return FileNotebook(withNotes: notes)
    }
}

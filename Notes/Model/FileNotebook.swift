import UIKit
//import CocoaLumberjack

class FileNotebook {
    
    private(set) var notebook: [Note] = []
    
    init() {
        //DDLog.add(DDOSLogger.sharedInstance)
        //DDLogInfo("Init")
    }
    
    public func add(_ note: Note) {
        if let noteOffset = self.notebook.firstIndex(where: {$0.uid == note.uid}) {
            self.notebook[noteOffset] = note
        } else {
            self.notebook.append(note)
        }
    }
    
    public func remove(with uid: String) {
        if let noteOffset = self.notebook.firstIndex(where: {$0.uid == uid}) {
            self.notebook.remove(at: noteOffset)
        }
    }
    
    public func saveToFile(fileName: String = "Notebook") {
        var json: Data = Data()
        var jsonArr: [[String: Any]] = []
        
        for notes in self.notebook {
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
                    self.notebook = []
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

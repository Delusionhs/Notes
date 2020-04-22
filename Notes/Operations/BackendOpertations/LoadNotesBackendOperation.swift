import Foundation

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: BackendResult?
    var token: String = ""
    var notebook: FileNotebook
    
    init(notebook: FileNotebook, token: String) {
        self.notebook = notebook
        self.token = token
        super.init()
    }
  
    override func main() {
        result = .failure(.unreachable)
        var components = URLComponents(string: "https://api.github.com/gists/828262049b6e86cf5f97bf8ef504e2a2")
        components?.queryItems = [
            URLQueryItem(name: "access_token", value: self.token),
        ]
        
        guard let url = components?.url else {
            self.result = .failure(.dataFailure)
            finish()
            return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    if let data = data {
                    guard let gist =  try? JSONDecoder().decode(Gist.self, from: data) else {
                        print("Can't parse")
                        return
                        }
                        if let content = gist.files["ios-course-notes-db"]?.content {
                            let data = Data()
                            guard let notes = try? JSONDecoder().decode([NoteCodable].self, from: content.data(using: .utf8) ?? data) else {
                                print("Can't parse")
                                return
                            }
                            self.notebook.loadNotesFromCodable(notes: notes)
                        }
                    }
                    self.result = .success
                default:
                    print("ne nice")
                    self.result = .failure(.unreachable)
                }
            }
        }.resume()
    
        finish()
    }
}

import Foundation


class SaveNotesBackendOperation: BaseBackendOperation {
    var result: BackendResult?
    var token: String = ""
    var notebook: FileNotebook
    let filename = "ios-course-notes-db"
    
    init(notebook: FileNotebook, token: String) {
        self.token = token
        self.notebook = notebook
        super.init()
    }
    
    override func main() {
        self.result = .failure(.unreachable)
        
        var components = URLComponents(string: "https://api.github.com/gists/828262049b6e86cf5f97bf8ef504e2a2")
        components?.queryItems = [
            URLQueryItem(name: "access_token", value: self.token),
        ]
        guard let url = components?.url else {
            self.result = .failure(.dataFailure)
            finish()
            return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        
        guard let jsonData = String(data: notebook.getDataToSave(), encoding: .utf8) else {
            self.result = .failure(.dataFailure)
            finish()
            return }
        
        let inputData = Gist(url: nil, files: [filename : GistFile(filename: nil, content: jsonData)])
        
        do {
            request.httpBody = try JSONEncoder().encode(inputData)
        } catch let error {
            print(error.localizedDescription)
        }
        
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200..<300:
                    print("SAVED SAVED SAVED SAVED SAVED")
                    self.result = .success
                default:
                    self.result = .failure(.unreachable)
                }
            }
        }.resume()
        
        finish()
    }
}


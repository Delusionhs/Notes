import Foundation

class LoadNotesBackendOperation: BaseBackendOperation {
    var result: BackendResult?
    var token: String = ""
    var notebook: FileNotebook
    let filename = "ios-course-notes-db"

    init(notebook: FileNotebook, token: String) {
        self.notebook = notebook
        self.token = token
        super.init()
    }

    override func main() {

        // TODO: Delete Pyramide of doom, sync tasks

        guard let requestGistID = getRequestWithToken(urlString: "https://api.github.com/gists") else {
            self.result = .failure(.dataFailure)
            finish()
            return }

        URLSession.shared.dataTask(with: requestGistID ) { (data, response, error) in
            if let data = data {
                guard let gists =  try? JSONDecoder().decode([Gist].self, from: data) else {
                    self.result = .failure(.dataFailure)
                    self.finish()
                    return }
                for gist in gists {
                    for (key, _) in gist.files {
                        if key == "ios-course-notes-db" {
                            guard let id = gist.id else { return }
                            //DATA TASK TWO START
                            guard let request = self.getRequestWithToken(urlString: "https://api.github.com/gists/" + id) else {
                                    self.result = .failure(.dataFailure)
                                    self.finish()
                                    return }
                                URLSession.shared.dataTask(with: request) { (data, response, _) in
                                    if let response = response as? HTTPURLResponse {
                                        switch response.statusCode {
                                        case 200..<300:
                                            if let data = data {
                                                guard let gist =  try? JSONDecoder().decode(Gist.self, from: data) else {
                                                    print("Can't parse")
                                                    return
                                                    }
                                                if let content = gist.files[self.filename]?.content {
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
                                            self.result = .failure(.unreachable)
                                        }
                                    }
                                    self.finish()
                                }.resume()
            }}}}}.resume()

    }

    func getRequestWithToken(urlString: String) -> URLRequest? {
        var components = URLComponents(string: urlString)
        components?.queryItems = [
            URLQueryItem(name: "access_token", value: self.token)
        ]

        guard let url = components?.url else {
            self.result = .failure(.dataFailure)
            finish()
            return nil }

        let request = URLRequest(url: url)
        return request
    }

}

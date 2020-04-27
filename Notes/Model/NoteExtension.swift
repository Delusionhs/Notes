import UIKit

extension Note {

    var json: [String: Any] {
        var json = [String: Any]()

        json["uid"] = self.uid
        json["title"] = self.title
        json["content"] = self.content

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        self.color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        if (red, green, blue, alpha) != (1, 1, 1, 1) {
            json["color"] = (red, green, blue, alpha)
        }

        if self.importance != .ordinary {
            json["importance"] = self.importance.rawValue
        }

        if let date = self.selfDestructionDate {
            json["selfDestructionDate"] = date.timeIntervalSince1970
        }

        return json
    }

    static func parse(json: [String: Any]) -> Note? {
        var uid: String
        var title: String
        var content: String
        var color: UIColor
        var selfDestructionDate: Date?
        var importance: Importance

        if  let jsonuid = json["uid"] as? String {
            uid = jsonuid
        } else {
            return nil
        }

        if  let jsontitle = json["title"] as? String {
            title = jsontitle
        } else {
            return nil
        }

        if  let jsoncontent = json["content"] as? String {
            content = jsoncontent
        } else {
            return nil
        }

        if let jsoncolor = json["color"] as? (CGFloat, CGFloat, CGFloat, CGFloat) {
            color = UIColor(red: jsoncolor.0, green: jsoncolor.1, blue: jsoncolor.2, alpha: jsoncolor.3)
        } else {
            color = UIColor.white
        }

        if  let jsonselfDestructionDate = json["selfDestructionDate"] as? Double {
            selfDestructionDate = Date(timeIntervalSince1970: jsonselfDestructionDate)
        } else {
            selfDestructionDate = nil
        }

        if let jsonimportance = json["importance"] as? String {
            importance = Importance(rawValue: jsonimportance)!
        } else {
            importance = Importance.ordinary
        }

        let note: Note? = Note(uid: uid,
                               title: title,
                               content: content,
                               color: color,
                               importance: importance,
                               selfDestructionDate: selfDestructionDate)

        return note
    }
}

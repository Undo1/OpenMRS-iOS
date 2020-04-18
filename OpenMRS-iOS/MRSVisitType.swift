//
//  MRSVisitType.swift
//  OpenMRS-iOS
//
//  Created by Parker Erway on 1/22/15.
//

import Foundation

class MRSVisitType : NSObject, NSCoding
{
    @objc var uuid: String!
    @objc var display: String!

    override init() {
        super.init()
    }
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.uuid = aDecoder.decodeObject(forKey: "uuid") as! String
        self.display = aDecoder.decodeObject(forKey: "display") as! String
    }

    func encode(with aCoder: NSCoder) {
        [aCoder.encode(self.uuid, forKey: "uuid")]
        [aCoder.encode(self.display, forKey: "display")]
    }
}



import Foundation
import CoreData

@objc(Places)
public class Places: NSManagedObject {
    
    @NSManaged public var name: String
    @NSManaged public var type: String
    @NSManaged public var location: String
    @NSManaged public var image: NSData?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var rating: String?
    @NSManaged public var isVisited: NSNumber?

}

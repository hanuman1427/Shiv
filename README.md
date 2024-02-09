 add this for using elf.context 

 // MARK: - [extension - database]
extension UIViewController{
    var context : NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}

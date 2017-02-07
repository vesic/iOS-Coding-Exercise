
import Foundation

class ItemsStore {
    
    var items = [Item]()
    
    func addToItems(item: Item) {
        
        self.items.append(item)
    }
    
    func returnSingleItem(index: Int) -> Item {
        
        return self.items[index]
    }
    
    func returnAllItems() -> Int {
        
        return self.items.count
    }
    
    func clearAll() {
        
        self.items = [Item]()
    }
    
}

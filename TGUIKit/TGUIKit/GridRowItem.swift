//
//  GridRowItem.swift
//  TGUIKit
//
//  Created by keepcoder on 13/10/2016.
//  Copyright © 2016 Telegram. All rights reserved.
//

import Cocoa
import TelegramCoreMac
open class GridItem : NSObject,Identifiable {
    
    public internal(set) weak var parent:GridRowItem?
    
    let _stableId = Int64(arc4random())
    open var stableId: Int64 {
        return _stableId
    }
    
    public let originalSize:NSSize
    public private(set) var size:NSSize = NSZeroSize
    
    public init(size:NSSize = NSZeroSize) {
        self.originalSize = size
        super.init()
    }
    
    public func resize(size:NSSize) -> Void {
        self.size = originalSize.aspectFitted(size)
    }
    
    open var viewClass:AnyClass {
        return GridView.self
    }
    
}

class EmptyGridItem: GridItem {
    
}

public class GridRowItem: TableRowItem {
    
    public var itemsCount:Int {
        return items.filter({!$0.isKind(of: EmptyGridItem.self)}).count
    }
    
    public override var height: CGFloat {
        return items.map({ (item) -> CGFloat in
            return item.size.height
        }).max()! + inset
        
    }
    
    public override var stableId: Int64 {
        var s:Int64 = 0
        for item in items {
            s += item.stableId
        }
        return s
    }
    
    let inset:CGFloat
    public let fitWidth:CGFloat
    
    private var fitInset:CGFloat {
        return inset * (CGFloat(items.count) + 1)
    }
    
    private(set) var items:[GridItem]

    public init(grid: GridTableView) {
        let (count,fit) = grid.rowSetting()
        self.items = [GridItem](repeating: EmptyGridItem(), count: count)
        self.fitWidth = fit
        self.inset = count % 2 == 0 ? CGFloat(count) : CGFloat(count + 1)
        super.init(grid)
    }
    
    public func add(item:GridItem) -> Void {
        let index = items.index(where: {$0.isKind(of: EmptyGridItem.self)})!
        items[index] = item
        item.parent = self
    }
    
    public func insert(item:GridItem, at:Int) -> Void {
        items[at] = item
        item.parent = self
    }
    
    public func remove(item:GridItem) -> Void {
        let index = items.index(where: {$0 == item})!
        items[index] = EmptyGridItem()
        item.parent = nil
    }
    
    public func index(where stableId:Int64) -> Int? {
        return items.index(where:{$0.stableId == stableId})
    }
    
    public func sizeToFit() -> Void {
        
        var prop:CGFloat = fitWidth - inset - 1
        let overpixels:Int = min(max((Int(prop) * items.count + Int(fitInset)) - Int(width),0), items.count)
        var i:Int = 0
        for item in items {
            item.resize(size: NSMakeSize(prop - (i > items.count - 1 - overpixels ? 1 : 0), prop))
            i += 1
        }
    }
    
    public var isFilled:Bool {
        return items.index(where: {$0.isKind(of: EmptyGridItem.self)}) == nil
    }
    
    public override func viewClass() -> AnyClass {
        return GridRowView.self
    }
    
    
    
}
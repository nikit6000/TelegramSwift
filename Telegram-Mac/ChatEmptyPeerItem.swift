//
//  ChatEmptyPeerItem.swift
//  TelegramMac
//
//  Created by keepcoder on 10/12/2016.
//  Copyright © 2016 Telegram. All rights reserved.
//

import Cocoa
import TGUIKit
import TelegramCoreMac
import PostboxMac
class ChatEmptyPeerItem: TableRowItem {

    let textViewLayout:TextViewLayout
    
    override var stableId: AnyHashable {
        return 0
    }
    let chatInteraction:ChatInteraction
    
    override var animatable: Bool {
        return false
    }
    
    override var height: CGFloat {
        if let table = table {
            return table.frame.height
        }
        return initialSize.height
    }
    
    init(_ initialSize: NSSize, chatInteraction:ChatInteraction) {
        self.chatInteraction = chatInteraction
        
        let attr = NSMutableAttributedString()
        if  chatInteraction.peerId.namespace == Namespaces.Peer.SecretChat {
            _ = attr.append(string: tr(.chatSecretChatEmptyHeader), color: theme.colors.grayText, font: .normal(.text))
            _ = attr.append(string: "\n\n")
            _ = attr.append(string: tr(.chatSecretChat1Feature), color: theme.colors.grayText, font: .normal(.text))
            _ = attr.append(string: "\n")
            _ = attr.append(string: tr(.chatSecretChat2Feature), color: theme.colors.grayText, font: .normal(.text))
            _ = attr.append(string: "\n")
            _ = attr.append(string: tr(.chatSecretChat3Feature), color: theme.colors.grayText, font: .normal(.text))
            _ = attr.append(string: "\n")
            _ = attr.append(string: tr(.chatSecretChat4Feature), color: theme.colors.grayText, font: .normal(.text))

        } else {
            _ = attr.append(string: tr(.chatEmptyChat), color: theme.colors.grayText, font: .normal(.text))
        }
        textViewLayout = TextViewLayout(attr, alignment: .center)
        super.init(initialSize)
    }
    
    override func makeSize(_ width: CGFloat, oldWidth:CGFloat) -> Bool {
        textViewLayout.measure(width: width - 40)
        return super.makeSize(width)
    }
    
    override func viewClass() -> AnyClass {
        return ChatEmptyPeerView.self
    }
    
}


class ChatEmptyPeerView : TableRowView {
    let textView:TextView = TextView()
    required init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addSubview(textView)
    }
    
    override func updateColors() {
        super.updateColors()
        textView.background = backdorColor
    }
    
    override func layout() {
        super.layout()
        if let item = item as? ChatEmptyPeerItem {
            item.textViewLayout.measure(width: frame.width - 40)
            textView.update(item.textViewLayout)
            textView.center()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


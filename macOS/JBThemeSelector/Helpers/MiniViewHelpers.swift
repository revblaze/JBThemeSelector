//
//  MiniViewHelpers.swift
//  JBThemeSelector
//
//  Created by Justin Bush on 2020-12-05.
//

import Cocoa

extension TSViewController {
    
    func initMiniViews() {
        leftView.wantsLayer = true
        leftView.layer?.cornerRadius = 12
        leftView.layer?.masksToBounds = true
        rightView.wantsLayer = true
        rightView.layer?.cornerRadius = 12
        rightView.layer?.masksToBounds = true
    }
    
}

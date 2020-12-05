//
//  HoverHelpers.swift
//  JBThemeSelector
//
//  Created by Justin Bush on 2020-12-05.
//

import Cocoa

extension TSViewController {
    
    func initThemeHelper() {
        themeHelperView.alphaValue = 0
        themeHelperView.wantsLayer = true
        themeHelperView.layer?.cornerRadius = 12
        themeHelperView.layer?.masksToBounds = true
    }
    
    func initWallpaperHelper() {
        wallpaperHelperView.alphaValue = 0
        wallpaperHelperView.wantsLayer = true
        wallpaperHelperView.layer?.cornerRadius = 12
        wallpaperHelperView.layer?.masksToBounds = true
    }
    
}

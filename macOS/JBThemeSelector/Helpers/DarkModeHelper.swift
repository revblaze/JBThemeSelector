//
//  DarkModeHelper.swift
//  JBThemeSelector
//
//  Created by Justin Bush on 2020-12-08.
//

import Cocoa

extension TSViewController {
    
    /// Initializes dark mode helper with fill image view
    func initDarkModeHelper() {
        darkModeHelperView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        darkModeHelperView.image = NSImage(named: .darkModeHint)
        
        view.addSubview(darkModeHelperView)
        self.view = view
        
        darkModeHelperView.alphaValue = 0
    }

    
    /// Handles the Dark Mode checkbox and sets the state based on the system appearance.
    func initDarkModeToggle() {
        if view.hasDarkAppearance {
            darkModeCheckbox.state = .on
        } else {
            darkModeCheckbox.state = .off
        }
    }
    /// Allows the Dark Mode checkbox to remain enabled while disabling it's manual state change.
    @IBAction func darkModeToggleWasClicked(_ sender: NSButton) {
        if view.hasDarkAppearance {
            darkModeCheckbox.state = .on
        } else {
            darkModeCheckbox.state = .off
        }
    }
    
    func initSystemAppearanceObserver() {
        // System Appearance Change Notification
        DistributedNotificationCenter.default.addObserver(forName: .systemAppearanceDidChange,
                                                          object: nil, queue: OperationQueue.main) {
            [weak weakSelf = self] (notification) in
            weakSelf?.initDarkModeToggle()
        }
    }
    
}

// Dark Mode Hint Image
extension NSImage.Name {
    static let darkModeHint = NSImage.Name("DarkModeHint")
}
extension Notification.Name {
    static let systemAppearanceDidChange = Notification.Name("AppleInterfaceThemeChangedNotification")
}

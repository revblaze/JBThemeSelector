//
//  ViewController.swift
//  JBThemeSelector
//
//  Created by Justin Bush on 2020-12-05.
//

import Cocoa

var appTheme = Theme.solid

class ViewController: NSViewController, NSWindowDelegate {

    @IBOutlet var blurView: NSVisualEffectView!
    @IBOutlet var themeSelectorButton: NSButton!
    
    var themeSelectorWindowController: TSWindowController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTheme(.solid)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NSWindowDelegate.windowDidBecomeKey(_:)), name: NSWindow.didBecomeKeyNotification, object: nil)
    }
    
    
    func setTheme(_ theme: Theme) {
        blurView.isHidden = !theme.isTransparent    // Hide/Show BlurView
        blurView.material = theme.material          // Set Theme Material
    }
    
    func windowDidBecomeKey(_ notification: Notification) {
        //if newThemeWasApplied {
            //setTheme(appTheme)
            //newThemeWasApplied = false
        //}
    }
    
    @IBAction func openThemeSelector(_ sender: Any) {
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        if let themeSelectorWC = storyboard.instantiateController(withIdentifier: .themeSelectorWindow) as? TSWindowController {
            self.themeSelectorWindowController = themeSelectorWC
            themeSelectorWC.showWindow(self)
        }
    }

    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}


// MARK: Segue ID Extension
extension NSStoryboardSegue.Identifier {
    static let themeSelectorWindow = NSStoryboardSegue.Identifier("ThemeSelectorWindow")
}


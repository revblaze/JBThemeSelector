//
//  TSViewController.swift
//  JBThemeSelector
//
//  Created by Justin Bush on 2020-12-05.
//

import Cocoa

var wallpaperID = 0                 // Wallpaper ID (0..2)
var activeHoverState = false        // Hover State Flag
var selectedTheme = appTheme        // Selected Theme to Apply
var newThemeWasApplied = false      // Apply New Theme Flag

class TSViewController: NSViewController, NSToolbarDelegate {

    // UI Setup
    @IBOutlet var wallpaperView: NSImageView!
    
    // Mini Views
    @IBOutlet var leftView: NSView!                     // Left Mini View
    @IBOutlet var leftBlurView: NSVisualEffectView!     // Left Background Blur
    @IBOutlet var rightView: NSView!                    // Right Mini View
    @IBOutlet var rightBlurView: NSVisualEffectView!    // Right Background Blur
    
    // UI Elements
    @IBOutlet var themeControl: NSSegmentedControl!
    
    // Dark Mode Helpers
    let darkModeHelperView = NSImageView()
    @IBOutlet var darkModeCheckbox: NSButton!           // Checkbox: Dark Mode
    
    // Hover Helpers
    @IBOutlet weak var themeHelperView: NSView!         // Theme Mini Helper View
    @IBOutlet weak var wallpaperHelperView: NSView!     // Wallpaper Mini Helper View

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMiniViews()             // Initialize Mini Views
        initThemeHelper()           // Initialize Theme Helper Text
        initWallpaperHelper()       // Initialize Wallpaper Helper
        initDarkModeHelper()        // Initialize Dark Mode Helper
        initTrackingArea()          // Initialize Tracking Area
        
        // Initialize System Appearance Observer
        initSystemAppearanceObserver()
        
        setTheme(appTheme)                                      // Set Mini Theme
        themeControl.selectSegment(withTag: appTheme.rawInt)    // Set `appTheme` as currentTheme
        
        // TSWindowController Notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeWallpaper(_:)), name: .didChangeWallpaper, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeHoverState(_:)), name: .didChangeHoverState, object: nil)
    }
    
    
    
    // MARK: Theme Control Handler
    @IBAction func didSelectTheme(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case 0: setTheme(.solid)
        case 1: setTheme(.misty)
        case 2: setTheme(.glass)
        default: setTheme(.misty)
        }
    }
    
    func setTheme(_ theme: Theme) {
        leftView.backgroundColor = .clear
        rightView.backgroundColor = .clear
        
        if !theme.isTransparent {
            if view.hasDarkAppearance {
                leftView.backgroundColor = .black
                rightView.backgroundColor = .black
            } else {
                leftView.backgroundColor = .white
                rightView.backgroundColor = .white
            }
        }
        
        leftBlurView.isHidden = !theme.isTransparent        // Hide/Show BlurView
        leftBlurView.material = theme.material              // Set Theme Material
        rightBlurView.isHidden = !theme.isTransparent       // Hide/Show BlurView
        rightBlurView.material = theme.material             // Set Theme Material
        
        selectedTheme = theme
    }
    
    
    // MARK: Wallpaper Control Handler
    @objc func didChangeWallpaper(_ notification: Notification) {
        switch wallpaperID {
        case 0: wallpaperView.image = NSImage(named: .wave)
        case 1: wallpaperView.image = NSImage(named: .bigSur)
        case 2: wallpaperView.image = NSImage(named: .liquid)
        default: wallpaperView.image = NSImage(named: .bigSur)
        }
    }
    @objc func didChangeHoverState(_ notification: Notification) {
        if activeHoverState {
            wallpaperHelperView.animator().alphaValue = 1
        } else {
            wallpaperHelperView.animator().alphaValue = 0
        }
    }
    
    /// Sets flag to apply new selected theme for the main ViewController's keyWindow notification and closes ThemeSelector window.
    @IBAction func applySaveClose(_ sender: Any) {
        newThemeWasApplied = true       // Sets flag for windowDidBecomeKey to initTheme()
        self.view.window?.close()       // Closes ThemeSelector window
    }
    
    override func viewWillDisappear() {
        // IF the user closed the window instead of clicking "Apply & Save"
        if !newThemeWasApplied {
            print("Theme selection cancelled. Do not apply new theme.")
        } else {
            print("New theme was selected. Apply and close window.")
            appTheme = selectedTheme
            NotificationCenter.default.post(Notification(name: .willApplyNewTheme))
        }
    }
    
    
    // MARK:- Tracking Events
    /// Initialize the tracking area for mouse hover events over `wallpaperControl`
    func initTrackingArea() {
        let themeUserInfo = ["segmentName": "themeControl"]
        let themeSegmentArea = NSTrackingArea.init(rect: themeControl.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: themeUserInfo)
        themeControl.addTrackingArea(themeSegmentArea)
        let darkModeUserInfo = ["checkboxName": "darkModeCheckbox"]         // Tracker ID: Dark Mode Checkbox
        let darkModeCheckboxArea = NSTrackingArea.init(rect: darkModeCheckbox.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: darkModeUserInfo)
                darkModeCheckbox.addTrackingArea(darkModeCheckboxArea)
    }
    
    
    
    // MARK: Mouse Hover Events
    // Called when the mouse enters a tracking area
    override func mouseEntered(with event: NSEvent) {
        if let segmentName = event.trackingArea?.userInfo?.values.first as? String {
            if segmentName == "themeControl" {
                themeHelperView.animator().alphaValue = 1
            } else if segmentName == "darkModeCheckbox" {
                darkModeHelperView.animator().alphaValue = 1
            }
        }
    }
    // Called when the mouse exits a tracking area
    override func mouseExited(with event: NSEvent) {
        if let segmentName = event.trackingArea?.userInfo?.values.first as? String {
            if segmentName == "themeControl" {
                themeHelperView.animator().alphaValue = 0
            } else if segmentName == "darkModeCheckbox" {
                darkModeHelperView.animator().alphaValue = 0
            }
        }
    }
    
}


// MARK: Extensions
// Notifications
extension Notification.Name {
    static let didChangeWallpaper = Notification.Name("didChangeWallpaper")
    static let didChangeHoverState = Notification.Name("didChangeHoverState")
}
// Wallpaper Assets
extension NSImage.Name {
    static let wave = NSImage.Name("Wave")
    static let bigSur = NSImage.Name("BigSur")
    static let liquid = NSImage.Name("Liquid")
}
// View Background Color
extension NSView {
    var backgroundColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
    var hasDarkAppearance: Bool {
        if #available(OSX 10.14, *) {
            switch effectiveAppearance.name {
            case .darkAqua, .vibrantDark, .accessibilityHighContrastDarkAqua, .accessibilityHighContrastVibrantDark:
                return true
            default:
                return false
            }
        } else {
            switch effectiveAppearance.name {
            case .vibrantDark:
                return true
            default:
                return false
            }
        }
    }
}

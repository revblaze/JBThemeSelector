//
//  TSWindowController.swift
//  JBThemeSelector
//
//  Created by Justin Bush on 2020-12-05.
//

import Cocoa

class TSWindowController: NSWindowController, NSToolbarDelegate {

    @IBOutlet weak var wallpaperControl: NSSegmentedControl!
    
    override func windowDidLoad() {
        super.windowDidLoad()
    
        initTrackingArea()
    }
    
    
    @IBAction func didSelectWallpaper(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case 0: wallpaperID = 0
        case 1: wallpaperID = 1
        case 2: wallpaperID = 2
        default: wallpaperID = 1
        }
        NotificationCenter.default.post(Notification(name: .didChangeWallpaper))
    }
    
    
    
    // MARK:- Tracking Events
    /// Initialize the tracking area for mouse hover events over `wallpaperControl`
    func initTrackingArea() {
        let wallpaperUserInfo = ["segmentName": "wallpaperControl"]
        let wallpaperSegmentArea = NSTrackingArea.init(rect: wallpaperControl.bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeAlways], owner: self, userInfo: wallpaperUserInfo)
        wallpaperControl.addTrackingArea(wallpaperSegmentArea)
    }
    
    
    
    // MARK: Mouse Hover Events
    
    func mouseWillHover(_ state: Bool) {
        activeHoverState = state
        NotificationCenter.default.post(Notification(name: .didChangeHoverState))
        
    }
    // Called when the mouse enters a tracking area
    override func mouseEntered(with event: NSEvent) {
        if let segmentName = event.trackingArea?.userInfo?.values.first as? String {
            if segmentName == "wallpaperControl" {
                mouseWillHover(true)
            }
        }
    }
    // Called when the mouse exits a tracking area
    override func mouseExited(with event: NSEvent) {
        if let segmentName = event.trackingArea?.userInfo?.values.first as? String {
            if segmentName == "wallpaperControl" {
                mouseWillHover(false)
            }
        }
    }
    
}


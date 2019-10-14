//
//  ViewController.swift
//  MetalExperimentMac
//
//  Created by Peter Tang on 14/10/2019.
//  Copyright © 2019 Peter Tang. All rights reserved.
//

#if os(OSX)

import Cocoa
typealias MyViewController = NSViewController

#elseif os(iOS) || targetEnvironment(simulator) || targetEnvironment(macCatalyst)

import UIKit
typealias MyViewController = UIViewController

#endif

import MetalKit

class ViewController: MyViewController {

    private var _view: MTKView!
    private var _renderer: AAPLRenderer?
    private var _mpsRenderer: Renderer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureMTKView()
        // plainBlueScreen()
        bubbleScreen()
    }

    fileprivate func configureMTKView() {
        _view = MTKView()
        view.addSubview(_view)
        
        _view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            _view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            _view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            _view.topAnchor.constraint(equalTo: view.topAnchor),
            _view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    fileprivate func plainBlueScreen() {
        _view.enableSetNeedsDisplay = true
        _view.device = MTLCreateSystemDefaultDevice()
        _view.clearColor = MTLClearColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        _renderer = AAPLRenderer(with: _view)
        
        guard let _ = _renderer else {
            fatalError("Renderer initialization failed")
        }
        _renderer?.mtkView(_view, drawableSizeWillChange: _view.drawableSize)
        _view.delegate = _renderer
    }
    
    fileprivate func bubbleScreen() {

        #if os(OSX)
            debugPrint(#function, "for osx runtime")
            #if os(OSX)
                let colorSpace = CGColorSpace.init(name: CGColorSpace.linearSRGB)
                self._view.colorspace = colorSpace
                debugPrint(#function, "colorSpace for osx runtime")
            #endif
            let devices = MTLCopyAllDevices()
            let device = devices.filter { !$0.isLowPower }.first ?? devices.first
        #elseif targetEnvironment(macCatalyst)
            debugPrint(#function, "for macCatalyst runtime, 都唔知用乜好!")
            let devices = MTLCopyAllDevices()
            let device = devices.filter { !$0.isLowPower }.first ?? devices.first
        #elseif os(iOS) || targetEnvironment(simulator)
            debugPrint(#function, "for non-osx runtime")
            let device = MTLCreateSystemDefaultDevice()
            _view.backgroundColor = .clear
        #endif
        
        _view.device = device
        guard let _ = _view.device else {
            debugPrint("Metal is not supported on this device")
            return
        }
    }

    #if os(OSX)
    override func viewDidAppear() {
        super.viewDidAppear()
        debugPrint(#function, "bounds size", _view.bounds.size, _view.drawableSize)
        _mpsRenderer = Renderer(metalKitView: _view)
        _mpsRenderer?.mtkView(_view, drawableSizeWillChange: _view.bounds.size)
        _view.delegate = _mpsRenderer
    }
    #elseif os(iOS) || targetEnvironment(simulator) || targetEnvironment(macCatalyst)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint(#function, "bounds size", _view.bounds.size, _view.drawableSize)
        _mpsRenderer = Renderer(metalKitView: _view)
        _mpsRenderer?.mtkView(_view, drawableSizeWillChange: _view.bounds.size)
        _view.delegate = _mpsRenderer
    }
    #endif
    
}


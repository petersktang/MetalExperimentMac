//
//  AAPLRenderer.swift
//  MetalExperimentMac
//
//  Created by Peter Tang on 14/10/2019.
//  Copyright © 2019 Peter Tang. All rights reserved.
//

import Foundation
import MetalKit

class AAPLRenderer: NSObject, MTKViewDelegate {

    private var _device: MTLDevice!
    private var _commandQueue: MTLCommandQueue!
    
    init(with mtkView: MTKView) {
        super.init()
        _device = mtkView.device
        _commandQueue = mtkView.device?.makeCommandQueue()
    }
    
    /// Called whenever view changes orientation or is resized
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        //
    }
    
    /// Called whenever the view needs to render a frame.
    func draw(in view: MTKView) {
        // The render pass descriptor references the texture into which Metal should draw
        guard let renderPassDescriptor = view.currentRenderPassDescriptor else { return }
        let commandBuffer = _commandQueue.makeCommandBuffer()
        // Create a render pass and immediately end encoding, causing the drawable to be cleared
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.endEncoding()
        // Get the drawable that will be presented at the end of the frame
        guard let drawable = view.currentDrawable else { fatalError("Unable to obtain currentDrawable from MTKView") }
        // Request that the drawable texture be presented by the windowing system once drawing is done
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}

//
//  ViewController.swift
//  MonoImage
//
//  Created by Jun Tanaka on 2017/01/18.
//  Copyright © 2017 eje Inc. All rights reserved.
//

import UIKit
import Metal
import MetalScope

final class ViewController: UIViewController {
    lazy var device: MTLDevice = {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Failed to create MTLDevice")
        }
        return device
    }()

    weak var panoramaView: PanoramaView?

    private func loadPanoramaView() {
        let panoramaView = PanoramaView(frame: view.bounds, device: device)
        panoramaView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(panoramaView)

        // fill parent view
        let constraints: [NSLayoutConstraint] = [
            panoramaView.topAnchor.constraint(equalTo: view.topAnchor),
            panoramaView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            panoramaView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            panoramaView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)

        // double tap to reset center
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: panoramaView, action: #selector(PanoramaView.resetCenter))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        panoramaView.addGestureRecognizer(doubleTapGestureRecognizer)

        self.panoramaView = panoramaView

        panoramaView.load(#imageLiteral(resourceName: "Sample"), format: .mono)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        loadPanoramaView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        panoramaView?.updateInterfaceOrientation(with: coordinator)
    }
}

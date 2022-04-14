//
//  RootViewController.swift
//  BottomSheetDemo
//
//  Created by Mikhail Maslo on 14.11.2021.
//  Copyright © 2021 Joom. All rights reserved.
//

import UIKit
import BottomSheet

final class RootViewController: UIViewController {
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Show BottomSheet", for: .normal)
        return button
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        view.addSubview(button)
        button.addTarget(self, action: #selector(handleShowBottomSheet), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private var transitionDelegate: UIViewControllerTransitioningDelegate?
    
    @objc
    private func handleShowBottomSheet() {
        let viewController = ResizeViewController(initialHeight: 300)
        let navigationController = BottomSheetNavigationController(rootViewController: viewController)
        transitionDelegate = BottomSheetTransitioningDelegate(presentationControllerFactory: self)
        navigationController.transitioningDelegate = transitionDelegate
        navigationController.modalPresentationStyle = .custom
        present(navigationController, animated: true, completion: nil)
    }
}

// MARK: - BottomSheetPresentationControllerFactory
extension RootViewController: BottomSheetPresentationControllerFactory {
    
    func makeBottomSheetPresentationController(
        presentedViewController: UIViewController,
        presentingViewController: UIViewController?
    ) -> BottomSheetPresentationController {
        return BottomSheetPresentationController(
            presentedViewController: presentedViewController,
            presentingViewController: presentingViewController,
            dismissalHandler: self
        )
    }
}

// MARK: - BottomSheetModalDismissalHandler
extension RootViewController: BottomSheetModalDismissalHandler {
    
    var canBeDismissed: Bool {
        return true
    }
    
    func performDismissal(animated: Bool) {
        presentedViewController?.dismiss(animated: animated, completion: nil)
        transitionDelegate = nil
    }
}

//
//  ResizeViewController.swift
//  BottomSheetDemo
//
//  Created by Mikhail Maslo on 15.11.2021.
//  Copyright © 2021 Joom. All rights reserved.
//

import UIKit
import BottomSheet

final class ResizeViewController: UIViewController {
    // MARK: - Subviews
    
    private let contentSizeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    var isShowNextButtonHidden: Bool {
        navigationController == nil
    }
    
    var isShowRootButtonHidden: Bool {
        navigationController?.viewControllers.count ?? 0 <= 1
    }
    
    private let showNextButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Show next", for: .normal)
        return button
    }()
    
    private let showRootButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Show root", for: .normal)
        return button
    }()
    
    private let reSizeScrollView = UIScrollView()
    
    // MARK: - Private properties

    private lazy var actions = [
        ButtonAction(title: "x2", backgroundColor: .systemBlue, handler: { [unowned self] in
            updateContentHeight(newValue: currentHeight * 2)
        }),
        ButtonAction(title: "/2", backgroundColor: .systemBlue, handler: { [unowned self] in
            updateContentHeight(newValue: currentHeight / 2)
        }),
        ButtonAction(title: "+100", backgroundColor: .systemBlue, handler: { [unowned self] in
            updateContentHeight(newValue: currentHeight + 100)
        }),
        ButtonAction(title: "-100", backgroundColor: .systemBlue, handler: { [unowned self] in
            updateContentHeight(newValue: currentHeight - 100)
        }),
    ]
    
    private var currentHeight: CGFloat {
        didSet {
            updatePreferredContentSize()
        }
    }
    
    // MARK: - Init

    init(initialHeight: CGFloat) {
        currentHeight = initialHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewCoontroller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
        updatePreferredContentSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.setNeedsLayout()
    }
    
    // MARK: - Setup
    
    private func setupSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(reSizeScrollView)
        reSizeScrollView.alwaysBounceVertical = true
        
        reSizeScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reSizeScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            reSizeScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            reSizeScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            reSizeScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        reSizeScrollView.addSubview(contentSizeLabel)
        
        contentSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentSizeLabel.topAnchor.constraint(equalTo: reSizeScrollView.topAnchor),
            contentSizeLabel.leadingAnchor.constraint(lessThanOrEqualTo: reSizeScrollView.leadingAnchor),
            contentSizeLabel.trailingAnchor.constraint(greaterThanOrEqualTo: reSizeScrollView.trailingAnchor),
            contentSizeLabel.centerXAnchor.constraint(equalTo: reSizeScrollView.centerXAnchor)
        ])
        
        let buttons = actions.map(UIButton.init(buttonAction:))
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.distribution = .fillEqually
        stackView.spacing = 8

        reSizeScrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentSizeLabel.bottomAnchor, constant: 8),
            stackView.leadingAnchor.constraint(lessThanOrEqualTo: reSizeScrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(greaterThanOrEqualTo: reSizeScrollView.trailingAnchor, constant: -16),
            stackView.centerXAnchor.constraint(equalTo: reSizeScrollView.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        if !isShowNextButtonHidden {
            reSizeScrollView.addSubview(showNextButton)
            showNextButton.addTarget(self, action: #selector(handleShowNext), for: .touchUpInside)
            
            showNextButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                showNextButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8),
                showNextButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
                showNextButton.widthAnchor.constraint(equalToConstant: 300),
                showNextButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        if !isShowRootButtonHidden {
            reSizeScrollView.addSubview(showRootButton)
            showRootButton.addTarget(self, action: #selector(handleShowRoot), for: .touchUpInside)
            
            showRootButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                showRootButton.topAnchor.constraint(equalTo: isShowNextButtonHidden ? stackView.bottomAnchor : showNextButton.bottomAnchor, constant: 8),
                showRootButton.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
                showRootButton.widthAnchor.constraint(equalToConstant: 300),
                showRootButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    // MARK: - Private methods
    
    private func updatePreferredContentSize() {
        reSizeScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: currentHeight)
        contentSizeLabel.text = "preferredContentHeight = \(currentHeight)"
        preferredContentSize = reSizeScrollView.contentSize
    }
    
    private func updateContentHeight(newValue: CGFloat) {
        guard newValue >= 200 && newValue < 5000 else { return }
        
        currentHeight = newValue
        updatePreferredContentSize()
    }
    
    @objc
    private func handleShowNext() {
        let viewController = ResizeViewController(initialHeight: currentHeight)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc
    private func handleShowRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

// MARK: - ScrollableBottomSheetPresentedController

extension ResizeViewController: ScrollableBottomSheetPresentedController {
    var scrollView: UIScrollView? {
        return reSizeScrollView
    }
}

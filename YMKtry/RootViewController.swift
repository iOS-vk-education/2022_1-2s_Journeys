//
//  eventsCoordinator.swift
//  YMKtry
//
//  Created by User on 19.12.2022.
//

import UIKit

class RootViewController: UIViewController {

    private var current: UIViewController
    
    init() {
        current = ViewController()
        super.init(nibName:  nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(current)
        current.view.frame = view.bounds
        view.addSubview(current.view)
        current.didMove(toParent: self)
    }
    
    func showLoginScreen() {
        
        let new = UINavigationController(rootViewController: ViewController())
        
        addChild(new)
        new.view.frame = view.bounds
        view.addSubview(new.view)
        new.didMove(toParent: self)
        
        current.willMove(toParent: nil)
        current.view.removeFromSuperview()
        current.removeFromParent()
        
        current = new
    }
    
    
    func switchToAdding() {
        let mainViewController = tapToAddButton()
        let mainScreen = MainNavigationController(rootViewController: mainViewController)
        animateFadeTransition(to: mainScreen)
    }
    
    func switchToMainScreen() {
        let mainViewController = ViewController()
        let mainScreen = MainNavigationController(rootViewController: mainViewController)
        animateFadeTransition(to: mainScreen)
    }
    
    func switchToAddingEvent() {
        let mainViewController = AddingEvent()
        let mainScreen = MainNavigationController(rootViewController: mainViewController)
        animateFadeTransition(to: mainScreen)
    }
    
    
    
    
    private func animateFadeTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        current.willMove(toParent: nil)
        addChild(new)
        transition(from: current, to: new, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseOut], animations: {
            
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
    
    private func animateDismissTransition(to new: UIViewController, completion: (() -> Void)? = nil) {
        
        let initialFrame = CGRect(x: -view.bounds.width, y: 0, width: view.bounds.width, height: view.bounds.height)
        current.willMove(toParent: nil)
        addChild(new)
        new.view.frame = initialFrame
        
        transition(from: current, to: new, duration: 0.3, options: [], animations: {
            new.view.frame = self.view.bounds
        }) { completed in
            self.current.removeFromParent()
            new.didMove(toParent: self)
            self.current = new
            completion?()
        }
    }
}

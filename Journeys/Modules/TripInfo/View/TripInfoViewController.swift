//
//  TripInfoViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 20/12/2022.
//

import UIKit

// MARK: - TripInfoViewController

final class TripInfoViewController: UIPageViewController {

    lazy var viewControllersList: [UIViewController] = {
        var viewControllers: [UIViewController] = []
        let stuffVC = StuffModuleBuilder().build()
        viewControllers.append(stuffVC)
        viewControllers.append(UIViewController())
        return viewControllers
    }()
    var output: TripInfoViewOutput!
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle,
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        setViewControllers([viewControllersList[0]], direction: .forward, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
    }
}

extension TripInfoViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let index = viewControllersList.firstIndex(of: viewController) {
            if index > 0 {
                return viewControllersList[index - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let index = viewControllersList.firstIndex(of: viewController) {
            if index < viewControllersList.count - 1 {
                return viewControllersList[index + 1]
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        print(viewControllersList.count)
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension TripInfoViewController: UIPageViewControllerDelegate {
    
}

extension TripInfoViewController: TripInfoViewInput {
}

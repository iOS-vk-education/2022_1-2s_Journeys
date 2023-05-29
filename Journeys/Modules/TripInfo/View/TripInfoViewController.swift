//
//  TripInfoViewController.swift
//  Journeys
//
//  Created by Nastya Ischenko on 20/12/2022.
//

import UIKit
import SnapKit

// MARK: - TripInfoViewController

final class TripInfoViewController: UIViewController {

    // MARK: Properties
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pageViewController.setViewControllers([viewControllersList[currentPageIndex]], direction: .forward, animated: true)
        return pageViewController
    }()

    private lazy var pageSegmentControll: UISegmentedControl = {
        let segmentControll = UISegmentedControl(items: getSecmentControllItems())
        segmentControll.selectedSegmentIndex = currentPageIndex
        segmentControll.addTarget(self, action: #selector(pageSegmentControllValueChanged), for: .valueChanged)
        return segmentControll
    }()

    private lazy var viewControllersList: [UIViewController] = {
        output.getViewControllers()
    }()

    private lazy var currentPageIndex: Int = {
        output.getCurrentPageIndex()
    }()

    private func getSecmentControllItems() -> [String] {
        [L10n.information, L10n.stuff]
    }

    var output: TripInfoViewOutput!

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(asset: Asset.Colors.Background.brightColor)
        setupViews()
    }

    private func setupViews() {
        view.addSubview(pageSegmentControll)
        view.addSubview(pageViewController.view)

        pageSegmentControll.layer.cornerRadius = 10.0

        pageSegmentControll.layer.masksToBounds = true
        setupConstraints()
        setupNavBar()
    }
    private func setupNavBar () {
        let exitButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"),
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(didTapExitButton))
        exitButtonItem.tintColor = UIColor(asset: Asset.Colors.Icons.iconsColor)
        navigationItem.leftBarButtonItem = exitButtonItem
        setupNavBarTitle(for: currentPageIndex)
    }
    
    private func setupNavBarTitle(for index: Int) {
        if index == 0 {
            title = L10n.placeInfo
        } else {
            title = L10n.stuffList
        }
    }
    
    private func setupConstraints() {
        pageSegmentControll.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(pageSegmentControll.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    @objc
    private func didTapExitButton() {
        output.didTapEvitButton()
    }
    
    @objc
    private func pageSegmentControllValueChanged() {
        pageSegmentControll.isEnabled = false;
        let index = pageSegmentControll.selectedSegmentIndex
        guard let viewController = viewControllersList[index] as? UIViewController else { return }
        if currentPageIndex < index {
            pageViewController.setViewControllers([viewController],
                                                  direction: .forward, animated: true,
                                                  completion:{(isFinished: Bool) in
                self.pageSegmentControll.isEnabled = true;
            })
        } else {
            pageViewController.setViewControllers([viewController],
                                                  direction: .reverse, animated: true,
                                                  completion:{(isFinished: Bool) in
                self.pageSegmentControll.isEnabled = true;
            })
        }
        currentPageIndex = index
        setupNavBarTitle(for: currentPageIndex)
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
        return 2
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension TripInfoViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
              let currentVC = pageViewController.viewControllers?.first,
              let index = viewControllersList.firstIndex(of: currentVC) else { return }
        currentPageIndex = index
        pageSegmentControll.selectedSegmentIndex = currentPageIndex
        setupNavBarTitle(for: currentPageIndex)
        pageSegmentControll.isEnabled = true
    }
}

extension TripInfoViewController: TripInfoViewInput {
}

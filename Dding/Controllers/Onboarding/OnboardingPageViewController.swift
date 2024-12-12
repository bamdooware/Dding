//
//  OnboardingContentViewController.swift
//  Dding
//
//  Created by 이지은 on 11/10/24.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {

    var onboardingPageList = [UIViewController]()
    weak var onboardingDelegate: OnboardingPageControlDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.dataSource = self
            self.delegate = self
            
            let storyBoard = UIStoryboard(name: "OnboardingScreen", bundle: nil)
            onboardingPageList = [
                storyBoard.instantiateViewController(withIdentifier: "firstVC"),
                storyBoard.instantiateViewController(withIdentifier: "secondVC"),
                storyBoard.instantiateViewController(withIdentifier: "thirdVC"),
            ]
            
            onboardingDelegate?.numberOfPage(numberOfPage: onboardingPageList.count)
            setViewControllers([onboardingPageList[0]], direction: .forward, animated: false, completion: nil)
        }
        
    func movePage(index: Int) {
        let currentViewController = viewControllers!.first!
        let currentViewControllerIndex = onboardingPageList.firstIndex(of: currentViewController)!
        let direction: NavigationDirection = index > currentViewControllerIndex ? .forward : .reverse
        
        setViewControllers([onboardingPageList[index]], direction: direction, animated: false, completion: nil)
    }
    }

    extension OnboardingPageViewController: UIPageViewControllerDataSource {
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            let currentIndex = onboardingPageList.firstIndex(of: viewController)!
            if currentIndex == 0 {
                return nil
            } else {
                return onboardingPageList[currentIndex - 1]
            }
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            let currentIndex = onboardingPageList.firstIndex(of: viewController)!
            if currentIndex == onboardingPageList.count - 1 {
                return nil
            } else {
                return onboardingPageList[currentIndex + 1]
            }
        }
    }

    extension OnboardingPageViewController: UIPageViewControllerDelegate {
        func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            if let currentPageViewController = pageViewController.viewControllers?.first {
                let index = onboardingPageList.firstIndex(of: currentPageViewController)!
                onboardingDelegate?.pageChangedTo(index: index)
            }
        }

}

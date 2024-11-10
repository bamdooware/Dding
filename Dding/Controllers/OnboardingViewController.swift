//
//  OnboardingViewController.swift
//  Dding
//
//  Created by 이지은 on 11/9/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    @IBOutlet weak var continueWithAppleBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    var onboardingPageViewController: OnboardingPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        onboardingPageControl.preferredIndicatorImage = UIImage(named: "defaultPageIndicator")
        onboardingPageControl.setIndicatorImage(UIImage(named: "currentPageIndicator"), forPage: 0)
        //            onboardingPageControl.pageIndicatorTintColor = UIColor(named: "Gray")
        //            onboardingPageControl.currentPageIndicatorTintColor = UIColor(named: "Neo")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desinationViewController = segue.destination as? OnboardingPageViewController {
            onboardingPageViewController = desinationViewController
            onboardingPageViewController.onboardingDelegate = self
        }
    }

    @IBAction func changePageValue(_ sender: UIPageControl) {
        let currentPageIndex = onboardingPageControl.currentPage
        onboardingPageViewController.movePage(index: currentPageIndex)
        updatePageControl(currentPageIndex: currentPageIndex)
    }
    
    func updatePageControl(currentPageIndex: Int) {
        //            onboardingPageControl.pageIndicatorTintColor = UIColor(named: "Gray")
        //            onboardingPageControl.currentPageIndicatorTintColor = UIColor(named: "Neo")
        
        (0..<onboardingPageControl.numberOfPages).forEach { (index) in
            let currentPageIconImage = UIImage(named: "currentPageIndicator")
            let defaultPageIconImage = UIImage(named: "defaultPageIndicator")
            let pageIcon = index == currentPageIndex ? currentPageIconImage : defaultPageIconImage
            onboardingPageControl.setIndicatorImage(pageIcon, forPage: index)
        }
    }
    
    @IBAction func touchUpContinueWithAppleBtn(_ sender: Any) {
    }
    
    @IBAction func touchUpSkipBtn(_ sender: Any) {
        
    }
}

extension OnboardingViewController: OnboardingPageControlDelegate {
    func numberOfPage(numberOfPage: Int) {
        onboardingPageControl.numberOfPages = numberOfPage
    }
    
    func pageChangedTo(index: Int) {
        updatePageControl(currentPageIndex: index)
        onboardingPageControl.currentPage = index
    }
}

protocol OnboardingPageControlDelegate: AnyObject {
    func numberOfPage(numberOfPage: Int)
    func pageChangedTo(index: Int)
}

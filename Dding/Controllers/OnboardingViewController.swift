//
//  OnboardingViewController.swift
//  Dding
//
//  Created by 이지은 on 11/9/24.
//

import UIKit
import AuthenticationServices
import KeychainSwift

class OnboardingViewController: UIViewController {
    
    let keychain = KeychainSwift()
    let appleSignInManager = AppleSignInManager()
    @IBOutlet weak var onboardingPageControl: UIPageControl!
    @IBOutlet weak var continueWithAppleBtn: UIButton!
    @IBOutlet weak var skipBtn: UIButton!
    
    var onboardingPageViewController: OnboardingPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(keychain.get("userIdentifier") ?? "nil")
        print(keychain.get("userEmail") ?? "nil")
        appleSignInManager.delegate = self
        
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
    
    @IBAction func touchUpContinueWithAppleBtn(_ sender: UIButton) {
        appleSignInManager.requestSignInWithApple()
    }
    
    @IBAction func touchUpSkipBtn(_ sender: UIButton) {
        navigateToHomeScreen()
    }
}

extension OnboardingViewController: AppleSignInManagerDelegate {
    func didCompleteSignInSuccessfully() {
        DispatchQueue.main.async {
            let userIdentifier = self.keychain.get("userIdentifier") ?? "nil"
            let userEmail = self.keychain.get("userEmail") ?? "nil"
            print("User Identifier from Keychain: \(userIdentifier)")
            print("User Email from Keychain: \(userEmail)")

            self.navigateToHomeScreen()
        }
    }
    
    func didFailSignIn(error: Error) {
        print("Apple Sign-In 실패: \(error.localizedDescription)")
        
        let alert = UIAlertController(title: "로그인 실패", message: "로그인 중 문제가 발생했습니다. 다시 시도해주세요", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToHomeScreen() {
        let tabViewController = TabViewController()
        tabViewController.modalPresentationStyle = .fullScreen
        self.present(tabViewController, animated: true)
        print()
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

//
//  PageViewController.swift
//  2048 Battle
//
//  Created by James Jackson on 6/25/17.
//  Copyright © 2017 James Jackson. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    var pages = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hex: 0xFBF8EF)
        self.dataSource = self
        
        let page1: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "0")
        let page2: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "1")
        let page3: UIViewController! = storyboard?.instantiateViewController(withIdentifier: "2")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([page1], direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                let pageControl = view as! UIPageControl
                
                self.view.bringSubviewToFront(pageControl)
                pageControl.currentPageIndicatorTintColor = UIColor(hex: 0xEC8E53)
                pageControl.pageIndicatorTintColor = UIColor(hex: 0xAAAAAA)
            }
        }
    }
    
}

extension PageViewController : UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.restorationIdentifier == "2" {
            return pages [1]
        } else if viewController.restorationIdentifier == "1" {
            return pages [0]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.restorationIdentifier == "0" {
            return pages [1]
        } else if viewController.restorationIdentifier == "1" {
            return pages [2]
        } else {
            return nil
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

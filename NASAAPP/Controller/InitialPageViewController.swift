//
//  FrontPageViewController.swift
//  NASAAPP
//
//  Created by Andrew Graves on 1/2/20.
//  Copyright © 2020 Andrew Graves. All rights reserved.
//
//  Purpose: Models the page view controller

import UIKit

class InitialPageViewController: UIPageViewController {
    
    var orderedViewControllers: [SinglePageViewController] = []

    // Creates the two controllers that are the pages
    override func viewDidLoad() {
        super.viewDidLoad()
        orderedViewControllers.append(createSinglePageController(withIdentifier: "SinglePageViewController", as: .roverPostcard))
        orderedViewControllers.append(createSinglePageController(withIdentifier: "SinglePageViewController", as: .earthImagery))
        
        if let firstViewController = orderedViewControllers.first {
            firstViewController.type = .roverPostcard
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)

        }
        dataSource = self
        
    }
    
    // function that creates the view controllers depending on the style
    func createSinglePageController(withIdentifier identifier: String, as type: PageEnum) -> SinglePageViewController {
        if let viewController = storyboard?.instantiateViewController(identifier: identifier) as? SinglePageViewController{
            viewController.type = type
            return viewController
        }
        
        // I want the app to crash if the controller could not be created because there is somthing very wrong.
        fatalError("View controller could not be created")
    }
}


// MARK: DATA SOURCE

// Extends the controller to act as the pageview's data source. Adds functionality for swiping between screens
extension InitialPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController as! SinglePageViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController as! SinglePageViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
}

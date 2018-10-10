//
//  BallotViewerViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 28/07/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class TimelineEventsViewerViewController: BaseViewController, BindableType, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventThemeLabel: UILabel!
    
    private var pageViewController: UIPageViewController!
    private var eventsViewControllers = [UIViewController]()
    
    typealias ViewModelType = TimelineEventsViewerViewModel
    var viewModel:TimelineEventsViewerViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupColors()
        self.bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        
        //If user wants to go back with pop gesture without trigger page view scroll
        self.blockPageViewGestureForPopGesture()
        
        self.viewModel.timelineIndexToScroll.onNext(self.viewModel.displayedEventIndex.value)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.pageViewController = segue.destination as! UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
    }
    
    //MARK: - Style
    
    func setupColors() {
        self.eventTitleLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
        self.eventThemeLabel.textColor = UIColor(hex: Constants.Color.whiteColorCode)
    }
    
    //MARK: - Binding
    
    func bindViewModel() {
        
        self.bindPageViewController()
        self.bindTitleAndTheme()
    }
    
    private func bindPageViewController() {
        
        self.viewModel.eventsDetailsViewModelsList
            .asDriver()
            .drive(onNext: { [weak self] viewModelsToDisplay in
                self?.setupPageViewController(withViewModels: viewModelsToDisplay)
            }).disposed(by: self.disposeBag)
        
    }
    
    private func bindTitleAndTheme() {
        
        Observable<String>.combineLatest([self.viewModel.titleText.asObservable(), self.viewModel.themeText.asObservable()])
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] values in
                self?.update(title: values[0], andTheme: values[1])
            }).disposed(by: self.disposeBag)
    }
    
    //MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.eventsViewControllers.index(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex < self.viewModel.numberOfEvents - 1 {
            
            return self.eventsViewControllers[viewControllerIndex + 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.eventsViewControllers.index(of: viewController) else {
            return nil
        }
        
        if viewControllerIndex > 0 {
            return self.eventsViewControllers[viewControllerIndex - 1]
        } else {
            return nil
        }
    }
    
    //MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewController = pageViewController.viewControllers?[0],
            let viewControllerIndex = self.eventsViewControllers.index(of: viewController) else {
                return
        }
        
        self.viewModel.displayedEventIndex.value = viewControllerIndex
        self.viewModel.timelineIndexToScroll.onNext(viewControllerIndex)
    }
    
    // MARK: - Private helpers
    
    private func update(title:String, andTheme theme:String) {
        
        self.navigationView.layoutIfNeeded()
        self.eventTitleLabel.text = title
        self.eventThemeLabel.text = theme
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: { [weak self] in
            self?.navigationView.layoutIfNeeded()
        })
    }
    
    private func setupPageViewController(withViewModels viewModels:[BaseViewModel]) {
        
        self.eventsViewControllers = self.getTimelineEventsViewControllers(withViewModels: viewModels)
        let viewControllerToDisplay = self.eventsViewControllers[self.viewModel.displayedEventIndex.value]
        self.pageViewController.setViewControllers([viewControllerToDisplay], direction: .forward, animated: false, completion: nil)
        
    }
    
    private func getTimelineEventsViewControllers(withViewModels viewModels:[BaseViewModel]) -> [UIViewController] {
        
        var timelineEventsViewControllers = [UIViewController]()
        
        for viewModel in viewModels {
            
            if let ballotViewModel = viewModel as? BallotViewModel,
                let ballotViewController = R.storyboard.deputy().instantiateViewController(withIdentifier: R.storyboard.deputy.ballotViewController.identifier) as? BallotViewController {
                
                timelineEventsViewControllers.append(ballotViewController)
                ballotViewController.viewModel = ballotViewModel
                
            } else if let nonBallotViewModel = viewModel as? NonBallotViewModel,
                let nonBallotViewController = R.storyboard.deputy().instantiateViewController(withIdentifier: R.storyboard.deputy.nonBallotViewController.identifier) as? NonBallotViewController {
                
                timelineEventsViewControllers.append(nonBallotViewController)
                nonBallotViewController.viewModel = nonBallotViewModel
            }
        }
        
        return timelineEventsViewControllers
    }
    
    private func blockPageViewGestureForPopGesture() {
        
        guard let interactivePopGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer else {
            return
        }
        
        for view in self.pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.panGestureRecognizer.require(toFail: interactivePopGestureRecognizer)
            }
        }
    }
    
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

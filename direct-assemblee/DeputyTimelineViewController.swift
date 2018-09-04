//
//  DeputyTimelineViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 14/06/2017.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class DeputyTimelineViewController: BaseViewController, BindableType, UIViewControllerPreviewingDelegate {
    
    @IBOutlet weak var timeLineTableView: UITableView!

    private var refreshControl =  UIRefreshControl()
    
    typealias ViewModelType = DeputyTimelineViewModel
    var viewModel:DeputyTimelineViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.timeLineTableView.rowHeight = UITableViewAutomaticDimension
        self.timeLineTableView.estimatedRowHeight = 230
        self.timeLineTableView.separatorInset = .zero;
        
        self.refreshControl = self.createRefreshControl()
        self.timeLineTableView.contentInset = UIEdgeInsetsMake(Constants.Sizes.deputyHeaderCardMaxHeight, 0, 0, 0)
        self.timeLineTableView.backgroundView = self.refreshControl
        
        self.setupColors()
        self.bindViewModel()
        
        if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: self.timeLineTableView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupInfiniteScroll()
    }
    
    // MARK: - Style
    
    private func setupColors() {
        self.timeLineTableView.separatorColor = UIColor(hex: Constants.Color.blueColorCode)
    }
    
    //MARK: - Binding
    
    func bindViewModel() {
        self.bindPullToRefreh()
        self.bindTimelineEventsList()
        self.bindLoadingView()
        self.bindSelectedTimelineEvent()
        self.bindScrollEvents()
    }
    
    private func bindPullToRefreh() {
        
        self.refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] _ in
            self?.viewModel.isPullToRefreshControlDisplayed.value = true
        }).disposed(by: self.disposeBag)
        
        self.viewModel.isPullToRefreshControlDisplayed.asObservable().bind(to: self.refreshControl.rx.isRefreshing).disposed(by: self.disposeBag)
        
    }
    
    private func bindTimelineEventsList() {
        
        self.viewModel.eventsViewModels
            .asDriver(onErrorJustReturn: [])
            .drive(self.timeLineTableView.rx.items(cellIdentifier: R.reuseIdentifier.timelineEventTableViewCellIdentifier.identifier, cellType: TimelineEventTableViewCell.self)) { (index, timelineEventViewModel, timelineEventCell) in
                timelineEventCell.viewModel = timelineEventViewModel
            }.disposed(by: self.disposeBag)
        
        self.viewModel.isEventsListHidden.asDriver().drive(self.timeLineTableView.rx.isHidden).disposed(by: self.disposeBag)

        self.viewModel.isPlaceholderViewHidden.asDriver().drive(onNext: { [unowned self] isHidden in
            if isHidden {
               self.view.removePlaceholderView()
            } else {
                self.view.addPlaceholderView(label: self.viewModel.noEventsPlaceholderText, onRefresh: { [unowned self] in
                    self.viewModel.isUserWantsToLoadAll.onNext(())
                })
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func bindScrollEvents() {
        
        self.timeLineTableView.rx.didScroll.subscribe(onNext: { [weak self] _ in
            self?.viewModel.listScrollOffset.onNext(self?.timeLineTableView.contentOffset.y ?? 0)
        }).disposed(by: self.disposeBag)
        
        self.viewModel.didUserWantToScrollToTop.subscribe(onNext: { [weak self] _ in
            self?.timeLineTableView.setContentOffset(CGPoint(x: 0, y: -Constants.Sizes.deputyHeaderCardMaxHeight), animated: false)
        }).disposed(by: self.disposeBag)
    }
    
    
    private func bindLoadingView() {
        
        self.viewModel.isLoadingViewDisplayed
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] isDisplayed in
                
                if isDisplayed {
                    self?.view.addLoadingView()
                } else {
                    self?.view.removeLoadingView()
                }
                
            }).disposed(by: self.disposeBag)
    }
    
    
    private func bindSelectedTimelineEvent() {
        
        self.timeLineTableView.rx.modelSelected(TimelineEventViewModel.self).subscribe(onNext: { [weak self] timelineEventViewModel in
            self?.viewModel.selectedTimelineEventViewModel.onNext(timelineEventViewModel)
        }).disposed(by: self.disposeBag)
        
        self.timeLineTableView.rx.itemSelected
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                self?.timeLineTableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: self.disposeBag)
        
        self.viewModel.timelineEventsViewerViewModelToDisplay.asObservable().subscribe(onNext: { [weak self] timelineEventsViewerViewModel in
            
            guard let timelineEventsViewerViewModel = timelineEventsViewerViewModel else {
                return
            }
            
            self?.displayTimelineEventsViewer(withViewModel: timelineEventsViewerViewModel)
            
        }).disposed(by: self.disposeBag)
        
        self.viewModel.eventIndexToScroll.subscribe(onNext: { [weak self] index in
            self?.timeLineTableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: false)
        }).disposed(by: self.disposeBag)
        
    }
    
    //MARK: - Peek and pop
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = timeLineTableView?.indexPathForRow(at: location) else {
            return nil
        }
        
        self.viewModel.peekedIndexPath.onNext(indexPath)

        if let timelineEventsViewerViewModelToPeek = self.viewModel.timelineEventsViewerViewModelToPeek.value {
            return self.getTimelineEventsViewerViewController(withViewModel: timelineEventsViewerViewModelToPeek)
        } else {
            return nil
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
    //MARK: - Private helpers
    
    private func getTimelineEventsViewerViewController(withViewModel viewModel: TimelineEventsViewerViewModel) -> UIViewController {
        
        let timelineEventsViewerViewController = R.storyboard.deputy().instantiateViewController(withIdentifier: R.storyboard.deputy.timelineEventsViewerViewController.identifier) as! TimelineEventsViewerViewController
        timelineEventsViewerViewController.viewModel = viewModel
        
        return timelineEventsViewerViewController
    }
    
    private func displayTimelineEventsViewer(withViewModel viewModel: TimelineEventsViewerViewModel) {
        let timelineEventsViewerViewController = self.getTimelineEventsViewerViewController(withViewModel: viewModel)
        self.navigationController?.pushViewController(timelineEventsViewerViewController, animated: true)
    }
    
    private func setupInfiniteScroll() {
        
        self.timeLineTableView.rx.didScroll
            .observeOn(MainScheduler.instance)
            .filter { [weak self] _ -> Bool in
                return (self?.isNeedToLoadMoreEvents() ?? false)
            }.subscribe(onNext: { [weak self] _ in
                self?.timeLineTableView.tableFooterView = R.nib.deputyTimelineFooterView.firstView(owner: self)
                self?.viewModel.isReadyToLoadMoreEvents.value = true
            }).disposed(by: self.disposeBag)
        
        self.viewModel.isLoadMoreEventsFinished
            .asObservable()
            .observeOn(MainScheduler.instance)
            .filter { isLoadMoreEventsFinished in
                return isLoadMoreEventsFinished == true
            }.subscribe(onNext: { [weak self] _ in
                self?.timeLineTableView.tableFooterView = nil
            }).disposed(by: self.disposeBag)
        
    }
    
    private func createRefreshControl() -> UIRefreshControl {
        
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor(hex: Constants.Color.blueColorCode)
        refreshControl.tintColor = UIColor(hex: Constants.Color.whiteColorCode)
        
        return refreshControl
    }
    
    private func isNeedToLoadMoreEvents() -> Bool {
        return self.viewModel.areTotalEventsLoaded.value == false
            && (self.timeLineTableView.contentOffset.y + self.timeLineTableView.frame.height) > self.timeLineTableView.contentSize.height + 5
            && self.viewModel.isReadyToLoadMoreEvents.value == false
    }
    
    
}

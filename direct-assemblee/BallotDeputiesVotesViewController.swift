//
//  BallotDeputiesVotesViewController.swift
//  direct-assemblee
//
//  Created by COUDSI Julien on 28/05/2018.
//  Copyright © 2018 Direct Assemblée. All rights reserved.
//
//  Refer to the LICENSE file of the official project for license.

import UIKit
import RxSwift

class BallotDeputiesVotesViewController: BaseViewController, BindableType, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    typealias ViewModelType = BallotDeputiesVotesViewModel
    var viewModel: BallotDeputiesVotesViewModel!
    
    @IBOutlet weak var ballotTitleLabel: UILabel!
    @IBOutlet weak var ballotThemeLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var voteDetailsContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var separatorView: UIView!
    
    private var pageViewController: UIPageViewController!
    private var viewControllers = [UIViewController]()
    private var currentPageViewControllerIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        
        self.separatorView.backgroundColor = UIColor(hex: Constants.Color.blueColorCode)
        self.configurePageViewController()
        self.bindViewModel()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.pageViewController = segue.destination as! UIPageViewController
    }
    
    //MARK: - Binding
    
    func bindViewModel() {
        self.bindState()
        self.bindTitle()
        self.bindSearchBar()
        self.bindVotesTypesCollectionView()
        self.bindVoteTypeSelection()
    }
    
    private func bindState() {
        
        self.viewModel.state.asDriver().drive(onNext: { [unowned self] state in
            
            switch state {
            case .loading:
                self.containerView.addLoadingView(backgroundColor: UIColor(hex: Constants.Color.whiteColorCode))
            case .loaded(let viewModels):
                self.containerView.removeLoadingView()
                self.buildPageViewDatasource(viewModels: viewModels)
            case .error(let error):
                self.containerView.addPlaceholderView(error: error, onRefresh: { [unowned self] in
                    self.viewModel.loadBallotDeputiesVotes()
                })
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    private func bindTitle() {
        self.viewModel.themeText.asDriver().drive(self.ballotThemeLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.titleText.asDriver().drive(self.ballotTitleLabel.rx.text).disposed(by: self.disposeBag)
    }
    
    private func bindSearchBar() {
        
        self.searchBar.rx.text.orEmpty
            .skip(1)
            .distinctUntilChanged()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .asObservable().bind(to: self.viewModel.searchText).disposed(by: self.disposeBag)
        
        self.searchBar.placeholder = self.viewModel.enterNamePlaceholderText
    }
    
    private func bindVotesTypesCollectionView() {
        
        self.viewModel.votesLabels
            .asDriver()
            .drive(self.collectionView.rx.items(cellIdentifier: R.reuseIdentifier.deputyVoteTypeCollectionViewCellIdentifier.identifier, cellType: DeputyVoteTypeCollectionViewCell.self)) { (index, viewModel, cell) in
                cell.viewModel = viewModel
            }.disposed(by: self.disposeBag)
        
        self.viewModel.votesLabels
            .asDriver()
            .filter { $0.count > 0 }
            .drive(onNext: { [unowned self] _ in
                self.pageViewController.setViewControllers([self.viewControllers[self.currentPageViewControllerIndex]], direction: .forward, animated: false, completion: nil)
                self.collectionView.selectItem(at: IndexPath(item: self.currentPageViewControllerIndex, section: 0), animated: false, scrollPosition: .left)
            }).disposed(by: self.disposeBag)
    }
    
    private func bindVoteTypeSelection() {
        
        self.collectionView.rx.itemSelected
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] indexPath in
                let direction: UIPageViewControllerNavigationDirection = indexPath.row > self.currentPageViewControllerIndex ? .forward : .reverse
                self.pageViewController.setViewControllers([self.viewControllers[indexPath.row]], direction: direction, animated: true, completion: nil)
                self.currentPageViewControllerIndex = indexPath.row
            }).disposed(by: self.disposeBag)
    }
    
    // MARK: - Page view controller
    
    private func configurePageViewController() {
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
    }
    
    private func buildPageViewDatasource(viewModels: BallotVotesViewModels) {
        
        let deputiesForViewController = DeputiesListViewController.instanciate(allowsSelection: false)
        deputiesForViewController.viewModel = viewModels.forDeputiesViewModel
        self.setupKeyboard(for: deputiesForViewController)
        
        let deputiesAgainstViewController = DeputiesListViewController.instanciate(allowsSelection: false)
        deputiesAgainstViewController.viewModel = viewModels.againstDeputiesViewModel
        self.setupKeyboard(for: deputiesAgainstViewController)
        
        let deputiesBlankViewController = DeputiesListViewController.instanciate(allowsSelection: false)
        deputiesBlankViewController.viewModel = viewModels.blankDeputiesViewModel
        self.setupKeyboard(for: deputiesBlankViewController)
        
        let deputiesMissingViewController = DeputiesListViewController.instanciate(allowsSelection: false)
        deputiesMissingViewController.viewModel = viewModels.missingDeputiesViewModel
        self.setupKeyboard(for: deputiesMissingViewController)
        
        let deputiesNoVotingViewController = DeputiesListViewController.instanciate(allowsSelection: false)
        deputiesNoVotingViewController.viewModel = viewModels.noVotingDeputiesViewModel
        self.setupKeyboard(for: deputiesNoVotingViewController)
        
        self.viewControllers = [
            deputiesForViewController,
            deputiesAgainstViewController,
            deputiesBlankViewController,
            deputiesMissingViewController,
            deputiesNoVotingViewController
        ]
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.viewControllers.index(of: viewController), index + 1 <= self.viewControllers.count - 1 else {
            return nil
        }
        
        return self.viewControllers[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.viewControllers.index(of: viewController), index - 1 >= 0 else {
            return nil
        }
        return self.viewControllers[index - 1]
    }
    
    //MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let viewController = pageViewController.viewControllers?[0],
            let viewControllerIndex = self.viewControllers.index(of: viewController) else {
                return
        }
        
        self.currentPageViewControllerIndex = viewControllerIndex
        self.collectionView.selectItem(at: IndexPath(item: viewControllerIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        
    }

    //MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let attributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16, weight: .semibold)]
        let size = (self.viewModel.votesLabels.value[indexPath.row].voteTypeLabel.value as NSString).size(withAttributes: attributes)
        return CGSize(width: size.width + 6, height: 40)
    }

    private func setupKeyboard(for deputiesListViewController: DeputiesListViewController) {
        deputiesListViewController.didScroll.subscribe(onNext: { [weak self] _ in
            self?.searchBar.resignFirstResponder()
        }).disposed(by: self.disposeBag)
    }
}

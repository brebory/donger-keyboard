//
//  KeyboardViewController.swift
//  Donger
//
//  Created by Brendon Roberto on 6/23/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import UIKit
import DongerKit
import ReactiveCocoa
import Result
import Cartography

class KeyboardViewController: UIInputViewController {

    typealias DongerCategory = DongerKit.Category

    private struct Constants {
        private struct Identifiers {
            private static let KeyboardCollectionViewCell = "KeyboardCollectionViewCell"
        }
        private struct Nibs {
            private static let KeyboardViewController = "KeyboardViewController"
        }
    }

    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var keyboardPageControl: UIPageControl!
    @IBOutlet var keyboardCollectionView: UICollectionView!
    @IBOutlet var categoriesTabBar: UITabBar!

    lazy var viewModel: KeyboardViewModel = {
        let service = DongerLocalService(filename: "dongers")
        return KeyboardViewModel(service: service)
    }()

    lazy var refreshCollectionView: Action<Void, Void, NoError> = { [unowned self] in
        return Action({ _ in
            self.keyboardCollectionView.reloadData()
            return SignalProducer.empty
        })
    }()

    lazy var updatePageControl: Action<Void, Void, NoError> = { [unowned self] in
        return Action({ _ in
            let pageWidth = CGRectGetWidth(self.keyboardCollectionView.frame)
            self.keyboardPageControl.currentPage = Int(self.keyboardCollectionView.contentOffset.x / pageWidth)
            return SignalProducer.empty
        })
    }()

    override func updateViewConstraints() {
        super.updateViewConstraints()
    
        self.setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindActions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }

    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }

    private func setupUI() {
        let nib = UINib(nibName: Constants.Nibs.KeyboardViewController, bundle: NSBundle(forClass: self.dynamicType.self))
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        self.view = view

        self.setupKeyboardCollectionView()
        self.setupKeyboardPageControl()
        self.setupCategoriesTabBar()
        // self.setupConstraints()
    }

    private func setupKeyboardCollectionView() {
        self.keyboardCollectionView.showsHorizontalScrollIndicator = false
        self.keyboardCollectionView.pagingEnabled = true
        self.keyboardCollectionView.backgroundColor = UIColor.whiteColor()
        self.keyboardCollectionView.delegate = self
        self.keyboardCollectionView.dataSource = self

        // TODO: Use actual dongers collection view cell once it's created, probably with registerNib(forCellWithReuseIdentifier:)
        self.keyboardCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.KeyboardCollectionViewCell)

        // self.view.addSubview(self.keyboardCollectionView)

    }

    private func setupKeyboardPageControl() {
        // self.view.addSubview(self.keyboardPageControl)
    }

    private func setupCategoriesTabBar() {
        // self.view.addSubview(self.categoriesTabBar)
        self.categoriesTabBar.delegate = self
    }

    private func setupConstraints() {

    }

    private func bindActions() {
        self.racx_scrollViewDidEndDeceleratingSignal <~ self.updatePageControl |< UIScheduler()

        self.viewModel.dongers.signal.on(next: { [weak self] _ in self?.keyboardCollectionView.reloadData() })
        self.viewModel.categories.signal.map(self.getTabBarItemsFromCategories).on(next: { [weak self] items in  self?.categoriesTabBar.setItems(items, animated: true)})
        self.viewModel.refreshCategories.apply(nil).start()
    }

    private func getTabBarItemsFromCategories(categories: [DongerCategory]) -> [UITabBarItem] {
        var items = [UITabBarItem]()
        let moreItem = UITabBarItem(tabBarSystemItem: .More, tag: 0)
        items.appendContentsOf(categories.prefix(4).map(self.getTabBarItemFromCategory))
        items.append(moreItem)
        return items
    }

    private func getTabBarItemFromCategory(category: DongerCategory) -> UITabBarItem {
        switch category {
        case .Node(_, let name, _):
            let item = UITabBarItem(title: name, image: nil, selectedImage: nil)
            return item
        case .Root(_, let name):
            let item = UITabBarItem(title: name, image: nil, selectedImage: nil)
            return item

        }
    }
}

// MARK: - UIScrollViewDelegate

extension KeyboardViewController: UIScrollViewDelegate {

}

// MARK: - UICollectionViewDelegate

extension KeyboardViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDelegateFlowLayout

extension KeyboardViewController: UICollectionViewDelegateFlowLayout {

}

// MARK: - UICollectionViewDataSource

extension KeyboardViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.dongers.value.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Identifiers.KeyboardCollectionViewCell,
                                                                         forIndexPath: indexPath)

        self.viewModel.dongers.withValue { [cell] dongers in
            if (indexPath.row < dongers.count) {
                let label = UILabel(frame: cell.frame)
                label.text = dongers[indexPath.row].text
                cell.addSubview(label)
            }
        }

        return cell
    }
}

// MARK: - UITabBarDelegate

extension KeyboardViewController: UITabBarDelegate {

}

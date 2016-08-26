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

    private struct Constants {
        private struct Identifiers {
            private static let KeyboardCollectionViewCell = "KeyboardCollectionViewCell"
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
        self.setupKeyboardCollectionView()
        self.setupKeyboardPageControl()
        self.setupCategoriesTabBar()
        self.setupConstraints()
    }

    private func setupKeyboardCollectionView() {
        self.keyboardCollectionView.showsHorizontalScrollIndicator = false
        self.keyboardCollectionView.pagingEnabled = true
        self.keyboardCollectionView.delegate = self
        self.keyboardCollectionView.dataSource = self

        // TODO: Use actual dongers collection view cell once it's created, probably with registerNib(forCellWithReuseIdentifier:)
        self.keyboardCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: Constants.Identifiers.KeyboardCollectionViewCell)

        self.view.addSubview(self.keyboardCollectionView)

    }

    private func setupKeyboardPageControl() {
        self.view.addSubview(self.keyboardPageControl)
    }

    private func setupCategoriesTabBar() {
        self.view.addSubview(self.categoriesTabBar)
    }

    private func setupConstraints() {

    }

    private func bindActions() {
        self.racx_scrollViewDidEndDeceleratingSignal <~ self.updatePageControl |< UIScheduler()
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

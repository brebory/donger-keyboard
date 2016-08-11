//
//  TestViewController.swift
//  DongerKeyboard
//
//  Created by Brendon Roberto on 7/27/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import UIKit
import ReactiveCocoa
import DongerKit
import Cartography

class TestViewController: UIViewController {

    private struct Constants {
        private struct Identifiers {
            static let DongersCell = "DongersCell"
        }

        private struct Nibs {
            static let TestCollectionViewCell = "TestCollectionViewCell"
        }
    }


    @IBOutlet weak var collectionView: UICollectionView!

    var viewModel: TestViewModel = {
        let service = DongerLocalService(filename: "dongers")
        return TestViewModel(service: service)
    }()

    var disposables: [Disposable] = []

    // MARK: Initialization

    deinit {
        disposables.forEach { disposable in
            if !disposable.disposed {
                disposable.dispose()
            }
        }
    }

    // MARK: UIView Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        setupConstraints()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.refresh.apply(nil).start()
        self.viewModel.refresh.errors.on(next: { [weak self] error in
            guard let strongSelf = self
                else { return }
            // TODO: Localization
            strongSelf.alertError(error, withTitle: "Error")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Layout Helpers

    func setupConstraints() {

        // Set up the collectionView with equal constraints to the superview margins.
        constrain(collectionView, view) { collectionView, superview in

            collectionView.top == superview.topMargin + 8
            collectionView.bottom == superview.bottomMargin - 8
            collectionView.left == superview.leftMargin
            collectionView.right == superview.rightMargin
        }
    }

    func setupCollectionView() {
        self.collectionView.registerNib(UINib(nibName: Constants.Nibs.TestCollectionViewCell, bundle: NSBundle.mainBundle()),
                                        forCellWithReuseIdentifier: Constants.Identifiers.DongersCell)
        let refreshControl = UIRefreshControl()
        let disposable = refreshControl.addAction(viewModel.refresh, forControlEvents: .ValueChanged)
        disposables.append(disposable)

        self.collectionView.addSubview(refreshControl)

        self.collectionView.alwaysBounceVertical = true
    }

}

extension TestViewController: UICollectionViewDelegate {

}

extension TestViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dongers.value.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Identifiers.DongersCell, forIndexPath: indexPath)

        guard let testCell = cell as? TestCollectionViewCell
            else { return cell }

        if (indexPath.row < viewModel.dongers.value.count) {
            testCell.textLabel.text = viewModel.dongers.value[indexPath.row].text
        }

        return cell
    }
}

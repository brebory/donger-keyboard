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
import Result

class TestViewController: UIViewController {

    private struct Constants {
        static let DongersCellPadding: CGFloat = 10

        private struct Identifiers {
            static let DongersCell = "DongersCell"
        }

        private struct Nibs {
            static let TestCollectionViewCell = "TestCollectionViewCell"
        }

        private struct Errors {

            // TODO: Add to localization file
            static let AlertTitle = "STR_TESTVIEWCONTROLLER_ERROR_ALERT_TITLE"

            private struct Messages {
                // TODO: Add to localization file
                static let CollectionViewBounds = "STR_DATAINTEGRITYERROR_TESTVIEWCONTROLLER_COLLECTION_VIEW_BOUNDS"
            }

            private struct Codes {
                static let CollectionViewBounds = 120001
            }
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
        self.viewModel.dongers.signal.on(next: { [weak self] _ in self?.collectionView.reloadData() })
        self.viewModel.refresh.apply(nil).start()
        self.viewModel.refresh.errors.on(next: { [weak self] error in
            guard let strongSelf = self
                else { return }
            strongSelf.alertError(error, withTitle: Constants.Errors.AlertTitle)
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

extension TestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        //let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Identifiers.DongersCell, forIndexPath: indexPath)

        //guard let testCell = cell as? TestCollectionViewCell
        //    else { return cell.frame.size }


        let result = viewModel.dongers.withValue { dongers -> Result<CGSize, ApplicationError> in
            if (indexPath.row < dongers.count) {
                let fontSize = (dongers[indexPath.row].text as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(17)])
                return .Success(fontSize)
            } else {
                let message = NSLocalizedString(Constants.Errors.Messages.CollectionViewBounds,
                                                bundle: NSBundle(forClass: TestViewController.self),
                                                comment: "IndexPath (%d,%d) out of bounds for UICollectionView %@")
                return .Failure(.DataIntegrityError(message: String(format: message, indexPath.section, indexPath.row, collectionView),
                                                    code: Constants.Errors.Codes.CollectionViewBounds))
            }
        }

        switch result {
        case .Success(let size):
            return CGSizeMake(size.width + Constants.DongersCellPadding,
                              size.height + Constants.DongersCellPadding)
        case .Failure(_):
            // TODO: Log error.
            return CGSizeMake(0, 0)
        }
    }
}

extension TestViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dongers.value.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Identifiers.DongersCell, forIndexPath: indexPath)

        guard let testCell = cell as? TestCollectionViewCell
            else { return cell }

        viewModel.dongers.withValue { dongers in
            if (indexPath.row < dongers.count) {
                testCell.textLabel.text = dongers[indexPath.row].text
            }
        }


        return cell
    }
}

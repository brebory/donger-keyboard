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

class TestViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var dongers = MutableProperty<[Donger]>([])

    override func viewDidLoad() {
        super.viewDidLoad()

        dongers <~ DongerLocalService.getDongers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestViewController: UICollectionViewDelegate {

}

extension TestViewController: UICollectionViewDataSource {

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dongers.value.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

    }
}

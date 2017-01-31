//
//  ViewController.swift
//  AgilePoker
//
//  Created by Petros Mitakos on 15/07/16.
//  Copyright © 2016 Petros Mitakos. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let reuseIdentifier = "cell" // also enter this string as the cell identifier in the storyboard
    var items: [String] = ["0", "1/2", "1", "2",
                           "3", "5", "8", "13",
                           "21", "34", "50", "80",
                           "130", "210", "500", "800"]
    var itemColors: [Int] = [0x3F8CCB, 0x8CC54B, 0x77B333, 0x5E971E,
                             0xCDE340, 0xBFD533, 0xBBD70B, 0xC8E40B,
                             0xD78240, 0xCE7026, 0xD57122, 0xEA7316,
                             0xD7735B, 0xD76448, 0xD55435, 0xC62D08]
    var frequencyStats: [Int] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    var selectedIndex: Int = 0

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? CardViewController {
            destinationViewController.transitioningDelegate = self
            destinationViewController.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            destinationViewController.itemIndex = selectedIndex
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
    }

    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardsCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.cardLabel.text = self.items[(indexPath as NSIndexPath).item]
        cell.cardLabel.textColor = UIColor.white
        cell.cardLabel.layer.shadowColor = UIColor.black.cgColor
        cell.cardLabel.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        cell.cardLabel.layer.shadowRadius = 0.0
        cell.cardLabel.layer.shadowOpacity = 0.35;
        cell.cardLabel.layer.shouldRasterize = true
        cell.cardLabel.layer.masksToBounds = false
        cell.backgroundColor = UIColor(netHex: self.itemColors[(indexPath as NSIndexPath).item])

        // border
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.4

        // corner radius
        cell.layer.cornerRadius = 0

        // shadow
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.7
        cell.layer.shadowRadius = 4.0

        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = (indexPath as NSIndexPath).row
        frequencyStats[(indexPath as NSIndexPath).row] = frequencyStats[(indexPath as NSIndexPath).row] + 1
        performSegue(withIdentifier: "showCard", sender: self)
    }
    
    // change background color when user touches cell
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.zPosition = 2;
        cell?.layer.shadowOffset = CGSize(width: 1, height: 2)
        cell?.layer.shadowColor = UIColor.black.cgColor
        cell?.layer.shadowRadius = 26
        cell?.layer.shadowOpacity = 0.3
        cell?.layer.masksToBounds = true
        cell?.clipsToBounds = false
        cell?.layer.shouldRasterize = true
        cell?.layer.rasterizationScale = UIScreen.main.scale
    }
    
    // change background color back when user releases touch
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.shadowOpacity = 0.0
        cell?.layer.zPosition = 1;
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width / 4.0, height: (collectionView.bounds.size.height / 4.0))
    }

    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            selectedIndex = getMostUsedCardIndex()
            performSegue(withIdentifier: "showCard", sender: self)
        }
    }

    func getMostUsedCardIndex() -> Int {
        var maxFrequency: Int = frequencyStats[0]
        var maxFrequencyIndex: Int = 0
        for (index, frequency) in frequencyStats.enumerated() {
            if (frequency > maxFrequency) {
                maxFrequency = frequency
                maxFrequencyIndex = index
            }
        }
        return maxFrequencyIndex
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
}

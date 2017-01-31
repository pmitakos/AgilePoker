//
//  CardViewController.swift
//  AgilePoker
//
//  Created by Petros Mitakos on 15/07/16.
//  Copyright © 2016 Petros Mitakos. All rights reserved.
//

import UIKit

class CardViewController: UIViewController {
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var cardButton: UIButton!

    var cardNumber: String = ""
    var items: [String] = ["0", "1/2", "1", "2",
                           "3", "5", "8", "13",
                           "21", "34", "50", "80",
                           "130", "210", "500", "800"]
    var itemColors: [Int] = [0x3F8CCB, 0x8CC54B, 0x77B333, 0x5E971E,
                             0xCDE340, 0xBFD533, 0xBBD70B, 0xC8E40B,
                             0xD78240, 0xCE7026, 0xD57122, 0xEA7316,
                             0xD7735B, 0xD76448, 0xD55435, 0xC62D08]
    var itemIndex: Int = 0
    var pushFromLeft: Bool = true

    override func viewDidLoad() {
        self.cardLabel.textColor = UIColor.white

        self.cardLabel.layer.shadowColor = UIColor.black.cgColor
        self.cardLabel.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        self.cardLabel.layer.shadowRadius = 0.0
        self.cardLabel.layer.shadowOpacity = 0.35;
        self.cardLabel.layer.shouldRasterize = true
        self.cardLabel.layer.masksToBounds = false

        setupView()

        // Gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(CardViewController.respondToSwipeGesture(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        cardButton.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(CardViewController.respondToSwipeGesture(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        cardButton.addGestureRecognizer(swipeLeft)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(CardViewController.respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        cardButton.addGestureRecognizer(swipeDown)
    }

    func setupView() {
        UIView.beginAnimations("swapCardNumber", context: nil)
        UIView.setAnimationCurve(UIViewAnimationCurve.easeIn)
        UIView.setAnimationDuration(0.7)
        self.cardLabel.alpha = 0
        self.cardLabel.text = self.items[self.itemIndex]
        self.cardButton.backgroundColor = UIColor(netHex: self.itemColors[self.itemIndex])
        self.cardLabel.alpha = 1
        UIView.commitAnimations()
    }

    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {

        if let swipeGesture = gesture as? UISwipeGestureRecognizer {

            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                pushFromLeft = false
                itemIndex = itemIndex - 1
                let isIndexValid = items.indices.contains(itemIndex)
                if !isIndexValid {
                    itemIndex = items.endIndex - 1
                }
                setupView()
                break
            case UISwipeGestureRecognizerDirection.down:
                self.dismiss(animated: true, completion: nil)
                break
            case UISwipeGestureRecognizerDirection.left:
                pushFromLeft = true
                itemIndex = itemIndex + 1
                let isIndexValid = items.indices.contains(itemIndex)
                if !isIndexValid {
                    itemIndex = items.startIndex
                }
                setupView()
                break
            default:
                break
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
}

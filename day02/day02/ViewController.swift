//
//  ViewController.swift
//  day02
//
//  Created by Antoine FEUERSTEIN on 2/28/19.
//  Copyright © 2019 Antoine FEUERSTEIN. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var viewOne: UIView!
    @IBOutlet var viewTwo: UIView!
    @IBOutlet var viewThree: UIView!
    var layers: [CAGradientLayer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView.delegate = self
        self.viewOne.layer.addSublayer(createGradient())
        self.viewTwo.layer.addSublayer(createGradient())
        self.viewThree.layer.addSublayer(createGradient())
    }

    func createGradient() -> CAGradientLayer {
        let gradient = CAGradientLayer.init()
        
        gradient.startPoint = .init(x: 0.5, y: 0)
        gradient.endPoint = .init(x: 0.5, y: 1)
        gradient.colors = [randomColor(), randomColor()]
        gradient.frame = self.view.bounds
        self.layers.append(gradient)
        return gradient
    }
    func randomColor() -> CGColor {
        return UIColor.init(red: .random, green: .random, blue: .random, alpha: 1).cgColor
    }
    
    func changeLayerColor() {
        for gradient in self.layers {
            let animation = CABasicAnimation.init(keyPath: #keyPath(CAGradientLayer.colors))
            let newColors = [randomColor(), randomColor()]
            
            animation.fromValue = gradient.colors
            animation.toValue = newColors
            animation.duration = 1
            gradient.colors = newColors
            gradient.add(animation, forKey: #keyPath(CAGradientLayer.colors))
        }
    }
    func reverseLayerColor() {
        for gradient in self.layers {
            let animation = CABasicAnimation.init(keyPath: #keyPath(CAGradientLayer.colors))
            let newColors = [gradient.colors![1], gradient.colors![0]]
            
            animation.fromValue = gradient.colors
            animation.toValue = newColors
            animation.duration = 1
            gradient.colors = newColors
            gradient.add(animation, forKey: #keyPath(CAGradientLayer.colors))
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minX = self.view.bounds.width / 5
        let maxX = self.view.bounds.width * 2.2
        
        if scrollView.contentOffset.x < -minX {
            self.scrollView.isScrollEnabled = false
            self.changeLayerColor()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.scrollView.isScrollEnabled = true
            })
        }
        else if scrollView.contentOffset.x > maxX {
            self.scrollView.isScrollEnabled = false
            self.reverseLayerColor()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.scrollView.isScrollEnabled = true
            })
        }
    }
    
}

extension CGFloat {
    
    static var random: CGFloat {
        return CGFloat(drand48())
    }
    
}

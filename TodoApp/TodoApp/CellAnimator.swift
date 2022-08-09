//
//  CellAnimator.swift
//  TodoApp
//
//  Created by murphy on 8/9/22.
//

import UIKit

class CellAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
//    let presentationCellFrame: CGRect = .zero
//    let rectOfCellInSuperview: CGRect
//    init(presentationCellFrame: CGRect) {
//        self.rectOfCellInSuperview = presentationCellFrame
//    }
    let textFrame: UITextView
    init(textView: UITextView) {
        self.textFrame = textView
    }
    //let presentationCell: MainTableViewCell
//    init(presentationCell: MainTableViewCell) {
//        self.presentationCell = presentationCell
//    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let presentedViewController = transitionContext.viewController(forKey: .to),
        let presentedView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let finalFrame = transitionContext.finalFrame(for: presentedViewController)
        
        let cellFrame = textFrame.convert(textFrame.bounds, to: containerView) //presentationCell.convert(presentationCell.bounds, to: containerView)
        let cellCenter = CGPoint(x: cellFrame.midX, y: cellFrame.minY)
        print(cellCenter)
        containerView.addSubview(presentedView)
        presentedView.center = cellCenter
        presentedView.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            //presentedView.transform = CGAffineTransform(scaleX: 1, y: 1)
            presentedView.frame = finalFrame
        } completion: { isFinished in
            transitionContext.completeTransition(isFinished)
        }
        
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.5
    }
}

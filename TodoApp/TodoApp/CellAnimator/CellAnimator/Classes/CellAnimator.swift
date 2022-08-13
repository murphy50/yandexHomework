//
//  File.swift
//  CellAnimator-Resources
//
//  Created by murphy on 8/13/22.
//

import Foundation

public class CellAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let table: UITableView
    let indexPath: IndexPath
    public init(table: UITableView, indexPath: IndexPath) {
        self.table = table
        self.indexPath = indexPath
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let presentedViewController = transitionContext.viewController(forKey: .to),
        let presentedView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(false)
            return
        }
        
        let finalFrame = transitionContext.finalFrame(for: presentedViewController)
        let rectOfCell = table.rectForRow(at: indexPath)
        let cellFrame = table.convert(rectOfCell, to: containerView)
        let cellCenter = CGPoint(x: cellFrame.midX, y: cellFrame.minY)
        containerView.addSubview(presentedView)
        presentedView.center = cellCenter
        presentedView.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext)) {
            presentedView.transform = CGAffineTransform(scaleX: 1, y: 1)
            presentedView.frame = finalFrame
        } completion: { isFinished in
            transitionContext.completeTransition(isFinished)
        }
        
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.25
    }
}

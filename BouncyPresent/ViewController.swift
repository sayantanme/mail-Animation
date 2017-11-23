//
// Copyright 2014 Scott Logic
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit

class ViewController: UIViewController,UIViewControllerTransitioningDelegate,OverlayDismissDelegate,UINavigationControllerDelegate {
    
    let overlayTransitioningDelegate = OverlayTransitioningDelegate()
    let interactor = Interactor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.showNavBottomBar(notification:)), name: Notification.Name("showNavBottomBar"), object: nil)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "bouncySegue" {
            let overlayVC = segue.destination as! OverlayViewController
            overlayVC.del = self
            prepareOverlayVC(overlayVC)
        }
    }
    
    func transformPresentingVC(translationPoint: CGPoint?,mov: CGFloat) {
        let scaleY = 0.92+mov
        let scaleForView = 0.98+mov
        print("mov:\(mov)")
        
        UIView.animate(withDuration: 0) {
            self.view.transform =  CGAffineTransform.identity.scaledBy(x: scaleForView, y: scaleForView)
            self.navigationController?.view.transform = CGAffineTransform.identity.scaledBy(x: scaleY, y: scaleY)

        }
    }
    
    func backGroundVcAnimation(translationPoint: CGPoint?, mov: CGFloat ,durationMoveMent:CGFloat) {
        UIView.animate(withDuration: TimeInterval(durationMoveMent), delay: 0.0, options: [.allowUserInteraction], animations: {
            self.view.transform =  CGAffineTransform.identity.scaledBy(x: 0.98, y: 0.98)
            self.navigationController?.view.transform = CGAffineTransform.identity.scaledBy(x: 0.92, y: 0.92)
        }, completion: { (_) in

        })
    }
    
    
    @IBAction func handleBouncyPresentPressed(_ sender: AnyObject) {
        let overlayVC = storyboard?.instantiateViewController(withIdentifier: "overlayViewController")
        //let overlayVC = storyboard?.instantiateViewController(withIdentifier: "pgController") as! UIPageViewController
        prepareOverlayVC(overlayVC!)
        present(overlayVC!, animated: true, completion: nil)
    }
    
    fileprivate func prepareOverlayVC(_ overlayVC: UIViewController) {
        overlayVC.transitioningDelegate = self
        overlayVC.modalPresentationStyle = .custom
        if let overlay = overlayVC as? OverlayViewController{
            overlay.interactor = interactor
            overlay.del = self
        }
    }
    
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        
        return OverlayPresentationController(presentedViewController: presented,
                                             presenting: presenting)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController)-> UIViewControllerAnimatedTransitioning? {
        let animator = BouncyViewControllerAnimator()
        animator.isPresenting = true
        
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = BouncyViewControllerAnimator()
        animator.isPresenting = false
        
        return animator
        //return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    
    @IBAction func showBouncy(_ sender: UIBarButtonItem) {
        handleBouncyPresentPressed(sender)
    }
    
    
    func navigationController(_ navigationController: UINavigationController,animationControllerFor operation:UINavigationControllerOperation,from fromVC: UIViewController,to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        let animator = BouncyViewControllerAnimator()
        animator.isPresenting = false
        
        return animator
    }
    
    
    @objc func showNavBottomBar(notification: Notification){
        self.navigationController?.isToolbarHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("showNavBottomBar"), object: nil)
    }
}


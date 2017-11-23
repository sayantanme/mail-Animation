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


import Foundation
import UIKit

protocol OverlayDismissDelegate: class {
    func transformPresentingVC(translationPoint: CGPoint? ,mov: CGFloat)
    func backGroundVcAnimation(translationPoint: CGPoint? ,mov: CGFloat ,durationMoveMent : CGFloat)
}

class OverlayViewController: UIViewController {
    
    let fullView: CGFloat = 40
    var partialView: CGFloat {
        return UIScreen.main.bounds.height
            //- (UIApplication.shared.statusBarFrame.height)
        //    return UIScreen.main.bounds.height - (left.frame.maxY + UIApplication.shared.statusBarFrame.height)
    }
    var del:OverlayDismissDelegate?
    
    var interactor:Interactor? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func handleDismissedPressed(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func panEvent(_ sender: UIPanGestureRecognizer) {
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: self.view)
        let verticalMovement = translation.y / view.bounds.height
        
        
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        print(progress)
        
        
        let velocity = sender.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            print("y:\(y+translation.y)")
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
        _ = (y+translation.y / ( view.frame.height/2))
        
        
        var cal1 : CGFloat
        cal1 = self.view.frame.height/2
        
        if(y+translation.y>=cal1){
            cal1 = 100.00
        }else{
            cal1 = (100*y+translation.y)/cal1
        }
        
        var deltaPart : CGFloat
        
        deltaPart = (0.08*cal1)/100
        
        
        
        print("cal1 \(cal1) deltaPart \(deltaPart)")
        
        if (del != nil) {
            del?.transformPresentingVC(translationPoint: translation, mov: deltaPart)
        }
        if sender.state == .ended {
            
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            if (del != nil) {
                del?.backGroundVcAnimation(translationPoint: translation, mov: deltaPart ,durationMoveMent: CGFloat(duration))
            }
            
            if(y>=self.view.frame.height-49){
                NotificationCenter.default.post(name: Notification.Name("showNavBottomBar"), object: nil)
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                print("prog:\(progress),thresh:\(percentThreshold)")
                if  translation.y >= 100 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)

                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
            }, completion: { (_) in
                if progress>percentThreshold{
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "presentDetail", sender: nil)
    }
    
    func dragg(sender: UIPanGestureRecognizer){
        let percentThreshold:CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: self.view)
        let verticalMovement = translation.y / view.bounds.height
        
        
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        print(progress)
        
        
        let velocity = sender.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            print("y:\(y+translation.y)")
            sender.setTranslation(CGPoint.zero, in: self.view)
        }
        _ = (y+translation.y / ( view.frame.height/2))
        
        
        var cal1 : CGFloat
        cal1 = self.view.frame.height/2
        
        if(y+translation.y>=cal1){
            cal1 = 100.00
        }else{
            cal1 = (100*y+translation.y)/cal1
        }
        
        var deltaPart : CGFloat
        
        deltaPart = (0.08*cal1)/100
        
        
        
        print("cal1 \(cal1) deltaPart \(deltaPart)")
        
        if (del != nil) {
            del?.transformPresentingVC(translationPoint: translation, mov: deltaPart)
        }
        if sender.state == .ended {
            
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            if (del != nil) {
                del?.backGroundVcAnimation(translationPoint: translation, mov: deltaPart ,durationMoveMent: CGFloat(duration))
            }
            
            if(y>=self.view.frame.height-49){
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                print("prog:\(progress),thresh:\(percentThreshold)")
                if  translation.y >= 100 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
            }, completion: { (_) in
                if progress>percentThreshold{
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }

    }
}

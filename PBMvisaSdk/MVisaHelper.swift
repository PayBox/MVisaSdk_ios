

import Foundation
import UIKit
import PayBoxSdk

open class MVisahelper: PBDelegate, QrDetector {
    
    
    
    open var delegate: PBMVisaDelegate?
    var userid: String!
    var mVisa: MVisa?
    var pbHelper: PBHelper?
    var cardList: [Card]?
    static var mVHelper: MVisahelper?
    public static var instance: MVisahelper {
        if mVHelper == nil {
            mVHelper = MVisahelper()
        }
        return mVHelper!
    }
    
    open func initScanner(userId: String!) {
        self.userid = userId
        self.pbHelper = PBHelper.sdk
        
        let cameraVC = CameraViewController()
        cameraVC.detector = self
        if let top = UIApplication.shared.topMostViewController() {
            top.present(cameraVC, animated: true, completion: nil)
        }
        
    }
    
    open func initPayment(orderId: String, cardId: String?, description: String, extraParams: [String:String]?){
        self.pbHelper?.pbDelegate(delegate: self)
        self.pbHelper?.enableRecurring(lifetime: 36)
        if mVisa != nil {
            if let recurring = getRecurringProfile(cardId: cardId){
                self.pbHelper?.makeRecurring(amount: mVisa!.amount, recurringProfile: recurring, description: description, extraParams: extraParams)
            } else {
                self.pbHelper?.initPayment(orderId: orderId, userId: userid, amount: (mVisa?.amount)!, description: description, extraParams: extraParams)
            }
            
        }
        
    }
    public func detected(mVisa: MVisa) {
        self.mVisa = mVisa
        loadCards()
    }
    private func loadCards() {
        if self.pbHelper != nil {
            self.pbHelper!.pbDelegate(delegate: self)
            self.pbHelper!.getCards(userId: self.userid)
        }
    }
    
    
    public func onCardListed(cards: [Int : Card]) {
        if !cards.isEmpty {
            cardList = [Card]()
            cards.forEach{
                if $0.1.recurringProfile.count>1 {
                    cardList!.append($0.1)
                }
            }
            if cardList!.isEmpty {
                cardList = nil
            }
        } else {
            cardList = nil
        }
        
        delegate?.onQrDetected(mVisa: self.mVisa, cards: cardList)
        self.pbHelper?.pbDelegate(delegate: nil)
    }
    
    public func onPaymentPaid(response: Response) {
        delegate?.onQrPayment(response: response)
        pbHelper?.pbDelegate(delegate: nil)
    }
    
    public func onRecurringPaid(recurringResponse: Recurring) {
        delegate?.onQrPayment(response: Response(
            status: recurringResponse.status,
            paymentId: recurringResponse.paymentId,
            redirectUri: nil))
        pbHelper?.pbDelegate(delegate: nil)
    }
    
    public func onError(error: ErrorResponse) {
        cardList = nil
        delegate?.onQrError(error: error)
        pbHelper?.pbDelegate(delegate: nil)
    }
    private func getRecurringProfile(cardId: String?) -> String?{
        if cardId != nil{
            if !(cardList?.isEmpty)!{
                for card in cardList! {
                    if card.cardId.elementsEqual(cardId!)  {
                        return card.recurringProfile
                    }
                }
            }
        }
        return nil
    }
    
    public func onPaymentRevoked(response: Response) {}
    public func onPaymentStatus(status: PStatus) {}
    public func onCardAdded(response: Response) {}
    public func onCardRemoved(card: Card) {}
    public func onCardPayInited(response: Response) {}
    public func onCardPaid(response: Response) {}
    public func onPaymentCaptured(capture: Capture) {}
    public func onPaymentCanceled(response: Response) {}
    
}

public protocol QrDetector {
    func detected(mVisa: MVisa)
}

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        if let navigation = self.presentedViewController as? UINavigationController {
            return navigation.visibleViewController!.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

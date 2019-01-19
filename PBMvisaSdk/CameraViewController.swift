
import Foundation
import UIKit

class CameraViewController : QRCodeScannerViewController {
    

    open var detector: QrDetector?
    override func processQRCodeContent(qrCodeContent: String) -> Bool {
        
        if let decoded = MParser.decode(code: qrCodeContent){
            if  let mAmount = decoded[MParser.MVISA_AMOUNT_TAG],
                let mMerchantId = decoded[MParser.MVISA_MERCHANT_ID_TAG],
                let mCurrencyCode = decoded[MParser.MVISA_CURRENCY_CODE_TAG],
                let mMerchantName = decoded[MParser.MVISA_MERCHANT_NAME_TAG] {
                textError.isHidden = true
                
                detector?.detected(mVisa: MVisa(currencyCode: MParser.currencyBy(code: mCurrencyCode)!,
                                                mVisaMerchantId: mMerchantId,
                                                merchantName: mMerchantName,
                                                amount: Float(mAmount)!))
                dismiss(animated: true, completion: nil)
                return true
            } else {
                textError.isHidden = false
            }
            
        }
        
        return false
    }
    
    
    override func didFailWithError(error: NSError) {
        let alert = UIAlertController(title: error.localizedDescription,
                                      message: error.localizedFailureReason, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            _ in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initToolbar()
    }

    override var prefersStatusBarHidden: Bool{
        return true
    }

    private func initToolbar(){
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        toolbar.sizeToFit()
        toolbar.backgroundColor = UIColor.blue
        let cancel = UIBarButtonItem.init(title: "Назад", style: UIBarButtonItemStyle.plain, target: self, action: #selector(exit))
        toolbar.setItems([cancel], animated: true)
        self.view.addSubview(toolbar)
    }
    
    @objc private func exit(){
        self.dismiss(animated: true, completion: nil)
    }
    
}

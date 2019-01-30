//
//  CompleteRouteViewController.swift
//  ParseStarterProject
//
//  Created by 安井 梨沙子 on 2016/01/28.
//  Copyright © 2016年 Parse. All rights reserved.
//

import UIKit
import Parse

class CompleteRouteViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    
    
    @IBOutlet weak var importedImage: UIImageView!
    
    @IBOutlet weak var titleField: UITextField!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func importImage(sender: AnyObject) {
    //画像よみこみ
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    //イメージピッカーを閉じる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        print("Image selected.")
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        importedImage.image = image
    }
    
    
    @IBAction func finishButton(sender: AnyObject) {
        

            
            myTitle.append(self.titleField.text!)

            
            
            self.activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
            self.activityIndicator.backgroundColor = UIColor(white:1.0, alpha:0.5)
            self.activityIndicator.center = self.view.center
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            self.view.addSubview(self.activityIndicator)
            self.activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            
            
            //Parseに登録
            let post = PFObject(className: "Post")
            post["title"] = self.titleField.text!

            post["userId"] = PFUser.currentUser()?.objectId!
        
            post["detail"] = "ルートが登録されました！"

            post["number"] = routeNumber
            
            let imageData = UIImagePNGRepresentation(self.importedImage.image!)
            let imageFile = PFFile(name: "image.png", data: imageData!)
            post["imageFile"] = imageFile
            
            
            post.saveInBackgroundWithBlock{(success, error) -> Void in
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                

                
                print(myTitle.last, myDetail.last, myLatitude.last, myLongitude.last)
                
                self.titleField.text = ""

                
                
                
                
                //self.performSegueWithIdentifier("NewTitleDetail", sender: self) //追加したページに飛ぶ
                
                
                
                if error == nil {
                    
                    print("Success")
                    
                   
                }
            }
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {  //どこかタッチでテキストフィールドを閉じる
        self.view.endEditing(true)
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {       //リターンボタンでテキストフィールドを閉じる
        textField.resignFirstResponder()
        return true
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

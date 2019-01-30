//
//  SubViewController.swift
//  MapDemo
//
//  Created by 安井 梨沙子 on 2016/01/22.
//  Copyright (c) 2016年 安井 梨沙子. All rights reserved.
//

import UIKit
import MapKit


class SubViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    @IBOutlet weak var map2: MKMapView!

    @IBOutlet weak var titleField: UITextField!
    
    @IBOutlet weak var detailField: UITextView!
    
    @IBOutlet weak var importedImage: UIImageView!
    
    
    var nowLatitude = 0.0
    var nowLongitude = 0.0

    
    
    var locationManager = CLLocationManager()
    


    
    @IBAction func AddAlert(sender: AnyObject) {    //アラート表示
 


        
        let alert:UIAlertController = UIAlertController(title:"あしあと追加",message: "マップにあしあとを残しますか？",preferredStyle: UIAlertControllerStyle.Alert)
        presentViewController(alert, animated: true, completion: nil)
        
        let defaultAction:UIAlertAction = UIAlertAction(title: "はい",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in      //「はい」が押された時の処理
                
                myTitle.append(self.titleField.text!)
                myDetail.append(self.detailField.text!)
                self.titleField.text = ""
                self.detailField.text = ""
                
                NSUserDefaults.standardUserDefaults().setObject(myTitle, forKey: "myTitle")  //ボタン押下でNSUserDefaultも更新される。
                NSUserDefaults.standardUserDefaults().setObject(myDetail, forKey: "myDetail")  //ボタン押下でNSUserDefaultも更新される。
                
                //現在地の緯度・経度をmyLatitudeとmyLongitudeに格納
                myLatitude.append(Double(self.nowLatitude))
                myLongitude.append(Double(self.nowLongitude))
                
                NSUserDefaults.standardUserDefaults().setObject(myLatitude, forKey: "myLatitude")  //ボタン押下でNSUserDefaultも更新される。
                NSUserDefaults.standardUserDefaults().setObject(myLongitude, forKey: "myLongitude")  //ボタン押下でNSUserDefaultも更新される。
                
                print(myTitle.last, myDetail.last, myLatitude.last, myLongitude.last)
                
                self.performSegueWithIdentifier("NewTitleDetail", sender: self)     //追加しましたページに飛ぶ

                
        })
        
        let destructiveAction:UIAlertAction = UIAlertAction(title: "いいえ",
            style: UIAlertActionStyle.Destructive,
            handler:{
                (action:UIAlertAction) -> Void in
            
                
        })
        
        
        alert.addAction(defaultAction)
        alert.addAction(destructiveAction)
        
        self.navigationController?.pushViewController(alert, animated: true)
        
        
        
        
    }
    
    

    @IBAction func modoruButtonPushed(sender: AnyObject) {
        
        let alert:UIAlertController = UIAlertController(title:"あしあと削除",message: "あしあとを削除して、マップ画面にもどりますか？",preferredStyle: UIAlertControllerStyle.Alert)
        presentViewController(alert, animated: true, completion: nil)
        
        let defaultAction:UIAlertAction = UIAlertAction(title: "はい",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction) -> Void in      //「はい」が押された時の処理
                
                self.performSegueWithIdentifier("MapPage", sender: self)     //追加しましたページに飛ぶ

        })
        
        let destructiveAction:UIAlertAction = UIAlertAction(title: "いいえ",
            style: UIAlertActionStyle.Destructive,
            handler:{
                (action:UIAlertAction) -> Void in
                
                
        })
        
        
        alert.addAction(defaultAction)
        alert.addAction(destructiveAction)
        
        self.navigationController?.pushViewController(alert, animated: true)

    }
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {       //アプリ起動時
        super.viewDidLoad()
        
        //textField
        self.titleField.delegate = self
        
        //ユーザの位置情報を取得
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //textViewにボーダーを追加
        detailField.layer.borderWidth = 1;
        detailField.layer.borderColor = UIColor.blackColor().CGColor
        
        //placeHolder初期値
        detailField.text = "説明"
        detailField.delegate = self
        detailField.textColor = UIColor.lightGrayColor()
        
        //タイトルと説明を宣言
        self.titleField.delegate = self
        self.detailField.delegate = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {  //どこかタッチでテキストフィールドを閉じる
        self.view.endEditing(true)

    }
    

    func textFieldShouldReturn(textField: UITextField!) -> Bool {       //リターンボタンでテキストフィールドを閉じる
        textField.resignFirstResponder()
        return true
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {      //ユーザの位置情報を描画
        
        let userLocation: CLLocation = locations[0] 

        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        nowLatitude = latitude
        
        nowLongitude = longitude
        
        //self.map2.setRegion(region, animated: true)
        
    }
    
    
    //textviewがフォーカスされたら、Labelを非表示
    func textViewDidBeginEditing(detailField: UITextView) {
        if detailField.textColor == UIColor.lightGrayColor() {
            detailField.text = nil
            detailField.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(detailField: UITextView) {
        if detailField.text.isEmpty {
            detailField.text = "説明"
            detailField.textColor = UIColor.lightGrayColor()
        }
    }
    
    
    //画像よみこみ
    @IBAction func importImage(sender: AnyObject) {
        
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
    

}

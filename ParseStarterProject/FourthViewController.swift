//
//  FourthViewController.swift
//  MapDemo
//
//  Created by 安井 梨沙子 on 2016/01/24.
//  Copyright © 2016年 安井 梨沙子. All rights reserved.
//



import UIKit
import MapKit
import CoreLocation

var myTitle = [String]()
var myDetail = [String]()
var myLatitude = [Double]()
var myLongitude = [Double]()



class ForthViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, UITableViewDelegate,CLLocationManagerDelegate,UITableViewDataSource {
    
    @IBOutlet weak var titleTable: UITableView!
    
    @IBOutlet weak var todayMap: MKMapView!
    
    var routeColor = 0
    var selectedmyTitle: String!
    var selectedmyDetail: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        routeColor = 0
        
        todayMap.delegate = self    //todayMapを宣言
        
        //タイトル保管
        if NSUserDefaults.standardUserDefaults().objectForKey("myTitle") != nil   //配列が空でなければ保存したままにするよん
        {
            myTitle = NSUserDefaults.standardUserDefaults().objectForKey("myTitle") as! Array   //正しい型にcast
        }
        
        //説明保管ew
        if NSUserDefaults.standardUserDefaults().objectForKey("myDetail") != nil   //配列が空でなければ保存したままにするよん
        {
            myDetail = NSUserDefaults.standardUserDefaults().objectForKey("myDetail") as! Array   //正しい型にcast
        }
        
        //緯度保管
        if NSUserDefaults.standardUserDefaults().objectForKey("myLatitude") != nil   //配列が空でなければ保存したままにするよん
        {
            myLatitude = NSUserDefaults.standardUserDefaults().objectForKey("myLatitude") as! Array   //正しい型にcast
        }
        
        //経度保管
        if NSUserDefaults.standardUserDefaults().objectForKey("myLongitude") != nil   //配列が空でなければ保存したままにするよん
        {
            myLongitude = NSUserDefaults.standardUserDefaults().objectForKey("myLongitude") as! Array   //正しい型にcastr
        }
        
        if myTitle.last != nil {    //格納したものがあるとき！
        //地図を描画
            var totalLatitude = 0.0
            var totalLongitude = 0.0
            
            for var j = 0; j <= myTitle.count - 1 ; j++ {   //全てのあしあとの中間値を中心にもってくる
                
                totalLatitude = totalLatitude + myLatitude[j]
                totalLongitude = totalLongitude + myLongitude[j]
                
            }
            
            let aveLatitude = totalLatitude / Double(myTitle.count)
            let aveLongitude = totalLongitude / Double(myTitle.count)
            
            
            
            let mapLatitude:CLLocationDegrees = aveLatitude   //緯度
            let mapLongitude:CLLocationDegrees = aveLongitude     //経度
            let latDelta:CLLocationDegrees = 0.1   //小さいとズームイン、大きいとズームアウト
            let lonDelta:CLLocationDegrees = 0.1
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)    //緯度と経度の差異のコンビ（スパン）
            let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(mapLatitude, mapLongitude)   //位置情報map
            let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)  //緯度経度と位置情報を合わせる
            todayMap.setRegion(region, animated: true)   //描画
            
            
            //ピンを描画
            for var i = 0; i <= myTitle.count-1 ; i++ {
                
                
                print(myLatitude[i])
                print(myLongitude[i])
                
                let annotation = CustomMKPointAnnotation()    //注釈を定義
                
                let latitude = myLatitude[i]
                let longitude = myLongitude[i]
                
                let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                
                annotation.coordinate = location    //注釈を入れる位置情報を設定
                annotation.title = myTitle[i]   //タイトル
                //annotation.subtitle = myDetail[i]    //サブタイトル
                
                
                if i == 0{
                    
                    annotation.pinColor = MKPinAnnotationColor.Red      //スタートは赤のピン♪
                }
                else if i == myTitle.count - 1 {
                
                    annotation.pinColor = MKPinAnnotationColor.Green    //ゴールは緑のピン♪
                    
                } else {
                    
                    annotation.pinColor = MKPinAnnotationColor.Purple    //その他は紫のピン♪
                    
                }
                
                todayMap.addAnnotation(annotation)   //注釈を描画

                
                
                
            }
            
            //ルートを描画
            for var k = 0; k <= myTitle.count-2; k++ {

                
                //はじめの地点を取得
                let startLatitude = myLatitude[k]
                let startLongitude = myLongitude[k]
                
                //次の地点を取得
                let nextLatitude = myLatitude[k+1]
                let nextLongitude = myLongitude[k+1]
                
                //コンビを作る
                let startCouple:CLLocationCoordinate2D = CLLocationCoordinate2DMake(startLatitude, startLongitude)
                let nextCouple:CLLocationCoordinate2D = CLLocationCoordinate2DMake(nextLatitude, nextLongitude)
                
                // PlaceMarkを生成して出発点、目的地の座標をセット.
                let fromPlace: MKPlacemark = MKPlacemark(coordinate: startCouple, addressDictionary: nil)
                let toPlace: MKPlacemark = MKPlacemark(coordinate: nextCouple, addressDictionary: nil)
                
                
                // Itemを生成してPlaceMarkをセット.
                //let fromItem: MKMapItem = MKMapItem(placemark: fromPlace)
                //let toItem: MKMapItem = MKMapItem(placemark: toPlace)
                
                let myRequest: MKDirectionsRequest = MKDirectionsRequest()   // MKDirectionsRequestを生成.
                
                myRequest.source = MKMapItem(placemark:fromPlace)   // 出発地のItemをセット
                
                myRequest.destination = MKMapItem(placemark:toPlace) // 目的地のItemをセット.
                
                myRequest.requestsAlternateRoutes = true    // 複数経路の検索を有効.
                
                myRequest.transportType = MKDirectionsTransportType.Automobile  // 移動手段を車に設定.
                
                let myDirections: MKDirections = MKDirections(request: myRequest)   // MKDirectionsを生成してRequestをセット.
                


                // 経路探索.
                myDirections.calculateDirectionsWithCompletionHandler { (response, error) -> Void in
                    
                    // NSErrorを受け取ったか、ルートがない場合.
                    if error != nil || response!.routes.isEmpty {
                        return
                    }
                    
                    let route: MKRoute = response!.routes[0] as MKRoute
                    print("目的地まで \(route.distance)km")
                    print("所要時間 \(Int(route.expectedTravelTime/60))分")
                    
                    // mapViewにルートを描画.
                    self.todayMap.addOverlay(route.polyline)
                }

            }

        }

    }
    
    


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return myTitle.count         //セルの数をタイトル数とマッチ
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{       //セル数をindexの数で描画
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = myTitle[indexPath.row]
        
        return cell
    }
    
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = myTitle.count - 1
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        
//        print("タイトル")
//        print(myTitle.count)
//        print("アイテム")
//        print(itemCount)
//        print("インデックス")
//        print(index)
        
        if index == 0 {
            r = 1.0
            g = 0.0
        }
        else if index == itemCount  {
            r = 0.0
            g = 1.0
        } else {
            r = 1.0
            g = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        }
        
        
        return UIColor(red: r, green: g, blue: 0.0, alpha: 0.8)
        
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
            cell.backgroundColor = colorForIndex(indexPath.row)
            cell.textLabel?.textColor = UIColor.whiteColor()
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){ //スワイプで消すぜ
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            
            myTitle.removeAtIndex(indexPath.row)
            myDetail.removeAtIndex(indexPath.row)
            myLatitude.removeAtIndex(indexPath.row)
            myLongitude.removeAtIndex(indexPath.row)
            
            
            NSUserDefaults.standardUserDefaults().setObject(myTitle, forKey: "myTitle")
            NSUserDefaults.standardUserDefaults().setObject(myDetail, forKey: "myDetail")
            NSUserDefaults.standardUserDefaults().setObject(myLatitude, forKey: "myLatitude")
            NSUserDefaults.standardUserDefaults().setObject(myLongitude, forKey: "myLongitude")
            
            titleTable.reloadData()
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        titleTable.reloadData()
    }
    
    
    
    // ルート（線）の表示設定.
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        let route: MKPolyline = overlay as! MKPolyline
        let routeRenderer: MKPolylineRenderer = MKPolylineRenderer(polyline: route)
        // ルートの線の太さ.
        routeRenderer.lineWidth = 2.0
        // ルートの線の色.
        
        print(routeColor)
        print(myTitle.count - 2)
        
        if routeColor == 0 {
            routeRenderer.strokeColor = UIColor.redColor()
        }
        else if routeColor == 1{
            routeRenderer.strokeColor = UIColor.greenColor() 
        }
        else if routeColor == 2 {
            routeRenderer.strokeColor = UIColor.orangeColor()
        }
        else if routeColor == 3 {
            routeRenderer.strokeColor = UIColor.magentaColor()
        }
        else if routeColor == 4 {
            routeRenderer.strokeColor = UIColor.cyanColor()
        }
        else if routeColor == 5 {
            routeRenderer.strokeColor = UIColor.yellowColor()
        }
        else if routeColor == 6 {
            routeRenderer.strokeColor = UIColor.lightGrayColor()
        }
        else if routeColor == 7 {
            routeRenderer.strokeColor = UIColor.brownColor()
            routeColor = 0
        }

        
        print(routeColor)
        routeColor++
        return routeRenderer
        
    }
    
    
    //ピンの表示設定
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            //pinView!.animatesDrop = true
            pinView!.pinColor = (annotation as! CustomMKPointAnnotation).pinColor
     
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }


    
    
    class CustomMKPointAnnotation: MKPointAnnotation {
        var pinColor: MKPinAnnotationColor!
        var senderTag: Int!
    }
    
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        // [indexPath.row] から配列を探し、UImage を設定
        selectedmyTitle = myTitle[indexPath.row]
        selectedmyDetail = myDetail[indexPath.row]
        if selectedmyTitle != nil {
            // SubViewController へ遷移するために Segue を呼び出す
            performSegueWithIdentifier("toDetailView",sender: nil)
        }
        
    }
    
    // Segue 準備
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toDetailView") {
            let subVC: FifthViewController = (segue.destinationViewController as? FifthViewController)!
            // SubViewController のselectedImgに選択された画像を設定する
            subVC.thisTitle = selectedmyTitle
            subVC.thisDetail = selectedmyDetail

            
            
        }
    }
    

    
}
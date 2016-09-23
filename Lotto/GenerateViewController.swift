//
//  ViewController.swift
//  MyLotto
//
//  Created by Jeonghyun Kim on 23/09/2016.
//  Copyright © 2016 Jeonghyun Kim. All rights reserved.
//

import UIKit

class GenerateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  private var num: [Int] = [0, 0, 0, 0, 0, 0]
  private var ballImage: [UIImage] = [UIImage]()
  private var latestLottoData: [Lotto] = [Lotto]()
  private let refreshControl = UIRefreshControl()
  private let refreshControlBottom = UIRefreshControl()
  private var isLoading: Bool = false
  private var isFirst: Bool = true
  private let generateButton: UIButton = UIButton()
  
  private var latestTableView: UITableView!
  private var num1: UIImageView!
  private var num2: UIImageView!
  private var num3: UIImageView!
  private var num4: UIImageView!
  private var num5: UIImageView!
  private var num6: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    generateButton.addTarget(self,
                             action: #selector(self.generateButtonTouched),
                             for: UIControlEvents.touchUpInside)
    
    self.latestTableView.addSubview(self.refreshControl)
    self.refreshControl.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    self.refreshControl.addTarget(self, action: #selector(GenerateViewController.refreshTable), for: UIControlEvents.valueChanged)
    addContraints()
  }
  
  func generateButtonTouched(sender: UIButton?) {
    let warningBool1: Bool = Singleton.sharedInstance.mod2Is1Count < self.checkMod2Number(Singleton.sharedInstance.isIncludeNumbers)
    let warningBool2: Bool = 6 - Singleton.sharedInstance.mod2Is1Count < Singleton.sharedInstance.isIncludeNumbers.count - self.checkMod2Number(Singleton.sharedInstance.isIncludeNumbers)
    let bool1 = (warningBool1 || warningBool2) && Singleton.sharedInstance.isMod2Boolean && Singleton.sharedInstance.isIncludeBoolean
    let bool2 = (self.checkSameColorMax(Singleton.sharedInstance.isIncludeNumbers) > 3) && Singleton.sharedInstance.isSameColorBoolean
    
    if bool1 && bool2 {
      Singleton.sharedInstance.isMod2Boolean = false
      Singleton.sharedInstance.isSameColorBoolean = false
      UserDefaults.standard.set(false, forKey: "isMod2BooleanIdentifier")
      UserDefaults.standard.set(false, forKey: "isSameColorBooleanIdentifier")
      let alertController = UIAlertController(title: "Warning!!", message: "홀짝 개수 설정과 같은 색 개수 제한이 올바르지 않아 해제됩니다.", preferredStyle: UIAlertControllerStyle.alert)
      alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
      self.present(alertController, animated: true, completion: {})
    }
    else if bool1 {
      Singleton.sharedInstance.isMod2Boolean = false
      UserDefaults.standard.set(false, forKey: "isMod2BooleanIdentifier")
      let alertController = UIAlertController(title: "Warning!!", message: "홀짝 개수 설정이 올바르지 않아 해제됩니다.", preferredStyle: UIAlertControllerStyle.alert)
      alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
      self.present(alertController, animated: true, completion: {})
    }
    else if bool2 {
      Singleton.sharedInstance.isSameColorBoolean = false
      UserDefaults.standard.set(false, forKey: "isSameColorBooleanIdentifier")
      let alertController = UIAlertController(title: "Warning!!", message: "같은 색 개수 제한이 \n모두 올바르지 않아 해제됩니다.", preferredStyle: UIAlertControllerStyle.alert)
      alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default, handler: nil))
      self.present(alertController, animated: true, completion: {})
    }
    
    self.generateRandomLotto()
    self.saveLottoData()
  }
  
  func refreshTable() {
    DispatchQueue.main.async(execute: { () -> Void in
      self.latestTableView.reloadData()
      let alert: UIAlertView = UIAlertView(title: "Updated", message: nil, delegate: nil, cancelButtonTitle: nil)
      alert.show()
      let delay = 0.1 * Double(NSEC_PER_SEC)
      let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: time, execute: {
        alert.dismiss(withClickedButtonIndex: -1, animated: true)
      })
    })
    self.refreshControl.endRefreshing()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  private func prepareImages(views: [UIImageView], andAddThemToView view: UIView) {
    for image in views {
      view.addSubview(image)
    }
  }
  
  private func addContraints() {
    
  }
  
  private func generateRandomLotto() {
    while true {
      var index: [Int] = [Int](0...44)
      
      self.num.removeAll()
      if Singleton.sharedInstance.isIncludeBoolean {
        if Singleton.sharedInstance.isIncludeNumbers.count != 0 {
          for i in Singleton.sharedInstance.isIncludeNumbers {
            self.num.append(i)
            index.remove(at: self.findIndexOfInt(index, content: i))
          }
        }
      }
      if Singleton.sharedInstance.isNotIncludeBoolean {
        if Singleton.sharedInstance.isNotIncludeNumbers.count != 0 {
          for i in Singleton.sharedInstance.isNotIncludeNumbers {
            index.remove(at: self.findIndexOfInt(index, content: i))
          }
        }
      }
      
      if !Singleton.sharedInstance.isMod2Boolean {
//        for var i = 0; self.num.count < 6; i += 1 {
        for i in 0...100 {
          let temp = Int(arc4random()) % (index.count - i)
          self.num.append(index[temp])
          index.remove(at: temp)
          if !(self.num.count < 6) { break }
        }
      }
      else {
        var index1: [Int] = [Int]()
        var index2: [Int] = [Int]()
        
        for i in index {
          if i % 2 == 0 {
            index1.append(i)
          }
          else {
            index2.append(i)
          }
        }
        
        var exceptNum: Int = 0
        
        if Singleton.sharedInstance.isNotIncludeBoolean {
          exceptNum = self.checkMod2Number(Singleton.sharedInstance.isIncludeNumbers)
        }
        
//        for var i = 0; i < Singleton.sharedInstance.mod2Is1Count - exceptNum && self.num.count < 6; i += 1 {
        for i in 0...100 {
          let temp = Int(arc4random()) % (index1.count - i)
          self.num.append(index1[temp])
          index1.remove(at: temp)
          if !(i < Singleton.sharedInstance.mod2Is1Count - exceptNum && self.num.count < 6) { break }
        }
//        for var i = 0; self.num.count < 6; i += 1 {
        for i in 0...100 {
          let temp = Int(arc4random()) % (index2.count - i)
          self.num.append(index2[temp])
          index2.remove(at: temp)
          if !(self.num.count < 6) { break }
        }
      }
      
      self.num.sort();
      
      if Singleton.sharedInstance.isStraightBoolean {
        if !self.checkIsStraight() {
          continue
        }
      }
      
      if Singleton.sharedInstance.isSameColorBoolean {
        if self.checkSameColorMax(self.num) > 3 {
          continue
        }
      }
      
      //print("\(num[0]) \(num[1]) \(num[2]) \(num[3]) \(num[4]) \(num[5])")
      self.num1.image = self.ballImage[self.num[0]]
      self.num2.image = self.ballImage[self.num[1]]
      self.num3.image = self.ballImage[self.num[2]]
      self.num4.image = self.ballImage[self.num[3]]
      self.num5.image = self.ballImage[self.num[4]]
      self.num6.image = self.ballImage[self.num[5]]
      
      break
    }
  }
  
  func checkSameColorMax(_ test: [Int]) -> Int {
    var temp: [Int] = [0, 0, 0, 0, 0]
    var result: Int = 0
    for i in test {
      temp[i / 10] += 1
    }
    for i in temp {
      if result < i {
        result = i
      }
    }
    return result
  }
  
  func checkMod2Number(_ num: [Int]) -> Int {
    var result: Int = 0
    for i in num {
      if i % 2 == 0 {
        result += 1
      }
    }
    return result
  }
  
  func findIndexOfInt(_ num: [Int], content: Int) -> Int {
    for i in 0 ..< num.count {
      if num[i] == content {
        return i
      }
    }
    print("error: can't find the integer in that collection")
    return -1
  }
  
  func checkIsStraight() -> Bool {
    var temp: Int = self.num[0]
    for i in 1 ..< 6 {
      if temp == self.num[i] - 1 {
        return true
      }
      else {
        temp = self.num[i]
      }
    }
    return false
  }
  
  func saveLottoData() {
    //print("saveLottoData")
    Singleton.sharedInstance.lottoData.insert(num, at: 0)
    UserDefaults.standard.setValue(Singleton.sharedInstance.lottoData, forKey: "saveLotto")
  }
  
  func getLoad() {
    if UserDefaults.standard.value(forKey: "isIncludeNumbersIdentifier") != nil {
      Singleton.sharedInstance.isIncludeNumbers = UserDefaults.standard.value(forKey: "isIncludeNumbersIdentifier") as! [Int]
    }
    if UserDefaults.standard.value(forKey: "isNotIncludeNumbersIdentifier") != nil {
      Singleton.sharedInstance.isNotIncludeNumbers = UserDefaults.standard.value(forKey: "isNotIncludeNumbersIdentifier") as! [Int]
    }
    Singleton.sharedInstance.isIncludeBoolean = UserDefaults.standard.bool(forKey: "isIncludeBooleanIdentifier")
    Singleton.sharedInstance.isNotIncludeBoolean = UserDefaults.standard.bool(forKey: "isNotIncludeBooleanIdentifier")
    Singleton.sharedInstance.isStraightBoolean = UserDefaults.standard.bool(forKey: "isStraightBooleanIdentifier")
    Singleton.sharedInstance.isMod2Boolean = UserDefaults.standard.bool(forKey: "isMod2BooleanIdentifier")
    Singleton.sharedInstance.isSameColorBoolean = UserDefaults.standard.bool(forKey: "isSameColorBooleanIdentifier")
    Singleton.sharedInstance.mod2Is1Count = UserDefaults.standard.integer(forKey: "mod2Is1ValueIdentifier")
  }
  
  func httpGet(_ request: URLRequest!, callback: @escaping (String, String?) -> Void) {
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: {
      (data, response, error) -> Void in
      if error != nil {
        callback("", error!.localizedDescription)
      } else {
        let result = NSString(data: data!, encoding: CFStringConvertEncodingToNSStringEncoding( 0x0422 ))!
        callback(result as String, nil)
      }
    })
    task.resume()
  }
  
  func getLottoData(_ lottoNumber: Int) {
    let defaultAddress = "http://www.nlotto.co.kr/lotto645Confirm.do?method=byWin"
    let addressWithNumber = "http://www.nlotto.co.kr/lotto645Confirm.do?method=byWin&drwNo="
    
    var request: NSMutableURLRequest
    
    if lottoNumber == -1 {
      request = NSMutableURLRequest(url: URL(string: defaultAddress)!)
    }
    else {
      request = NSMutableURLRequest(url: URL(string: addressWithNumber + String(lottoNumber))!)
    }
    
    httpGet(request as URLRequest!) {
      (data, error) -> Void in
      if error != nil {
        print(error)
        
        return
      }
      else {
        var returnValue: [Int] = [Int]()
        var fixedData: String = data
        fixedData = fixedData.replacingOccurrences(of: " ", with: "")
        fixedData = fixedData.replacingOccurrences(of: "\r", with: "")
        fixedData = fixedData.replacingOccurrences(of: "\n", with: "")
        fixedData = fixedData.replacingOccurrences(of: "\t", with: "")
        fixedData = fixedData[(fixedData.range(of: "metaid=\"desc\"name=\"description\"content=\"")!.upperBound ..< fixedData.range(of: "원.")!.lowerBound)]
        //print(fixedData)
        var temp: String = fixedData[(fixedData.range(of: "나눔로또")!.upperBound ..< fixedData.range(of: "회")!.lowerBound)]
        returnValue.append(Int(temp)!)
        fixedData = fixedData[(fixedData.range(of: "호")!.upperBound ..< fixedData.range(of: ".")!.lowerBound)]
        for _ in 0 ..< 5 {
          temp = fixedData[(fixedData.startIndex ..< fixedData.range(of: ",")!.lowerBound)]
          returnValue.append(Int(temp)! - 1)
          fixedData = fixedData[(fixedData.range(of: ",")!.upperBound ..< fixedData.endIndex)]
        }
        temp = fixedData[(fixedData.startIndex ..< fixedData.range(of: "+")!.lowerBound)]
        returnValue.append(Int(temp)! - 1)
        returnValue.append(Int(fixedData[(fixedData.range(of: "+")!.upperBound ..< fixedData.endIndex)])! - 1)
        //Insert data to Singleton
        Singleton.sharedInstance.latestLottoData.append(Lotto(lottoNumber: returnValue[0], number1: returnValue[1], number2: returnValue[2], number3: returnValue[3], number4: returnValue[4], number5: returnValue[5], number6: returnValue[6], bonusNumber: returnValue[7]))
        
        self.checkLoad()
        
        if lottoNumber == -1 {
          self.connectServer()
        }
        //print("Lotto Loaded : " + String(returnValue[0]))
      }
    }
  }
  
  func checkLoad() {
    //print("checkLoad called : " + String(Singleton.sharedInstance.lottoLoadCount))
    Singleton.sharedInstance.lottoLoadCount += 1
    
    if Singleton.sharedInstance.lottoLoadCount >= Singleton.sharedInstance.maxLottoLoad {
      Singleton.sharedInstance.latestLottoData.sort(by: { (Element1, Element2) -> Bool in
        if Element1.lottoNumber < Element2.lottoNumber {
          return false
        }
        else {
          return true
        }
      })
      isLoading = false
      DispatchQueue.main.async(execute: { () -> Void in
        self.latestTableView.reloadData()
        if !self.isFirst {
          let alert: UIAlertView = UIAlertView(title: "Updated", message: nil, delegate: nil, cancelButtonTitle: nil)
          alert.show()
          let delay = 0.1 * Double(NSEC_PER_SEC)
          let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
          DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alert.dismiss(withClickedButtonIndex: -1, animated: true)
          })
        }
        else {
          self.isFirst = false
        }
      })
    }
  }
  
  func connectServer() {
    let lottoNumber = Singleton.sharedInstance.latestLottoData[0].lottoNumber - 1
    
    for i in 0 ..< Singleton.sharedInstance.maxLottoLoad - 1 {
      if lottoNumber - i > 0 {
        getLottoData(lottoNumber - i)
        //print("getLottoData " + String(lottoNumber - i) + " is called")
      }
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Singleton.sharedInstance.latestLottoData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let CellIdentifier = "latestCell"
    var cell: LottoTableViewCell! = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? LottoTableViewCell
    
    if cell == nil {
      tableView.register(LottoTableViewCell.self, forHeaderFooterViewReuseIdentifier: CellIdentifier)
      cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as? LottoTableViewCell
    }
    
    cell.number1.image = self.ballImage[Singleton.sharedInstance.latestLottoData[(indexPath as NSIndexPath).row].number1]
    cell.number2.image = self.ballImage[Singleton.sharedInstance.latestLottoData[(indexPath as NSIndexPath).row].number2]
    cell.number3.image = self.ballImage[Singleton.sharedInstance.latestLottoData[(indexPath as NSIndexPath).row].number3]
    cell.number4.image = self.ballImage[Singleton.sharedInstance.latestLottoData[(indexPath as NSIndexPath).row].number4]
    cell.number5.image = self.ballImage[Singleton.sharedInstance.latestLottoData[(indexPath as NSIndexPath).row].number5]
    cell.number6.image = self.ballImage[Singleton.sharedInstance.latestLottoData[(indexPath as NSIndexPath).row].number6]
    cell.lottoNumber.text = "\(Singleton.sharedInstance.latestLottoData[(indexPath as NSIndexPath).row].lottoNumber)회"
    cell.bonusNumber.image = self.ballImage[Singleton.sharedInstance.latestLottoData[(indexPath as NSIndexPath).row].bonusNumber]
    
    cell.selectionStyle = .none
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    Singleton.sharedInstance.awardNumberSelected = (indexPath as NSIndexPath).row
    self.performSegue(withIdentifier: "awardTableIdentifier", sender: self)
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let currentOffset: CGFloat = scrollView.contentOffset.y
    let maximumOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height
    
    if (maximumOffset + 60 < currentOffset && !isLoading) {
      isLoading = true
      Singleton.sharedInstance.lottoLoadCount = 0
      Singleton.sharedInstance.lottoLoadTotalCount = Singleton.sharedInstance.lottoLoadTotalCount + Singleton.sharedInstance.maxLottoLoad
      let lottoNumber = Singleton.sharedInstance.latestLottoData[Singleton.sharedInstance.latestLottoData.count - 1].lottoNumber - 1
      
//      for var i = lottoNumber; i > lottoNumber - Singleton.sharedInstance.maxLottoLoad && i > 0; i -= 1 {
      for i in lottoNumber...0 {
        getLottoData(i)
        if !(i > lottoNumber - Singleton.sharedInstance.maxLottoLoad && i > 0) { break }
      }
    }
  }

}


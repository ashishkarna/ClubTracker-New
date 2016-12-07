//
//  AddShopItemViewController.swift
//  ClubTracker
//
//  Created by Ashish Karna on 10/3/16.
//  Copyright © 2016 Ashish Karna. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddShopItemViewController: UIViewController {
    
    var Large = ""
    var Medium = ""
    var Small = ""
    var isDelivery = 0
    var delivaryCharge = ""
    var delivaryChargeTemp = ""
    var selectedImage:UIImage? = nil
    var tempIsDelivery = 0
    var paramsSizeQty = [[String:AnyObject]]()
    var paramsSizeQtyTemp = [[String:AnyObject]]()
    var updateIndex = -1
    var isUpdate = false
    var updateDataDetails = shopItemDetails()
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var btnAddItem: UIButton!
    @IBOutlet weak var lblClassName: UILabel!
    
    @IBOutlet weak var btnAddMain: UIButton!
    @IBOutlet weak var txtItemName: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewSizeQty: UITableView!
    
    @IBOutlet weak var txtQuantity: UITextField!
    @IBOutlet weak var txtSizeQty: UITextField!
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var btnTakeImg: UIButton!
    @IBOutlet weak var btnDelivery: UIButton!
    
    @IBOutlet weak var imgCaptureImage: UIImageView!
    
    @IBOutlet weak var txtDeliveryCharge: UITextField!
    
    @IBOutlet weak var viewSizeAndQty: UIView!
    @IBOutlet weak var viewDelivery: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let isTeacher = UserDefaults.standard.value(forKey: "isTeacher") as! Bool
        lblClassName.text = UserDefaults.standard.value(forKey: isTeacher ? "class_name" : "child_name") as? String
        // Do any additional setup after loading the view.
        tableViewSizeQty.register(UINib(nibName: "SizeAndQtyCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "sizeQtyCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        if isUpdate{
            updateData()
        }
        
    }
    
    func updateData(){
        
        txtItemName.text = updateDataDetails.item_title
        txtDescription.text = updateDataDetails.details
        txtPrice.text = "\(updateDataDetails.price!)"
        
        for itm in updateDataDetails.options{
            paramsSizeQty += [["title":itm.title as AnyObject,"quantity":itm.quantity as AnyObject]]
        }
         isDelivery = updateDataDetails.isDelivery!
        tempIsDelivery = isDelivery
        delivaryCharge = "\(updateDataDetails.charge!)"
        delivaryChargeTemp = delivaryCharge
        tableView.reloadData()
        selectedImage =
            URL(string: updateDataDetails.image!)
                .flatMap { NSData(contentsOf: $0) }
                .flatMap { UIImage(data: $0 as Data) }
        imgCaptureImage.image = selectedImage
        if updateDataDetails.isDelivery == 1{
            if updateDataDetails.charge! > 0.0{
             btnDelivery.setTitle("Delivary charge £ \(updateDataDetails.charge!)", for: .normal)
            }
            else{
                btnDelivery.setTitle("Free Delivary ", for: .normal)
            }
        
        }
        else{
            btnDelivery.setTitle("Set delivery charge", for: .normal)
        }
        paramsSizeQtyTemp = paramsSizeQty
       
        btnAddMain.setTitle("Update item", for: .normal)
        
    }
    
    func validationForm()->Bool{
        if paramsSizeQty.count == 0{
            self.showAlertOnMainThread("Size and quantity options  required")
            return false
        }
        if txtItemName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            self.showAlertOnMainThread("Item Name Required")
            return false
        }
        
        if txtPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            self.showAlertOnMainThread("Item Price Required")
            return false
        }
        
        if (txtDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count)! < 10{
            self.showAlertOnMainThread("Item Description more than 10 charachters ")
            return false
        }
        return true
    }
    @IBAction func btnDeliverTapped(_ sender: Any) {
        resignKeyBoard()
        if isDelivery == 1{
             txtDeliveryCharge.text = delivaryCharge
             btnSwitch.isOn = true
             txtDeliveryCharge.isEnabled = true
        }
        else{
            txtDeliveryCharge.text = ""
            btnSwitch.isOn = false
              txtDeliveryCharge.isEnabled = false
        }
        tempIsDelivery = isDelivery
        delivaryChargeTemp = delivaryCharge
        viewDelivery.isHidden = false
    }
    
    @IBAction func btnSwitchTapped(_ sender: Any) {
        if isDelivery == 0{
            isDelivery = 1
            txtDeliveryCharge.isEnabled = true
            txtDeliveryCharge.alpha = 1
            if delivaryChargeTemp != ""{
             txtDeliveryCharge.text = delivaryChargeTemp
            }
            
        }
        else{
            isDelivery = 0
            txtDeliveryCharge.text = ""
            txtDeliveryCharge.isEnabled = false
            txtDeliveryCharge.alpha = 0.3
        }
    }
    @IBAction func btnCalcelDeliveryTapped(_ sender: Any) {
        resignKeyBoard()
        isDelivery = tempIsDelivery
        delivaryCharge = delivaryChargeTemp
        viewDelivery.isHidden = true
        
        if isDelivery == 1{
            if Double(delivaryCharge)! <= 0.0{
            btnDelivery.setTitle("Delivary charge £ \(delivaryCharge)", for: .normal)
        }
        else{
            btnDelivery.setTitle("Free Delivary ", for: .normal)
        }
        }
        else{
            btnDelivery.setTitle("Set delivery charge", for: .normal)
        }
        
    }
    
    @IBAction func btnDeliveryDone(_ sender: Any) {
        resignKeyBoard()
        if txtDeliveryCharge.text != "" && isDelivery == 1{
            if isDelivery == 1{
                delivaryCharge = txtDeliveryCharge.text!
                txtDeliveryCharge.text = ""
                btnDelivery.setTitle("Delivary charge £ \(delivaryCharge)", for: .normal)
            }
            else{
                delivaryCharge = ""
                txtDeliveryCharge.text = ""
                btnDelivery.setTitle("Set delivery charge", for: .normal)
            }
            viewDelivery.isHidden = true
        }
        else{
            self.showAlertOnMainThread("Deliver Charge Amount required")
        }
    }
    
    @IBAction func btnDoneTappedSizwQty(_ sender: Any) {
        if updateIndex == -1{
            paramsSizeQtyTemp = paramsSizeQty
           // paramsSizeQty.removeAll()
            viewSizeAndQty.isHidden = true
            tableViewSizeQty.isUserInteractionEnabled = true
            txtSizeQty.text = ""
            txtQuantity.text = ""
            resignKeyBoard()
        }
        else{
            self.showAlertOnMainThread("Update your options first")
        }
        tableView.reloadData()
    }
    
    @IBAction func btnCancelTappedSizeQty(_ sender: Any) {
       // paramsSizeQty.removeAll()
        txtSizeQty.text = ""
        txtQuantity.text = ""
        viewSizeAndQty.isHidden = true
         resignKeyBoard()
        tableViewSizeQty.isUserInteractionEnabled = true
         tableView.reloadData()
    }
    @IBAction func btnAddItemSizeQty(_ sender: Any) {
        resignKeyBoard()
        if updateIndex == -1{
            if txtSizeQty.text == ""{
                self.showAlertOnMainThread("Size and Color Required")
            }
            else if txtQuantity.text == ""{
                self.showAlertOnMainThread("Quantity Required")
            }
            else{
                paramsSizeQty += [["title":txtSizeQty.text as AnyObject,"quantity":txtQuantity.text as AnyObject]]
                txtSizeQty.text = ""
                txtQuantity.text = ""
            }
        }
        else{
            paramsSizeQty[updateIndex]["title"] = txtSizeQty.text as AnyObject
            paramsSizeQty[updateIndex]["quantity"] = txtQuantity.text as AnyObject
            updateIndex = -1
            txtSizeQty.text = ""
            txtQuantity.text = ""
            btnAddItem.setTitle("Add Options", for: .normal)
            tableViewSizeQty.isUserInteractionEnabled = true
        }
        tableViewSizeQty.reloadData()
    }
    
    @IBAction func btnSizeAndQTYTapped(_ sender: Any) {
        resignKeyBoard()
        paramsSizeQty = paramsSizeQtyTemp
        tableViewSizeQty.reloadData()
        viewSizeAndQty.isHidden = false
    }
    
    
    @IBAction func btnAddItemTapped(_ sender: Any) {
        resignKeyBoard()
        if validationForm(){
            
            var params = [String:AnyObject]()
            params["item_title"] =  txtItemName.text as AnyObject
            params["item_price"] = txtPrice.text as AnyObject
            params["delivery"] = "\(isDelivery)" as AnyObject
            params["delivery_charge"] = delivaryCharge as AnyObject
            params["description"] = txtDescription.text as AnyObject
            params["options"] = paramsSizeQtyTemp as AnyObject
            if !isUpdate{
                if selectedImage == nil{
                     self.showAlertOnMainThread("Image required")
                }else{
                    addShopItem(params, onCompletion:{
                        success in
                        self.showAlertOnMainThread("Successfully added item")
                    })
                }
            }
            else{
                params["item_id"] = "\(updateDataDetails.id!)" as AnyObject
                updateShopItem(params, onCompletion:{
                    success in
                    self.showAlertOnMainThread("Successfully update item")
                })
            }
        }
    }
}

//MARK: Button Action
extension AddShopItemViewController{
    
    @IBAction func btnBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnTakePhoto(_ sender: UIButton) {
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Options", message: "Choose Options", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // blue action button
        let fbAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
            print("camera action button tapped")
            self.cameraOpen()
        }
        
        // red action button
        let ttAction = UIAlertAction(title: "Library", style: UIAlertActionStyle.default) { (action) in
            print("library action button tapped")
            self.libraryOpen()
        }
        // red action button
        let cAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            print("cancel action button tapped")
        }
        
        // add action buttons to action sheet
        myActionSheet.addAction(fbAction)
        myActionSheet.addAction(ttAction)
        myActionSheet.addAction(cAction)
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    //MARK:- Custom Function
    func cameraOpen(){
        self.imagePicker = UIImagePickerController() //make a clean controller
        self.imagePicker.allowsEditing = false
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        self.imagePicker.mediaTypes = [kUTTypeImage as String]
        self.imagePicker.showsCameraControls = true
        present(self.imagePicker,
                animated: false,
                completion:nil)
    }
    
    func libraryOpen(){
        self.imagePicker = UIImagePickerController() //make a clean controller
        self.imagePicker.allowsEditing = false
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.imagePicker.mediaTypes = [kUTTypeImage as String]
       // self.imagePicker.showsCameraControls = true
        present(self.imagePicker,
                animated: false,
                completion:nil)

    }
    func resignKeyBoard(){
        txtQuantity.resignFirstResponder()
        txtSizeQty.resignFirstResponder()
        txtPrice.resignFirstResponder()
        txtItemName.resignFirstResponder()
        txtDescription.resignFirstResponder()
        txtDeliveryCharge.resignFirstResponder()
    }
    
    func addShopItem(_ params: [String: AnyObject]?,onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        WebServiceHelper.addShopItem(selectedImage:imgCaptureImage.image, params:params as [String : AnyObject]?, onCompletion: { [weak self]
            response in
            //  print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successfully saved 
                        
                            onCompletion(true)
                    case 301: //already taken
                        
                        self?.showAlertOnMainThread("Attendance already taken")
                        break
                    case 404:
                        break
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                        
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case.failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
        })
        
    }
    
    func updateShopItem(_ params: [String: AnyObject]?,onCompletion:@escaping (_ success: Bool)->()){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        WebServiceHelper.updateShopItem(selectedImage:imgCaptureImage.image, params:params as [String : AnyObject]?, onCompletion: { [weak self]
            response in
            //  print(params)
            debugPrint(response)
            MBProgressHUD.hideAllHUDs(for: self?.view, animated: true)
            
            switch response.result {
                
            case .success(let responseData) :
                
                if let status_code = response.response?.statusCode {
                    
                    
                    switch status_code {
                        
                    case 200 : //Successfully saved
                        
                        onCompletion(true)
                    case 301: //already taken
                        
                        self?.showAlertOnMainThread("Attendance already taken")
                        break
                    case 404:
                        break
                    case 401: // Login Unsuccessful
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                        
                    case 500: // Cannot Create Token
                        self?.showAlertOnMainThread((responseData as AnyObject).value(forKey:"error") as! String)
                    default:
                        self?.showAlertOnMainThread(kServerError)
                        
                    }
                    
                }
                
            case.failure(let error):
                self?.showAlertOnMainThread(error.localizedDescription)
                
            }
        })
        
    }
}

extension AddShopItemViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paramsSizeQty.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 101{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SizeAndQtyCell
            cell.setupCell(size: paramsSizeQty[indexPath.row]["title"] as! String, Qty: paramsSizeQty[indexPath.row]["quantity"] as! String, index: indexPath.row)
            cell.delegate = self
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! sizeQtyCell
            cell.setupCell(size: paramsSizeQty[indexPath.row]["title"] as! String, qty: paramsSizeQty[indexPath.row]["quantity"] as! String)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          if tableView.tag == 101{
        return 74
        }
          else{
            return 26
        }
    }
    
}

extension AddShopItemViewController:sizeQtyCellDelegates{
    func editButtonTapped(sender: UIButton) {
        txtSizeQty.text = paramsSizeQty[sender.tag]["title"] as? String
        txtQuantity.text = paramsSizeQty[sender.tag]["quantity"] as? String
        updateIndex = sender.tag
        btnAddItem.setTitle("Update Options", for: .normal)
        tableViewSizeQty.isUserInteractionEnabled = false
    }
    
    func removeButtonTapped(sender: UIButton) {
        paramsSizeQty.remove(at: sender.tag)
        tableViewSizeQty.reloadData()
    }
}



//MARK: Camera Delegate Meethod
extension AddShopItemViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: false, completion: nil)

            let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        selectedImage = chosenImage
        imgCaptureImage.image = chosenImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

            self.dismiss(animated: true, completion: nil)
        print("Canceled!!")
        
    }
    
    
}



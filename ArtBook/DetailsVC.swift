//
//  DetailsVC.swift
//  ArtBook
//
//  Created by Hamit  Tırpan on 21.09.2019.
//  Copyright © 2019 Hamit  Tırpan. All rights reserved.
//

import UIKit
import CoreData

class DetailsVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    var chosenPainting = ""
    var chosenPaintingId : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if chosenPainting != ""{
            //CoreData
        }
        
        //Recognizers
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTapRecognizer)
    }
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    // Eğer Storyboard içindeki componentleri viewControllera sürükleyip bıraktıktan sonra sarı ünlem hatası verir ise
    // Main.storyboard'a sağ tık -> Open As -> SourceControl ile açıp ViewController satırına bakıp tag'ler içinde eksik olan
    // alanları tamamlarsam sorun düzelecektir. 
    @IBAction func saveButtonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        //Attributes
        newPainting.setValue(nameText.text, forKey: "name")
        newPainting.setValue(artistText.text, forKey: "artist")
        
        if let year = Int(yearText.text!){
            newPainting.setValue(year, forKey: "year")
        }
        
        newPainting.setValue(UUID(), forKey: "id")
        
        // Yüklenen resmi %50 sıkıştırıp kaydetmek için
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        
        newPainting.setValue(data, forKey: "image")
        
        // Save işlemini yapmak için "do-try-catch" kullanmalıyım.
        do{
            try context.save()
                print("Saved")
        } catch{
            print("Error")
        }
        
        // Tüm ViewController'ların mesajlaşıp haberleşebileceği bir yapı oluşturuyorum. newData diye bir mesaj gönderiyorum viewController'lara ve kullanmak istediğim yerlerde eğer bu mesajı alırsan şu fonksiyonu çalıştır gibi kullanabilirim.
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        // Geri gitmek için...
        self.navigationController?.popViewController(animated: true);
        
    }
    
}

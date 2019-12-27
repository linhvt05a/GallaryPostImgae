
import UIKit
import Alamofire
import Photos
import AVKit
import DKImagePickerController
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var list: UICollectionView!
    var mang:[UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mang.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadimageCollectionViewCell", for: indexPath)as! loadimageCollectionViewCell
        cell.imageecell.image = mang[indexPath.item] as UIImage
        return cell
    }
    @IBAction func SelectImage(_ sender: Any) {
        showImage { (images) in
            self.mang.append(contentsOf: images)
            self.list.reloadData()
    
        }
    }
    
    func showImage(_ completion: @escaping((_ images:[UIImage])->Void)){
        let picker = DKImagePickerController()
        picker.didSelectAssets = {(assets: [DKAsset])in
            
            var images = [UIImage]()
           
            for item in assets {
                item.fetchImage(with: CGSize(width: 300, height: 300)) { (img, info) in
                    if let img = img {
                        images.append(img)
//                        self.imgeView.image = img
                    }
                }
            }
            completion(images)
        }
        self.present(picker, animated: true, completion: nil)
    }
    @IBAction func PostDataImage(_ sender: Any) {
        var dataImage:[Dictionary<String,Any>] = []
        mang.forEach { (img) in
            let tmpImage = img.jpegData(compressionQuality: 1)
            dataImage.append(
            [
                "key":"avatar",
                "value":tmpImage as Any
                ]
            )
        }
        self.UploadImage(url: "http://192.168.1.3:3000/cool-profile", dataImage: dataImage)
    }
    func UploadImage(url:String, dataImage:[Dictionary<String, Any>]?){
        AF.upload(multipartFormData: {(mutilpartFormData) in
            if let dataImage = dataImage {
                for dict in dataImage {
                    guard  let key:String = dict["key"] as? String,
                        let data:Data = dict["value"] as? Data else {return}
                    mutilpartFormData.append(data, withName: key, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "avatar/jpeg")
                
                }
            }
        }, to: url)
        
    }
}


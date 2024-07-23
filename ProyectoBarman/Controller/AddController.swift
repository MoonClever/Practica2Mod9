

import UIKit

class AddController: UIViewController {

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ingredientTF: UITextField!
    @IBOutlet weak var descTF: UITextField!
    @IBOutlet weak var cocktailImage: UIImageView!
    
    var photoCheck: Bool = false
    
    var index: Int = 0
    
    var newCocktail: Cocktail?
    
    let ipc = UIImagePickerController()
    
    var imageString: String?
    
    var date : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newCocktail = Cocktail(name: "", ingredients: "", directions: "", img: "")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func getPhoto(_ sender: Any) {
        ipc.delegate = self
        ipc.allowsEditing = true
        ipc.sourceType = .photoLibrary
        photoCheck = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let ac = UIAlertController(title: "Add photo", message: "Use camera or choose photo from gallery", preferredStyle: .alert)
            
            let action1 = UIAlertAction(title: "Camera", style: .default){
                alertaction in
                self.ipc.sourceType = .camera
                ac.dismiss(animated: false)
                self.present(self.ipc, animated: true)
            }
            
            let action2 = UIAlertAction(title: "Gallery", style: .default){
                alertaction in
                self.ipc.sourceType = .photoLibrary
                ac.dismiss(animated: false)
                self.present(self.ipc, animated: true)
            }
            
            ac.addAction(action1)
            ac.addAction(action2)
            self.present(ac, animated: true)
        }
        
        else{
            self.present(self.ipc, animated: true)
        }        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //newNote = Note(title: noteTitle.text ?? "", content: noteContent.text, date: Date())
        let destination = segue.destination as! ListController
        
        newCocktail?.name = nameTF.text ?? ""
        newCocktail?.ingredients = ingredientTF.text ?? ""
        newCocktail?.directions = descTF.text ?? ""
        newCocktail?.img = ((date ?? "0")+".jpg")

        
        
        destination.cocktail = newCocktail
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if(nameTF.text!.isEmpty || descTF.text!.isEmpty || ingredientTF.text!.isEmpty || !photoCheck){
            return false
        }
        
        else{
            return true
        }
    }
    
    

}

extension AddController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
                // Se configuro el recorte de la foto
                //La imagen se obtiene en la llave
        if let imagen = info[.originalImage] as? UIImage{
            // asignamos la foto al container, pero no se guarda en la galeria
            cocktailImage.image = imagen
            
            //para guardar la imagen en la galeria:
            UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
            saveToDocs(imagen)
        }
        picker.dismiss(animated: true)
                
                //Si se configuro el recorte de la foto
                // la imagen se obtiene en la llave
                if let imagen = info[.editedImage] as? UIImage{
                    // asignamos la foto al container, pero no se guarda en la galeria
                    cocktailImage.image = imagen
                    
                    //para guardar la imagen en la galeria:
                    UIImageWriteToSavedPhotosAlbum(imagen, nil, nil, nil)
                    saveToDocs(imagen)
                }
                picker.dismiss(animated: true)
            }
            
            func saveToDocs (_ img: UIImage) {
                date = Date().ISO8601Format()
                //encontramos la url de documents directory:
                if var dUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                    dUrl.append(path: ((date ?? "0") + ".jpg"))
                    // obtener los bytes que representan la foto
                    let bytes = img.jpegData(compressionQuality: 0.5)
                    do {
                        try bytes?.write(to:dUrl, options:.atomic)
                        print("Image saved in \(dUrl.absoluteString)")
                    }
                    catch {
                        print("Error saving image")
                    }
                }
            }
}


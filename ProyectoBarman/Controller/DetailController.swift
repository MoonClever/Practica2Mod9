
import UIKit

class DetailController: UIViewController {

    var detailCocktail: Cocktail?
    
    @IBOutlet weak var nameCocktail: UILabel!
    @IBOutlet weak var imageCocktail: UIImageView!
    @IBOutlet weak var ingredientCocktail: UITextView!
    @IBOutlet weak var descCocktail: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameCocktail.text = detailCocktail?.name
        ingredientCocktail.text = detailCocktail?.ingredients
        descCocktail.text = detailCocktail?.directions
        
        let fileManager = FileManager.default
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        var data : Data?

        let imageURL = documentsDirectory.appending(path:detailCocktail?.img ?? "0.jpg")
            //Check if file exists
        if fileManager.fileExists(atPath: imageURL.path){
                do{
                    data = try Data(contentsOf: imageURL)
                    imageCocktail.image = UIImage(data: data!)
                }
                
                catch{
                    print("Error loading image")
                    print(error)
                }
            }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

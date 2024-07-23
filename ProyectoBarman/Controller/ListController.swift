

import UIKit

class ListController: UIViewController {

    @IBOutlet weak var cocktailList: UITableView!
    @IBOutlet var networkErrorView: UIView!
    
    var cocktailManager : CocktailManager?
    var cocktail: Cocktail?
    
    var cocktailArray: [Cocktail] = []
    
    var detailIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cocktailManager = CocktailManager()
        if ((cocktailManager?.monitor.connectionType == "Datos Moviles")){
            networkErrorView.isHidden = false
            cocktailList?.backgroundView = networkErrorView
        }else{
            networkErrorView?.isHidden = true
        }

    }


    @IBAction func addCocktail(_ sender: Any) {
        performSegue(withIdentifier: "addCocktailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailCocktailSegue"{
            let destination = segue.destination as! DetailController
            destination.detailCocktail = cocktailManager?.getCocktail(at: detailIndex)
        }
        
        if segue.identifier ==  "addCocktailSegue"{
            let destination = segue.destination as! AddController
            print("sexo")
            destination.index = (cocktailManager?.getCocktailCount())!
        }
    }
    
}



extension ListController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cocktailArray = (cocktailManager?.getCocktailList())!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CocktailTableViewCell
        cell?.nameCocktail.text = cocktailArray[indexPath.row].name
        
        let imageString = cocktailArray[indexPath.row].img
        if let imageUrl = URL(string: imageString){
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let imageURL = documentsDirectory.appending(path: cocktailArray[indexPath.row].img)
            
            //Check if file exists
            if fileManager.fileExists(atPath: imageURL.path){
                
            }
            else{
                cocktailManager?.getCocktail(at: indexPath.row)
            }
        }
        return cell!
            
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cocktailManager?.getCocktailCount() == 0{
            networkErrorView.isHidden = false
            cocktailList.backgroundView = networkErrorView
        }
        
        else{
            networkErrorView?.isHidden = true
        }
        
        return cocktailManager!.getCocktailCount()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailIndex = indexPath.row
        performSegue(withIdentifier: "detailCocktailSegue", sender: self)
        //
    }
    
    
    @IBAction func unwindToRecetaViewController(segue: UIStoryboardSegue){
        let source = segue.source as! AddController
        cocktail = source.newCocktail
        
        cocktailManager?.createCocktail(cocktail: cocktail!)
        cocktailManager?.saveCocktails()
        
        
        cocktailManager?.loadCocktails()
        //reload table view
        cocktailList.reloadData()
    }
    
}

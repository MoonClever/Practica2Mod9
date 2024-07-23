import Foundation
import Network

class CocktailManager{
    
    let monitor = NetworkMonitor()
    private var cocktailList: [Cocktail] = []
    
    init(){
        descargarRecetas()
    }
    
    func descargarRecetas(){
        let baseStr = "http://janzelaznog.com/DDAM/iOS/"
        let urlStr = baseStr + "drinks.json"
        
        if let recetasURL = URL(string: urlStr){
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileDestinationURL = documentsDirectoryURL.appendingPathComponent(recetasURL.lastPathComponent)
            if FileManager.default.fileExists(atPath: fileDestinationURL.path){
                print("El JSON ya esta en documents")
                loadCocktails()
            } else{
                if monitor.isReachable && monitor.connectionType != "Datos Moviles"{
                    URLSession.shared.downloadTask(with: recetasURL){location, response, error in
                        guard let location = location, error == nil else{return}
                        do{
                            try FileManager.default.moveItem(at: location, to: fileDestinationURL)
                            print("Archivo descargado en carpeta Documents")
                            self.loadCocktails()
                        } catch{
                            print(error)
                        }
                    }.resume()
                    return
                }
            
            }
        }
        
    }
    
    //CRUD: Create
        func createCocktail(cocktail: Cocktail){
            cocktailList.append(cocktail)
        }
        
        //CRUD: Read
        func getCocktailList() -> [Cocktail]{
            return cocktailList
        }
        
        func downloadImages(){
            
        }
    
        func getCocktail(at index : Int) -> Cocktail{
            let baseStr = "http://janzelaznog.com/DDAM/iOS/"
            let imagesString = "drinksimages/"
            
            let cocktailImageString = baseStr + imagesString + cocktailList[index].img
            if let cocktailsURL = URL(string: cocktailImageString){
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let cocktailsDirectory = documentsDirectory.appending(path: cocktailList[index].img)
                
                if FileManager.default.fileExists(atPath: cocktailsURL.path){
                    
                }
                else{
                    if monitor.isReachable && monitor.connectionType != "Datos Moviles"{
                        URLSession.shared.downloadTask(with: cocktailsURL){location, response, error in
                            guard let location = location, error == nil else{return}
                            do{
                                try FileManager.default.moveItem(at: location, to: cocktailsDirectory)
                                print("File \(self.cocktailList[index].img) downloaded to Documents")
                            }
                            catch{
                                print(error)
                            }
                        }.resume()
                    }
                }
            }
            return cocktailList[index]
        }
        
        func getCocktailCount() -> Int{
            return cocktailList.count
        }
        
        func loadCocktails(){
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            let recetasURL = documentsDirectory.appending(path: "drinks.json")
            
            //Check if file exists
            if fileManager.fileExists(atPath: recetasURL.path){
                do{
                    let jsonData = fileManager.contents(atPath: recetasURL.path)
                    //Decode json file into array
                    cocktailList = try JSONDecoder().decode([Cocktail].self, from: jsonData!)
                }
                
                catch{
                    print("Error loading: ",error)
                }
            }
            
            else{
                print("Unable to load file")
            }
        }
        
        //CRUD: Update
        func updateCocktail(at index:Int, cocktail : Cocktail){
            cocktailList[index] = cocktail
        }
        
        func saveCocktails(){
            let fileManager = FileManager.default
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let cocktailURL = documentsDirectory.appendingPathComponent("drinks.json")
            
            //Save [Cocktail] to JSON file
            do{
                let jsonData = try JSONEncoder().encode(cocktailList)
                fileManager.createFile(atPath: cocktailURL.path, contents: jsonData)
            }
            catch let error{
                print(error)
            }
        }
        
        
        //CRUD: Delete
        func deleteCocktail(at index : Int){
            cocktailList.remove(at: index)
        }
        
    
    
}

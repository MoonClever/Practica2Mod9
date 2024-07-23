import Foundation
import Network

class NetworkMonitor: ObservableObject{
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "monitor")
    
    var isReachable = false
    var connectionType = "none"
    
    init(){
        
        monitor.pathUpdateHandler = { path in
            self.isReachable = path.status == .satisfied
            if path.usesInterfaceType(.wifi) {
                self.connectionType = "WiFi"
            }
            
            else if path.usesInterfaceType(.cellular){
                self.connectionType = "Datos Moviles"
            }
            
            else{
                self.connectionType = "Otro"
            }
        }
        
        monitor.start(queue: queue)
    }
}

//
//  ViewController.swift
//  Exemplo1 Rest iOS
//
//  Created by Usuário Convidado on 25/08/2018.
//  Copyright © 2018 Julio Augusto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var minhaImagem: UIImageView!
    @IBOutlet weak var local: UILabel!
    @IBOutlet weak var estado: UILabel!
    @IBOutlet weak var qtd: UILabel!
    
    var session:URLSession?
    var quantidade:Int = 0
    
    @IBAction func exibir(_ sender: Any) {
        
        //Cria uma configuração de sessão default
        let config = URLSessionConfiguration.default
        
        //cria uma sessão com a configuração defaul
        session = URLSession(configuration: config)
        
        //acesso a API feita em PHP criada em meu servidor no GoDaddy
        //let url = URL(string: "https://www.scarpioni.com/webservices/local.php/?id=1")
        //acesso a API feita em Node.JS criada Heroku
        let url = URL(string: "https://parks-api.herokuapp.com/parks/577024e4a44821110001ee93")
        
        let task = session!.dataTask(with: url!) { (data, response, error) in
            //ações que serão efetuadas quando a execução da task se compleeta
            let texto = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print(texto!)
            if let nPq = self.retornarNomePQ(data: data!){
                DispatchQueue.main.async {
                    self.local.text = nPq
                    self.qtd.text = "Qtd de chaves no Json é \(self.quantidade)"
                }
            }
            if let ePq = self.retornarEstadoPQ(data: data!){
                DispatchQueue.main.async {
                    self.estado.text = ePq
                }
            }
            if let appImagemURL = self.retornarImagemPQ(data: data!){
                DispatchQueue.main.async {
                    self.carregarImagemURL(imagemURL: appImagemURL)
                }
            }
        }
        //disparo da execução da task
        task.resume()
        
    }
    
    func retornarNomePQ(data:Data)-> String?{
        var resposta:String?=nil
        do{
            //a linha abaixo faz a leitura dos valoress do Json, NSJSONSeriaization faz o Parser do Json
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            //cria e popula uma string a partir da chave "nome"
            if let nomeParque = json["nome"] as? String{
                resposta = nomeParque
                quantidade = json.count //apenas um exemplo para contar a qtd de chaves do Json
            }
        }catch let error as NSError{
            return "Falha ao carregar :\(error.localizedDescription)"
        }
        return resposta
    }
    
    func retornarEstadoPQ(data:Data)-> String?{
        var resposta:String?=nil
        do{
            //a linha abaixo faz a leitura dos valoress do Json, NSJSONSeriaization faz o Parser do Json
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            //cria e popula uma string a partir da chave "estado"
            if let estadoParque = json["estado"] as? String{
                resposta = estadoParque
            }
            
        }catch let error as NSError{
            return "Falha ao carregar :\(error.localizedDescription)"
        }
        return resposta
    }
    
    func retornarImagemPQ(data:Data)-> String?{
        var resposta:String?=nil
        do{
            //a linha abaixo faz a leitura dos valoress do Json, NSJSONSeriaization faz o Parser do Json
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            //cria e popula uma string a partir da chave "urlfoto"
            if let urlString = json["urlfoto"] as? String{
                print(urlString)
                resposta = urlString
            }
            
        }catch let error as NSError{
            return "Falha ao carregar :\(error.localizedDescription)"
        }
        return resposta
    }
    
    func carregarImagemURL(imagemURL:String){
        //Cria uma URL da string imagemURL
        let myURL = URL(string: imagemURL)
        let url = URLRequest(url: myURL!)
        //cria uma task do tipo Download
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            //se resposta = not null recebe o binário da imagem
            if let imagemData = data{
                //transforma o binário em UIImage e atualzia at ela da thread principal
                DispatchQueue.main.async {
                    self.minhaImagem.image = UIImage(data: imagemData)
                }
            }
        })
        //disparo da execuçao da task
        task.resume()
    }

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


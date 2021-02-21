//
//  ViewController.swift
//  lecture8
//
//  Created by admin on 08.02.2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var feelsLikeTemp: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var myData: Model?
    var choiceCity = String()
    var arr: String?
    
//    let urlNurSultan = Constants.hostNurSultan
//    let urlAlmaty = Constants.hostAlmaty
//    let urlNewYork = Constants.hostNewYork
    
    
    
    let checkWeather = ["rain" , "clouds" , "clear" , "snow"]
    
    private var decoder: JSONDecoder = JSONDecoder()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if arr == "Almaty" {
            choiceCity = "https://api.openweathermap.org/data/2.5/onecall?lat=43.25654&lon=76.92848&exclude=minutely,alerts&appid=0e9477e67e53c8c91844f7d87860ae02&units=metric"
        } else if arr == "Astana" {
            choiceCity = "https://api.openweathermap.org/data/2.5/onecall?lat=51.1801&lon=71.446&exclude=minutely,alerts&appid=0e9477e67e53c8c91844f7d87860ae02&units=metric"
            
        } else if arr == "NewYork" {
            choiceCity = "https://api.openweathermap.org/data/2.5/onecall?lat=42.35843&lon=-71.05977&exclude=minutely,alerts&appid=0e9477e67e53c8c91844f7d87860ae02&units=metric"
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.nib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        fetchData()
    }
    
    
    func updateUI(){
        cityName.text = myData?.timezone
        temp.text = "\(myData?.current?.temp ?? 0.0)"
        feelsLikeTemp.text = "\(myData?.current?.feels_like ?? 0.0)"
        desc.text = myData?.current?.weather?.first?.description
        collectionView.reloadData()
        tableView.reloadData()
        
    }
    
    func fetchData(){
        let urlString = choiceCity
        print("That is url : \(urlString)")
        AF.request(choiceCity).responseJSON { (response) in
            switch response.result{
            case .success(_):
                
                guard let data = response.data else { return }
                guard let answer = try? self.decoder.decode(Model.self, from: data) else{ return }
                
                self.myData = answer
                self.updateUI()
                
            case .failure(let err):
                print(err.errorDescription ?? "")
                
            }
        }
    }
    
    func setImageForWeather(_ desc : String?) -> String {
        
        for itemWeather in checkWeather {
            if (desc?.contains(itemWeather) == true) {
                return itemWeather
            }
        }
        return "madara"
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData?.daily?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        let item = myData?.daily?[indexPath.item]
        
        cell.day.text = dayFinder("\(indexPath.item)")
        cell.temp.text = "\(item?.temp?.day ?? 0.0)"
        cell.feelsLike.text = "\(item?.feels_like?.day ?? 0.0)"
        cell.desc.image = UIImage(named: setImageForWeather((item?.weather?.first?.main)?.lowercased()))
        
        return cell
    }
    
    func dayFinder(_ indexPath : String) -> String? {
        
        switch indexPath{
        case "0":
            return "Monday"
        case "1":
            return "Tuesday"
        case "2":
            return "Wednesday"
        case "3":
            return "Thursday"
        case "4":
            return "Friday"
        case "5":
            return "Saturday"
        case "6":
            return "Sunday"
        default:
            return "NU bratan kumash"
        }
        
    }
    
}


extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return myData?.hourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
       
        let item = myData?.hourly?[indexPath.item]
        cell.temp.text = "\(item?.temp ?? 0.0)"
        cell.feelsLike.text = "\(item?.feels_like ?? 0.0)"
        cell.desc.text = item?.weather?.first?.description
        return cell

    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
}



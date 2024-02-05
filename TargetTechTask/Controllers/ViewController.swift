//
//  ViewController.swift
//  TargetTechTask
//
//  Created by Apple  on 03/02/2024.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    var articles: NYTimesModel!
    var resultData : [Results] = []
    let activityIndicator = UIActivityIndicatorView(style: .large)
    private var monitor: NWPathMonitor!
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell class
        let nib = UINib(nibName: "ArticalsTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ArticalsTableViewCell")
        
        
        // Setup the activity indicator
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        setupNetworkMonitoring()
        
    }
    
    func fetchData() {
        // Start the activity indicator
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        
        let apiKey = "6ynxQYLWbjUxQp2S3uE2jSEqWvmoAWBZ"
        let url = "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/all-sections/7.json?api-key=\(apiKey)"
        
        
        guard let apiUrl = URL(string: url) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: apiUrl) { (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let result = try JSONDecoder().decode(NYTimesModel.self, from: data)
                self.articles = result
                self.resultData = result.results ?? []
                
                // Save the Api response data in UserDefaults
                let encodedData = try JSONEncoder().encode(self.articles)
                UserDefaults.standard.set(encodedData, forKey: "savedData")
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }.resume()
    }
    
    //SetUp Network Monitoring
    private func setupNetworkMonitoring() {
        monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                print("Internet is available")
                self?.fetchData()
            } else {
                print("Internet is not available")
                self?.fetchDataFromUserDefaults()
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
    
    //Fecth Data from user defaults
    func fetchDataFromUserDefaults() {
        if let savedData = UserDefaults.standard.data(forKey: "savedData"),
           let savedItems = try? JSONDecoder().decode(NYTimesModel.self, from: savedData) {
            self.resultData = savedItems.results ?? []
            self.tableView.reloadData()
            
        }
    }
    
    // Show Details
    func showDetail(for article: Results) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        nextVC.resultData = [article]
        nextVC.nyTimes = articles
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

// MARK: - Table View
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticalsTableViewCell", for: indexPath) as! ArticalsTableViewCell
        let article = resultData[indexPath.row]
        cell.titleLabel?.text = article.title
        cell.detailsLabel.text = article.abstract
        cell.dateLabel.text = article.published_date
        cell.sectionLabel.text = article.section
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = resultData[indexPath.row]
        showDetail(for: article)
    }
}

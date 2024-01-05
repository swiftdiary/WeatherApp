//
//  DetailsViewController.swift
//  WeatherApp
//
//  Created by Akbar Khusanbaev on 05/01/24.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var isStarred: Bool {
        get {
            guard let starredItems = UserDefaults.standard.array(forKey: "starred") as? [String] else {
                return false
            }
            return starredItems.contains(weather.location.name)
        }
        set {
            var starredItems = UserDefaults.standard.array(forKey: "starred") as? [String] ?? []
            if newValue {
                starredItems.append(weather.location.name)
            } else {
                starredItems.removeAll { $0 == weather.location.name }
            }
            UserDefaults.standard.set(starredItems, forKey: "starred")
            UserDefaults.standard.synchronize()
        }
    }

    let weather: WeatherModel
    let networkManager = NetworkManager.shared
    var forecast: ForecastModel?
    var forecastDays: Int?

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailsTableViewCell.self, forCellReuseIdentifier: "DetailsTableViewCell")
        return tableView
    }()
    
    init(weatherModel: WeatherModel) {
        self.weather = weatherModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        setupUI()
        fetchForecast()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        let starButton = UIBarButtonItem(image: UIImage(systemName: isStarred ? "star.fill" : "star"), style: .plain, target: self, action: #selector(starButtonTapped))
        navigationItem.rightBarButtonItem = starButton

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchForecast() {
        let location = weather.location
        title = "\(location.region), \(location.name)"
        Task {
            do {
                let forecastData = try await networkManager.fetchForecastData(for: location.name)
                let decoder = JSONDecoder()
                let response = try decoder.decode(ForecastModel.self, from: forecastData)

                DispatchQueue.main.async { [weak self] in
                    self?.forecast = response
                    self?.tableView.reloadData()
                }

            } catch let decodingError as DecodingError {
                print("Decoding error: \(decodingError)")
            } catch let networkError as NetworkManagerErrors {
                print("Network error: \(networkError)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
    }
    
    @objc func starButtonTapped() {
        isStarred.toggle()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isStarred ? "star.fill" : "star")
    }
}

// MARK: TableView Delegates
extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return forecast?.forecast.forecastday.count ?? 0
        case 1:
            return forecast?.forecast.forecastday.first?.hour.count ?? 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as! DetailsTableViewCell

        switch indexPath.section {
        case 0:
            if let forecastDay = forecast?.forecast.forecastday[indexPath.row] {
                cell.titleLabel.text = forecastDay.date
                cell.temperatureLabel.text = "\(forecastDay.day.mintempC)°C | \(forecastDay.day.maxtempC)°C"
                if let url = URL(string: "https:" + forecastDay.day.condition.icon) {
                    cell.loadImage(from: url)
                }
            }
        case 1:
            if let forecastDay = forecast?.forecast.forecastday.first {
                let forecastHour = forecastDay.hour[indexPath.row]
                cell.titleLabel.text = forecastHour.time
                cell.temperatureLabel.text = "\(forecastHour.tempC)°C"
                if let url = URL(string: "https:" + forecastHour.condition.icon) {
                    cell.loadImage(from: url)
                }
            }
        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Daily Forecast"
        case 1:
            return "Hourly Forecast"
        default:
            return nil
        }
    }
}

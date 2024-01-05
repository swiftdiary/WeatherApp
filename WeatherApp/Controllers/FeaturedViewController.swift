//
//  FeaturedViewController.swift
//  WeatherApp
//
//  Created by Akbar Khusanbaev on 04/01/24.
//

import UIKit

class FeaturedViewController: UIViewController {
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var starredCities: [String] = ["New York", "Tashkent"]
    
    var weatherData: [String: WeatherModel] = [:]

    let networkManager = NetworkManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let cities = UserDefaults.standard.array(forKey: "starred") as? [String] {
            starredCities = cities
            self.updateUI()
        }
    }
    
    func setupUI() {
        title = "Featured ✨"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground

        // Set up table view
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CityCell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: Weather
    func fetchWeatherDetails(for city: String, completion: @escaping () -> ()) {
        Task {
            do {
                let data = try await networkManager.fetchWeatherData(for: city)
                let weatherModel = try JSONDecoder().decode(WeatherModel.self, from: data)
                weatherData[city] = weatherModel
                completion()
            } catch {
                print("Error fetching or decoding weather data: \(error.localizedDescription)")
                completion()
            }
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension FeaturedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starredCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = WeatherTableViewCell(style: .default, reuseIdentifier: "WeatherCell")

        let city = starredCities[indexPath.row]

        if let currentWeather = weatherData[city] {
            let regionName = currentWeather.location.region
            let temperature = currentWeather.current.tempC
            let conditionIconURL = "https:" + currentWeather.current.condition.icon

            cell.regionLabel.text = regionName
            cell.temperatureLabel.text = "\(temperature)°C"

            if let url = URL(string: conditionIconURL) {
                Task {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                cell.conditionIconImageView.image = image
                            }
                        }
                    } catch {
                        print("Error downloading icon image: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            cell.regionLabel.text = "Loading..."
            cell.temperatureLabel.text = ""
            cell.conditionIconImageView.image = nil
            fetchWeatherDetails(for: city) { [weak self] in
                self?.updateUI()
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = starredCities[indexPath.row]
        if let weather = weatherData[selectedCity] {
            navigationController?.pushViewController(DetailsViewController(weatherModel: weather), animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

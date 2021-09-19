//  ViewController.swift
//  TextRecognizer
//
//  Created by Vibhhu Sharma and Nandini Chakravorty at 11:07 am on 18/09/21.
//

import Vision
import UIKit

class ViewController: UIViewController {

    private let good_label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0;
        label.textAlignment = .center
        label.backgroundColor = .systemTeal
        label.text = "Starting 2"
        label.textColor = .black
        return label
    }()
    
    private let bad_label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0;
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.text = "Starting 2"
        label.textColor = .black
        return label
    }()
    
    private let points_label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0;
        label.textAlignment = .center
        label.backgroundColor = .orange
        label.text = "Starting 2"
        label.textColor = .black
        return label
    }()
    
    private let title_label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0;
        label.textAlignment = .center
        label.backgroundColor = .white
        label.text = "Starting 2"
        label.font = UIFont.boldSystemFont(ofSize: 22.0)
        label.textColor = .black
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "example1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(good_label)
        view.addSubview(bad_label)
        view.addSubview(points_label)
        view.addSubview(title_label)
        view.addSubview(imageView)
        recognizeText(image: imageView.image)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top, width: view.frame.size.width-40, height: view.frame.size.width-40)
        good_label.frame = CGRect(
                        x: 20,
                        y: view.frame.size.width + view.safeAreaInsets.top,
                        width: 150,
                        height: 250
                      )
        bad_label.frame = CGRect(
                        x: 205,
                        y: view.frame.size.width + view.safeAreaInsets.top,
                        width: 150,
                        height: 250
                      )
        points_label.frame = CGRect(
                        x: 100,
                        y: 290,
                        width: 200,
                        height: 80
                      )
        title_label.frame = CGRect(
                        x: 90,
                        y: 20,
                        width: 200,
                        height: 80
                      )
    }
    
    private func recognizeText(image: UIImage?) {
        guard let cgImage = image?.cgImage else {
            fatalError("Could not get CGImage")
        }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }

        let text = observations.compactMap({
            $0.topCandidates(1).first?.string
        }).joined(separator: " ")
            
        
        let good_ingredients = ["Tomato","Yogurt", "Chilli","Milk","Honey","Coriander","Chopped", "Paste", "Ginger", "Lemon", "Garlic"]
            let bad_ingredients = ["Powder","Cornflour", "Hydrogenated","Butter","Cashew","Iron","Cream", "Added", "Sugar", "Oil", "Chips", "Color", "Artificial", "Caramel"]

        let scanned_text : [String] = text.components(separatedBy: " ")
        
        var good_matches = "Good Ingredients: \n"
        var points = 0
        for i in 0...good_ingredients.count-1{
            for j in 0...scanned_text.count-1{
                if good_ingredients[i] == scanned_text[j]{
                    points += 97
                    good_matches = good_matches + "\n" + good_ingredients[i]
                }
            }
        }
        var bad_matches = "Bad Ingredients: \n"

        for i in 0...bad_ingredients.count-1{
            for j in 0...scanned_text.count-1{
                if bad_ingredients[i] == scanned_text[j]{
                    points -= 23
                    bad_matches = bad_matches + "\n" + bad_ingredients[i]
                }
            }
        }
            
        var judgement = ""
        print("Points: ", points)
            
            if points < 200{
                judgement = "Do not eat! 😤"
            }
            
            else if points < 400{
                judgement = "Not very healthy. 🤷‍♀️ "
            }
            
            else if points >= 400{
                judgement = "You're good to go! 🍽 "
            }
            
            else if points > 800{
                judgement = "What a healthy choice! 👏"
                
            }
            
        DispatchQueue.main.async {
          self?.good_label.text = good_matches
        }
        
        DispatchQueue.main.async {
          self?.bad_label.text = bad_matches
        }
            
        DispatchQueue.main.async {
            self?.points_label.text = "Health Score: \n" + String(points) + "\n" + judgement
        }
        
        DispatchQueue.main.async {
          self?.title_label.text = "NUTRICOUNT"
        }

    }

        do {
            try handler.perform([request])
        }
        catch{
            print(error)
        }

    }

}





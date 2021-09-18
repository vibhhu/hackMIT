//
//  ViewController.swift
//  TextRecognizer
//
//  Created by Vibhhu Sharma and Nandini Chakravorty at 11:07 am on 18/09/21.
//

import Vision
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var imagePicker: UIImagePickerController!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0;
        label.textAlignment = .center
        label.backgroundColor = .red
        label.text = "Starting "
        label.textColor = .black
        return label
    }()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imagePicker.dismiss(animated: true, completion: nil)
            imageView.image = info[.originalImage] as? UIImage
        }
    /*
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "example1")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(imageView)
        recognizeText(image: imageView.image)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.frame = CGRect(x: 20, y: view.safeAreaInsets.top, width: view.frame.size.width-40, height: view.frame.size.width-40)
        label.frame = CGRect(
                        x: 20,
                        y: view.frame.size.width + view.safeAreaInsets.top,
                        width: view.frame.size.width-40,
                        height: 200
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
        }).joined(separator: ", ")
            print(text)
        
        DispatchQueue.main.async {
          self?.label.text = text
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



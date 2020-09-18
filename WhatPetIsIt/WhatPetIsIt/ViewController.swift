//
//  ViewController.swift
//  WhatPetIsIt
//
//  Created by Justyna Kowalkowska on 18/09/2020.
//  Copyright © 2020 Justyna Kowalkowska. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = ""
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickerImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            guard let convertedUIImage = CIImage(image: userPickerImage) else {
                fatalError("Could not convert to CIImage.")
            }
            
            imageView.image = userPickerImage
            detect(flowerImage: convertedUIImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(flowerImage: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: PetImageClassifier().model) else {
            fatalError("Loading CoreML Model Failed.")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Could not classify image.")
            }
        
            self.nameLabel.text = classification.identifier.capitalized
        }
            
        let handler = VNImageRequestHandler(ciImage: flowerImage)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    
    }
    
    
    @IBAction func tappedCamera(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    

}


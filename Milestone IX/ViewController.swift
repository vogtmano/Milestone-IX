//
//  ViewController.swift
//  Milestone IX
//
//  Created by Maks Vogtman on 21/03/2023.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    var memeTextTop = ""
    var memeTextBottom = ""
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Meme generator"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
       showActivityIndicator()
    }
    
    
    func showActivityIndicator() {
        activityIndicator.color = .blue
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
       
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    @IBAction func topTextTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Insert text", message: "Here you can add text that will be placed at the top of your meme.", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Add text", style: .default, handler: { [weak self, weak ac] _ in
            self?.memeTextTop = ac?.textFields?[0].text ?? ""
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    
    @IBAction func bottomTextTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Insert text", message: "Here you can add text that will be placed at the bottom of your meme.", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Add text", style: .default, handler: { [weak self, weak ac] _ in
            self?.memeTextBottom = ac?.textFields?[0].text ?? ""
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    
    @IBAction func checkTapped(_ sender: Any) {
        drawMeme()
    }
    
    
    @IBAction func clearTapped(_ sender: Any) {
        let renderer = UIGraphicsImageRenderer(size: imageView.image!.size)
        
        let image = renderer.image { ctx in
            memeTextTop = ""
            memeTextBottom = ""
        }
        
        imageView.image = image
        
        activityIndicator.startAnimating()
    }
    
    
    @objc func shareTapped() {
        guard let image = imageView.image else { return }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    
    @objc func importPicture() {
        activityIndicator.stopAnimating()
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        imageView.image = image
    }
    
    
    func drawMeme() {
        let renderer = UIGraphicsImageRenderer(size: imageView.image!.size)
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            let attrs: [NSAttributedString.Key: Any] = [
                .strokeWidth: 10,
                .strokeColor: UIColor.white.cgColor,
                .font: UIFont.systemFont(ofSize: 80),
                .paragraphStyle: paragraphStyle
            ]
            
            guard let image = imageView.image else { return }
            image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
            
            let topAttributedString = NSAttributedString(string: memeTextTop, attributes: attrs)
            let bottomAttributedString = NSAttributedString(string: memeTextBottom, attributes: attrs)
            let bottomTextSize = bottomAttributedString.boundingRect(with: CGSize(width: image.size.width - 10, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil).size

            topAttributedString.draw(with: CGRect(x: 5, y: 10, width: image.size.width, height: image.size.height), options: .usesLineFragmentOrigin, context: nil)
            bottomAttributedString.draw(with: CGRect(x: 5, y: image.size.height - bottomTextSize.height, width: image.size.width, height: bottomTextSize.height), options: .usesLineFragmentOrigin, context: nil)
        }
        
        imageView.image = image
    }
}


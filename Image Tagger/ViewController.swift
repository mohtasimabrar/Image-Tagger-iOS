//
//  ViewController.swift
//  Image Tagger
//  Created by Mohtasim Abrar Samin on 29/11/21.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Image Tagger"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewImage))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to load")
        }
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Edit Card", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Remove", style: .default) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Change Name", style: .default) { [weak self] _ in
            let ac2 = UIAlertController(title: "Rename Card", message: nil, preferredStyle: .alert)
            
            ac2.addTextField { (textField) in
                textField.text = person.name
            }

            ac2.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            ac2.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac2] _ in
                guard let newName = ac2?.textFields?[0].text else { return }
                person.name = newName
                self?.collectionView.reloadData()
            })
            
            self?.present(ac2, animated: true)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
    }
    
    @objc func addNewImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()

        dismiss(animated: true)
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

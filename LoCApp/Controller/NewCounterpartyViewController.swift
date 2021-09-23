//
//  NewCounterpartyViewController.swift
//  LoCApp
//
//  Created by Андрей Важенов on 21.09.2021.
//

import UIKit

class NewCounterpartyViewController: UIViewController {

    
    //@IBOutlet var photoImageView: UIImageView!
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var phoneTextField: UITextField!
    
    @IBOutlet var emailTextField: UITextField!
    
    var viewModel: NewCounterpartyModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        setUpViews()
       
       photoImageView.makeRounded()
        nameTextField.becomeFirstResponder()
        phoneTextField.delegate = self
        phoneTextField.keyboardType = .phonePad
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }


    
    private func createTable() {
        let database = SQLiteDatabase.sharedInstance
        database.createTable()
    }
    
    private func setUpViews() {
        if let viewModel = viewModel {
        nameTextField.text = viewModel.name
        phoneTextField.text = viewModel.phoneNumber
        emailTextField.text = viewModel.email
        photoImageView.image = viewModel.photo
        }
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        let id: Int = viewModel == nil ? 0 : viewModel.id!
        let name = nameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let phoneNumber = phoneTextField.text ?? ""
        let uiImage = photoImageView.image ?? #imageLiteral(resourceName: "defualtContactIPhoto")
        guard let photo = uiImage.pngData() else {return}
        
        let counterpartyValues = Counterparty(id: id, name: name, phoneNumber: phoneNumber, photo: photo, email: email)
        
        // If viewModel equal to nil a new Counterparty will be created, otherwise an existing contact will be updated.
        if viewModel == nil {
            // Counterparty created
            createNewCounterparty(counterpartyValues)
        } else {
            // Counterparty updated
            updateCounterparty(counterpartyValues)
        }
        
    }
    private func  createNewCounterparty(_ counterpartyValues: Counterparty) {
        let counterpartyAddedToTable = SQLiteCommands.insertRow(counterpartyValues)
        if counterpartyAddedToTable == true {
            dismiss(animated: true, completion: nil)
        } else {
            showError("Error", message: "This contact cannot be created because this phone number already exist in your contact list.")
        }
        
    }
    
    private func updateCounterparty(_ counterpartyValues: Counterparty) {
        let counterpartyUpdatedInTable = SQLiteCommands.updateRow(counterpartyValues)
        if counterpartyUpdatedInTable == true {
            if let cellClicked = navigationController {
                cellClicked.popViewController(animated: true)
            }
        } else {
            showError("Error", message: "This contact cannot be updated because this phone number already exist in your contact list")
        }
        }
        
    
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let addButtonClicked = presentingViewController is UINavigationController
        // If the user clicked add button on the previous screen
        if addButtonClicked {
            // Dismisses back to the previous screen with animation
            dismiss(animated: true, completion: nil)
        }
        // If the user clicked on a cell on the previous screen
        else if let cellClicked = navigationController {
            cellClicked.popViewController(animated: true)
        } else {
            print("The ContactScreenTableViewController is not inside a navigation controller")
        }
    }
    @IBAction func addImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
       
    
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
}

extension UIViewController {
    // Alert message
    func showError(_ title: String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension NewCounterpartyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Image tap gesture
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")}
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
}

extension NewCounterpartyViewController: UITextFieldDelegate {
    // MARK: - Phone number validation
    private func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {return false}
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = format(with: "+X(XXX) XXX-XXXX", phone: newString)
        return false
    }
    
    
    
}



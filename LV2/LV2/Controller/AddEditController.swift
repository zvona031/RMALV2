//
//  AddEditController.swift
//  LV2
//
//  Created by Zvonimir Pavlović on 22/04/2020.
//  Copyright © 2020 Zvonimir Pavlović. All rights reserved.
//

import UIKit

protocol AddEditDelegate: class{
    func reloadData()
}

class AddEditController: UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var addEditButton: UIButton!
    @IBOutlet weak var txtDescription: UITextView!
    @IBOutlet weak var txtDateOfDeath: UITextField!
    @IBOutlet weak var txtDateOfBirth: UITextField!
    @IBOutlet weak var txtSurename: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var quoteTableView: UITableView!
    @IBOutlet weak var txtQuote: UITextField!
    @IBOutlet weak var addQuoteButton: UIButton!
    
    lazy var viewModel: AddEditViewModel = AddEditViewModel()
    private var placeholderLabel : UILabel!
    private var datePicker = UIDatePicker()
    var delegate : AddEditDelegate?
    private let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setDelegates()
        setActions()
        // Do any additional setup after loading the view
    }
    
    func setDelegates(){
        txtDescription.delegate = self
        txtQuote.delegate = self
    }
    
    func setActions(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(setImagePicker(_:)))
        profileImage.addGestureRecognizer(tap)
        addQuoteButton.addTarget(self, action: #selector(onAddQuoteClicked), for: .touchUpInside)
        if let person = viewModel.person {
            addEditButton.setTitle("Edit", for: .normal)
            addEditButton.addTarget(self, action: #selector(onAddEditClicked), for: .touchUpInside)
            if let imageData = try? Data(contentsOf: URL(string: person.imageName)!){
                let image = UIImage(data: imageData)
                profileImage.contentMode = .scaleAspectFill
                profileImage.image = image
            }
            txtName.text = person.name
            txtSurename.text = person.sureName
            txtDateOfBirth.text = person.dateOfBirth
            txtDateOfDeath.text = person.dateOfDeath
            txtDescription.text = person.description
            viewModel.quotes = person.quotes
            placeholderLabel.isHidden = !txtDescription.text.isEmpty
        }else{
             addEditButton.addTarget(self, action: #selector(onAddEditClicked), for: .touchUpInside)
        }
        
    }
    
    func setUI(){
        self.hideKeyboardWhenTappedAround()
        // setting pickers for birth and death
        setDatePicker(txtField: txtDateOfBirth)
        setDatePicker(txtField: txtDateOfDeath)
        // making textView look like textField
        placeholderLabel = Helper.makePlaceholderForTextView(textview: txtDescription)
        Helper.setBorderForTextView(textview: txtDescription)
        
        
    }
    
    func setDatePicker(txtField: UITextField){
        datePicker = Helper.setDatePicker(datePicker: datePicker, txtField: txtField,firstAction: #selector(doneDatePicker),secondAction: #selector(cancelDatePicker))
        
    }
    
    @objc func setImagePicker(_ sender: UITapGestureRecognizer? = nil){
        let alert = Helper.makeImagePickerAlert(firstAction: openCamera, secondAction: openGallery)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onAddQuoteClicked(){
        guard let quote = txtQuote.text else { return }
        if (quote != ""){
            viewModel.addQuote(quote: quote)
            txtQuote.text = ""
        }
        self.quoteTableView.reloadData()
    }
    
    @objc func doneDatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if txtDateOfBirth.isFirstResponder {
            txtDateOfBirth.text = formatter.string(from: datePicker.date)
        }
        if txtDateOfDeath.isFirstResponder {
            txtDateOfDeath.text = formatter.string(from: datePicker.date)
        }
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            let imagePicker = Helper.setImagePicker(type: .camera, delegate: self)
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert = Helper.makeWarningAlert(title: "Warning", message: "You don't have camera")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        let imagePicker = Helper.setImagePicker(type: .savedPhotosAlbum, delegate: self)
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func presentWarning(){
        let alert = Helper.makeEmptyTextAlert()
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func onAddEditClicked(){
        guard let name = txtName.text else { return }
        guard let sureName = txtSurename.text else { return }
        let image = profileImage.image
        guard let dateOfBirth = txtDateOfBirth.text else { return }
        guard let dateOfDeath = txtDateOfDeath.text else { return}
        guard let description = txtDescription.text else { return }
        if (name == "" || sureName == "" || dateOfBirth == "" || description == ""){
            presentWarning()
            return
        }
        // saving image with imagePath------staviti to u neki singleton
        let imageName = ImageSaver.shared.saveImage(image: image!)
        if let person = viewModel.person {
            viewModel.editPeople(id: person.id,name: name, sureName: sureName, imageName: imageName, dateOfBirth: dateOfBirth, dateOfDeath: dateOfDeath, description: description)
            let alert = Helper.makeEditedPeopleAlert(name: name)
            self.present(alert,animated: true, completion: nil)
        }else {
            viewModel.addPeople(name: name, sureName: sureName, imageName: imageName, dateOfBirth: dateOfBirth, dateOfDeath: dateOfDeath, description: description)
            let alert = Helper.makeAddedPeopleAlert(name: name)
            self.present(alert,animated: true, completion: nil)
            clearUI()
        }
        delegate?.reloadData()
    }
    
    func clearUI(){
        txtName.text = ""
        txtSurename.text = ""
        txtDateOfBirth.text = ""
        txtDateOfDeath.text = ""
        txtDescription.text = ""
        profileImage.image = UIImage(named: "profilePlaceHolder")
        viewModel.quotes = []
        quoteTableView.reloadData()
    }
}

extension AddEditController : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.contentMode = .scaleAspectFill
            profileImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension AddEditController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getQouteNumber()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.quoteTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = viewModel.quotes[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") {  (contextualAction, view, boolValue) in
            self.viewModel.removeQuote(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
}

extension AddEditController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) { [weak self] in
        guard let welf = self else { return }
        let frame = welf.view.frame
        welf.view.frame = CGRect(x: frame.origin.x, y: frame.origin.y - 200, width: frame.width, height: frame.height)
        }}
    // when user click 'done' or dismiss the keyboard
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) { [weak self] in
        guard let welf = self else { return }
        let frame = welf.view.frame
        welf.view.frame = CGRect(x: frame.origin.x, y: frame.origin.y + 200, width: frame.width, height: frame.height)
        }}
}

extension AddEditController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
}

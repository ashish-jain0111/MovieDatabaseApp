//
//  MovieDetailsViewController.swift
//  MovieDatabaseApp
//
//  Created by Ashish Jain on 29/07/23.
//

import UIKit

class MovieDetailsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var viewModel : MovieDetailsViewModel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: viewModel.Movie.Poster){
            posterImageView.load(url: url, defaultImage: "DefaultPoster")
        }
        title = viewModel.Movie.Title
        titleLabel.text = viewModel.Movie.Title
        plotLabel.text = viewModel.Movie.Plot
        directorLabel.text = viewModel.Movie.Director
        castLabel.text = viewModel.Movie.Actors
        releaseDateLabel.text = viewModel.Movie.Released
        genreLabel.text = viewModel.Movie.Genre
        ratingView.ratingSourceTextField.delegate = self
        ratingView.ratingSourceTextField.text = viewModel.Movie.Ratings[0].Source
        ratingView.ratingLabel.text = viewModel.Movie.Ratings[0].Value
        addPicker()
    }
    
    
    
    func addPicker(){
        let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar1.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar1.barStyle = UIBarStyle.default
        toolBar1.backgroundColor = UIColor.lightGray
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let okBarBtn1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(donePressed))
        toolBar1.setItems([flexSpace,flexSpace,flexSpace,okBarBtn1], animated: true)
        ratingView.ratingSourceTextField.inputAccessoryView = toolBar1
    }
    
    @objc func donePressed(_ sender: UIBarButtonItem) {
        ratingView.ratingSourceTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let thePicker = UIPickerView()
        thePicker.tag = 1000;
        ratingView.ratingSourceTextField.inputView = thePicker
        thePicker.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1000 {
            return viewModel.Movie.Ratings.count;
        }else{
            return 0;
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1000{
            let title = viewModel.Movie.Ratings[row].Source;
            return title
        }
        else {
            return ""
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1000{
            ratingView.ratingSourceTextField.text = viewModel.Movie.Ratings[row].Source
            ratingView.ratingLabel.text = viewModel.Movie.Ratings[row].Value
    }
    }
}

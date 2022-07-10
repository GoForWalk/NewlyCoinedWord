//
//  SearchViewController.swift
//  NewlyCoinedWord
//
//  Created by sae hun chung on 2022/07/09.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchStackView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet var keywordButtons: [UIButton]!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var meaningLabel: UILabel!
    
    var inputWords : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    // MARK: SetUI
    func setUI() {
        setSearchStackViewUI()
        setButtonsUI()
        setMainImage()
    }
    
    func setSearchStackViewUI() {
        searchStackView.layer.borderWidth = 4
        searchStackView.layer.borderColor = UIColor.black.cgColor
    }
    
    func setButtonsUI() {
        keywordButtons.forEach {
            $0.contentEdgeInsets = UIEdgeInsets(top: 4, left: 5, bottom: 4, right: 5)
            $0.layer.cornerRadius = 6
            $0.layer.borderColor = UIColor.black.cgColor
            $0.layer.borderWidth = 1
            $0.setTitle("", for: .normal)
            $0.isHidden = true
        }
    }
    
    func setMainImage() {
        mainImage.image = UIImage(named: "background")
        mainImage.contentMode = .scaleAspectFill
        
    }
    
    // MARK: @IBActions
    // view 탭 한 경우 keyboard 내려가는 액션
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        
        searchTextField.resignFirstResponder()
        
    }
    
    // keyboard의 return키 누를 경우 액션
    @IBAction func returnKeyBoardTapped(_ sender: UITextField) {
        
        guard let word = sender.text else { return }
        
        updateButtons(word)
        
    }
    
    
    @IBAction func searchButtonTapped(_ sender: UIButton) {

        guard let word = searchTextField.text else { return }
        
        updateButtons(word)
        
    }
    
    @IBAction func wordButtonTapped(_ sender: UIButton) {
        
        guard let word = sender.titleLabel?.text else {return}
        
        searchWordFromDatabase(word)
        
    }
    
    func addSearchWords(_ word: String) {
        
        if word == "" { return }
        
        if inputWords.count == 4 {
            inputWords.remove(at: 0)
            inputWords.append(word)
            
        } else if inputWords.count < 4 {
            
            inputWords.append(word)
        }
        
        print(inputWords.description)
    }
    
    func putWordsToButtons() {
        
        var count = 0
        
        guard inputWords.count > 0 && inputWords.count < 5  else { return }
        
        inputWords.forEach {
            keywordButtons[count].setTitle( $0, for: .normal)
            keywordButtons[count].isHidden = false
            count += 1
        }
        count = 0
    }

    func searchWordFromDatabase(_ word: String) {
        if wordDataBase.keys.contains(word) {
            meaningLabel.text = wordDataBase[word]
            
        } else {
            meaningLabel.text = "데이터가 없어요... ㅠㅅㅠ"
            
        }
        
    }
    
    func updateButtons(_ word: String) {
        searchTextField.resignFirstResponder()
        addSearchWords(word)
        putWordsToButtons()
        searchWordFromDatabase(word)
        searchTextField.text = ""
    }
    

}

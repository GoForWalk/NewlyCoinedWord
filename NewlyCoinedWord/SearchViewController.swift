//
//  SearchViewController.swift
//  NewlyCoinedWord
//
//  Created by sae hun chung on 2022/07/09.
//

import UIKit

class SearchViewController: UIViewController {

    // MARK: properties
    @IBOutlet weak var searchStackView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet var keywordButtons: [UIButton]!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var addWordMeaningStackView: UIStackView!
    @IBOutlet weak var addWordMeaningTextField: UITextField!
    
    var currentSearchingWord: String = ""
    
    var inputWords : [String] = []
    
    var db: DataBase = DataBase()
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        // 초기 데이터 불러오기
        db.getData()
    }
    
    // MARK: SetUI
    func setUI() {
        setSearchStackViewUI()
        setButtonsUI()
        setMainImage()
        setAddMeaningFieldUI()
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
    
    func setAddMeaningFieldUI() {
        addWordMeaningStackView.isHidden = true
        addWordMeaningTextField.placeholder = "단어의 뜻을 입력해주세요!!"
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
    
    // 검색버튼 누를 때 검색어 기록 버튼 추가 + meaningLabel에서 뜻 검색 기능
    @IBAction func searchButtonTapped(_ sender: UIButton) {

        guard let word = searchTextField.text else { return }
        updateButtons(word)
    }
    
    // 검색어 기록 버튼 클릭 시, 해당 단어 뜻 검색 기능
    @IBAction func wordButtonTapped(_ sender: UIButton) {
        
        guard let word = sender.titleLabel?.text else {return}
        searchWordFromDatabase(word)
    }
    
    // MeaningAddButton 누르면 Database
    @IBAction func meaningAddButtonTapped(_ sender: UIButton) {
        
        guard let word = addWordMeaningTextField.text else { return }
        addWordMeaning(word)
    }
    
    // 데이터베이스에 없는 단어 뜻 추가 가능
    @IBAction func addWordMeaningReturnTapped(_ sender: UITextField) {
        
        guard let word = sender.text else { return }
        addWordMeaning(word)
    }
    
    @IBAction func updateMeaningButtonTapped(_ sender: UIButton) {
        showUpdateAlertController()
        searchWordFromDatabase(currentSearchingWord)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        showDeleteAlertController()
    }
    
    // MARK: Button & MeaningLabel Logic
    func addSearchWords(_ word: String) {
        
        if inputWords.contains(word), word.isEmpty { return }
        
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

    // 단어뜻 검색 기능
    func searchWordFromDatabase(_ word: String) {
        
        currentSearchingWord = word
        if currentSearchingWord.isEmpty { return }
        
        if db.wordMeaning.keys.contains(word) {
            meaningLabel.text = db.getMeaning(word: word)
            addWordMeaningStackView.isHidden = true
        } else {
            meaningLabel.text = "데이터가 없어요... ㅠㅅㅠ"
            addWordMeaningStackView.isHidden = false
        }
    }
    
    func updateButtons(_ word: String) {
        searchTextField.resignFirstResponder()
        addSearchWords(word)
        putWordsToButtons()
        searchWordFromDatabase(word)
        searchTextField.text = ""
        currentSearchingWord = word
    }
    
    // 단어 뜻 추가 로직
    func addWordMeaning(_ wordMeaning: String) {
        
        if wordMeaning.isEmpty { return }
        
        if !currentSearchingWord.isEmpty, !db.wordMeaning.keys.contains(currentSearchingWord) {

            db.saveData(word: currentSearchingWord, meaning: wordMeaning)
            meaningLabel.text = wordMeaning
            
            addWordMeaningTextField.text = ""
            addWordMeaningStackView.isHidden = true
        }
        
        addWordMeaningTextField.resignFirstResponder()
    }

    func showUpdateAlertController() {
        
        guard !currentSearchingWord.isEmpty else { return }
        
        let alert = UIAlertController(title: "단어의 뜻을 수정합니다.", message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "추가하기!", style: .default) { _ in
            
            guard let word = alert.textFields?[0].text else { return }
            self.meaningLabel.text = word
            self.db.saveData(word: self.currentSearchingWord, meaning: word)
        }
        
        let no = UIAlertAction(title: "취소!", style: .default, handler: nil)
        
        alert.addTextField {
            $0.placeholder = "바꿀 뜻을 입력해주세요!"
        }
        alert.addAction(ok)
        alert.addAction(no)
    
        present(alert, animated: true, completion: nil)
    }
    
    func showDeleteAlertController() {
        
        let alert = UIAlertController(title: "데이터를 초기화 하시겠습니까?", message: "삭제된 데이터는 복구할 수 없습니다.", preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "삭제합니다.", style: .destructive) { _ in
            self.db.deleteData()
            self.resetUI()
        }
        let no = UIAlertAction(title: "아니요", style: .default, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(no)
        
        present(alert, animated: true, completion: nil)
    }
    
    func resetUI() {
        inputWords = []
        keywordButtons.forEach {
            $0.setTitle("", for: .normal)
            $0.isHidden = true
        }
        meaningLabel.text = ""
        currentSearchingWord = ""
    }
}

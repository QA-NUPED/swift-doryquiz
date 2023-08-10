//
//  DesempenhoViewController.swift
//  doryQuiz
//
//  Created by Lorena Andrade Silva on 07/08/23.
//

import UIKit

class DesempenhoViewController: UIViewController {
    
    var pontuacao: Int?
    var resultado: String = ""
    var pontuacaoFinal: String = ""
    var questoes : [Questao] = listaQuestoes
    
    @IBOutlet weak var resultadoLabel: UILabel!

    @IBOutlet weak var percentualLabel: UILabel!
    
    
    @IBOutlet weak var botaoReiniciarQuiz: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurarLayout()
        configurarView()
    }
    
    func configurarLayout() {
        navigationItem.hidesBackButton = true
        botaoReiniciarQuiz.layer.cornerRadius = 12.0
    }
    
    func configurarDesempenho() {
        guard let pontuacao = pontuacao else {return}
        resultado = "Você acertou \(pontuacao) de \(questoes.count) questões"
        let percentual = (pontuacao * 100) / questoes.count
        pontuacaoFinal = "Percentual final: \(percentual)%"
    }

   func configurarView() {
        configurarDesempenho()
        resultadoLabel.text = resultado
        percentualLabel.text = pontuacaoFinal
}
    
}

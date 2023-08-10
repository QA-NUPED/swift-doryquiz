//
//  QuestaoViewController.swift
//  doryQuiz
//
//  Created by Lorena Andrade Silva on 07/08/23.
//

import UIKit

class QuestaoViewController: UIViewController {
    
    var pontuacao = 0
    var numeroQuestao = 0
    var questoes : [Questao] = listaQuestoes
    var corBotaoAcerto = UIColor(red: 0.00, green: 0.40, blue: 0.31, alpha: 1.00)
    var corBotaoErro = UIColor(red: 0.52, green: 0.10, blue: 0.11, alpha: 1.00)
    
    
    @IBOutlet weak var tituloQuestaoLabel: UILabel!
    @IBOutlet var botoesRespostas: [UIButton]!
    
    @IBAction func respostaBotaoPressionado(_ sender: UIButton) {
        let usuarioAcertouResposta = verificarResposta(usuarioResposta: sender.tag)
        
        if usuarioAcertouResposta {
            pontuacao += 1
            atualizarBotaoAcerto(sender: sender)
        } else {
            atualizarBotaoErro(sender: sender)
        }
        
        if numeroQuestao < questoes.count - 1 {
            numeroQuestao += 1
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(configurarQuestao), userInfo: nil, repeats: false)
        } else {
            navegaParaTelaDesempenho()
        }
    }

    func verificarResposta(usuarioResposta: Int) -> Bool {
        return questoes[numeroQuestao].respostaCorreta == usuarioResposta
    }

    func atualizarBotaoAcerto(sender: UIButton) {
        sender.backgroundColor = corBotaoAcerto
    }

    func atualizarBotaoErro(sender: UIButton) {
        sender.backgroundColor = corBotaoErro
    }

    func navegaParaTelaDesempenho() {
        performSegue(withIdentifier: "GoTelaDesempenho", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurarLayout()
        configurarQuestao()
    }
    
    
    func configurarLayout() {
            navigationItem.hidesBackButton = true
            tituloQuestaoLabel.numberOfLines = 0
        tituloQuestaoLabel.textAlignment = .center
            for botao in botoesRespostas {
            botao.layer.cornerRadius = 12.0
            }
    }
    
    @objc func configurarQuestao () {
        tituloQuestaoLabel.text = questoes[numeroQuestao].titulo
        for botao in botoesRespostas{
            let tituloBotao = questoes[numeroQuestao].respostas[botao.tag]
            botao.setTitle(tituloBotao, for: .normal)
            botao.backgroundColor = UIColor(red: 0.25, green: 0.43, blue: 0.59, alpha: 1.00)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let desempenhoVC = segue.destination as? DesempenhoViewController
            else { return }
        desempenhoVC.pontuacao = pontuacao
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  QuestaoViewController.swift
//  doryQuizTests
//
//  Created by Lorena Andrade Silva on 10/08/23.
//

import XCTest
@testable import doryQuiz

final class QuestaoViewControllerTest: XCTestCase {
    
    func testVerificarResposta_RespostaCorreta() {
            // Arrange
            let sut = QuestaoViewController()
            let questao = Questao(titulo: "Em frozen, quem foi o primeiro namorado da Ana? ", respostas: ["Sveen","Hans","Kristoff"], respostaCorreta: 1)
            sut.questoes = [questao]
            sut.numeroQuestao = 0
            
            // Act
            let resultado = sut.verificarResposta(usuarioResposta: 1)
            
            // Assert
            XCTAssertTrue(resultado)
        }
        
        func testVerificarResposta_RespostaIncorreta() {
            // Arrange
            let sut = QuestaoViewController()
            let questao = Questao(titulo: "Em frozen, quem foi o primeiro namorado da Ana? ", respostas: ["Sveen","Hans","Kristoff"], respostaCorreta: 1)
            sut.questoes = [questao]
            sut.numeroQuestao = 0
            
            // Act
            let resultado = sut.verificarResposta(usuarioResposta: 0)
            
            // Assert
            XCTAssertFalse(resultado)
        }

}

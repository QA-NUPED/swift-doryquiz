//
//  DesempenhoViewController.swift
//  doryQuizTests
//
//  Created by Lorena Andrade Silva on 09/08/23.
//

import XCTest
@testable import doryQuiz

final class DesempenhoViewControllerTest: XCTestCase {
    
        func testExibirPontuacao() {
            // Arrange
            let sut = DesempenhoViewController()
            
            // Act
            sut.pontuacao = 1
            sut.questoes = [.init(titulo: "", respostas: [ ], respostaCorreta: 0)]
            sut.configurarDesempenho()
            
            // Assert
            XCTAssertEqual(sut.resultado, "Você acertou 1 de 1 questões")
        }
    
    func testExibirPorcentagem() {
        // Arrange
        let sut = DesempenhoViewController()
        
        // Act
        sut.pontuacao = 1
        sut.questoes = [.init(titulo: "", respostas: [ ], respostaCorreta: 0)]
        sut.configurarDesempenho()
        
        // Assert
        let percentualCalculado = (sut.pontuacao! * 100) / sut.questoes.count
        XCTAssertEqual(sut.pontuacaoFinal, "Percentual final: \(percentualCalculado)%")
        
    }
    
    func testPontuacaoNula() {
        // Arrange
        let sut = DesempenhoViewController()
        
        // Act
        sut.pontuacao = nil
        sut.questoes = [.init(titulo: "", respostas: [ ], respostaCorreta: 0)]
        sut.configurarDesempenho()
        
        // Assert
        XCTAssertEqual(sut.resultado, "")
    }
    
    func testPercentualZero() {
        // Arrange
        let sut = DesempenhoViewController()
        
        // Act
        sut.pontuacao = 0
        sut.questoes = [.init(titulo: "", respostas: [ ], respostaCorreta: 0)]
        sut.configurarDesempenho()
        
        // Assert
        let percentualCalculado = (sut.pontuacao! * 100) / sut.questoes.count
        XCTAssertEqual(sut.pontuacaoFinal, "Percentual final: \(percentualCalculado)%")
    }
    
    
     }


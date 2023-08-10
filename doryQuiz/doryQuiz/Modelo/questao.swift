//
//  questao.swift
//  doryQuiz
//
//  Created by Lorena Andrade Silva on 07/08/23.
//

import Foundation

struct Questao {
    var titulo : String
    var respostas: [String]
    var respostaCorreta: Int
}

let listaQuestoes: [Questao] = [
    Questao(titulo: "Onde moram Nemo e seu pai no fundo do mar? ", respostas: ["Em uma anêmona","Em um coral","Em uma concha" ], respostaCorreta: 0),
    Questao(titulo: "Qual foi o primeiro filme da Disney? ", respostas: ["Branca de Neve","Rei Leão","Pinóquio" ], respostaCorreta: 2),
    Questao(titulo: "Em frozen, quem foi o primeiro namorado da Ana? ", respostas: ["Sveen","Hans","Kristoff" ], respostaCorreta: 1),
    Questao(titulo: "Quais personagens da Disney dividem um mesmo prato de espaguete? ", respostas: ["As Aventuras de Bernardo e Bianca","A dama e o vagabundo","Shrek e Fiona" ], respostaCorreta: 1),
    Questao(titulo: "Quem é Merlin? ", respostas: ["Um anão","Um feiticeiro","Um golfinho" ], respostaCorreta: 1),
    Questao(titulo: "Qual é o nome do urso em “Mogli, O Menino Lobo”?", respostas: ["Balu","Simba","Kaa" ], respostaCorreta: 0),
    Questao(titulo: "Qual a doença que a Dory tinha?", respostas: ["Perda de memória temporária","Perda de memória constante","Perda de memória recente" ], respostaCorreta: 2),
]

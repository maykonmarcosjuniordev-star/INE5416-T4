camiseta(amarela).
camiseta(azul).
camiseta(branca).
camiseta(verde).
camiseta(vermelha).

nome(caue).
nome(giovanni).
nome(lucas).
nome(ramon).
nome(silvio).

perfume(amadeirado).
perfume(citrico).
perfume(floral).
perfume(fresco).
perfume(oriental).

preco(100).
preco(150).
preco(200).
preco(250).
preco(300).

companhia(amiga).
companhia(esposa).
companhia(irma).
companhia(mae).
companhia(namorada).

idade(20).
idade(25).
idade(30).
idade(35).
idade(40).

todos_diferentes([]).
todos_diferentes([H|T]) :- not(member(H, T)), todos_diferentes(T).

% Funções Auxiliares Revisadas
ao_lado(X, Y, Lista) :- nextto(X, Y, Lista); nextto(Y, X, Lista).

direita(X, Y, Lista) :- nextto(X, Y, Lista).
esquerda(X, Y, Lista) :- nextto(Y, X, Lista).

a_esquerda(X, Y, Lista) :- nth0(IndexX, Lista, X), nth0(IndexY, Lista, Y), IndexX < IndexY.
a_direita(X, Y, Lista) :- aEsquerda(Y, X, Lista).

entre(X, Y, Z, Lista) :- a_esquerda(X, Y, Lista) ; a_direita(Y, Z, Lista).

solucao(Fila) :-

    Fila = [
        homem(Cor1, Nome1, Preco1, Companhia1, Idade1),
        homem(Cor2, Nome2, Preco2, Companhia2, Idade2),
        homem(Cor3, Nome3, Preco3, Companhia3, Idade3),
        homem(Cor4, Nome4, Preco4, Companhia4, Idade4),
        homem(Cor5, Nome5, Preco5, Companhia5, Idade5)
    ],

    /* O cliente de camiseta Branca está em algum lugar
    entre o Ramon e o cliente de 25 anos, nessa ordem. */
    Nome5 \= ramon,
    Idade1 \= 25,
    Cor1 \= branca,
    Cor5 \= branca,
    entre(homem(_, ramon, _, _, _, _), homem(branca, _, _, _, _, _), homem(_, _, _, _, _, 25), Fila),
    \+ member(homem(branca, ramon, _, _, _, _), Fila),
    \+ member(homem(branca, _, _, _, _, 25), Fila),
    \+ member(homem(_, ramon, _, _, _, 25), Fila),

    /* O homem acompanhado da Esposa escolheu o perfume de R$ 100. */
    member(homem(_, _, _, 100, esposa, _), Fila),

    /* Quem escolheu o perfume de R$ 200 está em uma das pontas. */
    (Preco1 = 200; Preco5 = 200),

    /* Lucas está na quarta posição. */
    Nome4 = lucas,
    Nome1 \= lucas,
    Nome2 \= lucas,
    Nome3 \= lucas,
    Nome5 \= lucas,

    /* O cliente de Verde está exatamente à direita do
     cliente que escolheu o perfume Floral.*/
    direita(homem(verde, _, _, _, _, _), homem(_, _, floral, _, _, _), Fila),

    /* Na quarta posição está o cliente de 30 anos. */
    Idade4 = 30,
    Idade1 \= 30,
    Idade2 \= 30,
    Idade3 \= 30,
    Idade5 \= 30,

    /* O cliente que está acompanhado da Amiga está
    exatamente à esquerda do cliente mais novo. */
    esquerda(homem(_, _, _, _, amiga, _), homem(_, _, _, _, _, 20), Fila),
    Companhia5 \= amiga,
    Idade1 \= 20,
    \+ member(homem(_, _, _, _, amiga, 20), Fila),

    /* O homem de 40 anos escolheu o perfume de R$ 150. */
    member(homem(_, _, _, 150, _, 40), Fila),

    /* Silvio está em algum lugar à esquerda do
    cliente acompanhado da Mãe. */
    a_equerda(homem(_, silvio, _, _, _, _), homem(_, _, _, _, mae, _), Fila),
    Nome5 \= silvio,
    Companhia1 \= mae,
    \+ member(homem(_, silvio, _, _, mae, _), Fila),

    /* O cliente acompanhado da Namorada está em algum lugar
    entre o Ramon e o cliente acompanhado da Esposa, nessa ordem. */
    entre(homem(_, ramon, _, _, _, _), homem(_, _, _, _, namorada, _), homem(_, _, _, _, esposa, _), Fila),
    Companhia1 \= namorada,
    Companhia1 \= esposa,
    Companhia5 \= namorada,
    \+ member(homem(_, ramon, _, _, namorada, _), Fila),
    \+ member(homem(_, ramon, _, _, esposa, _), Fila),

    /* Em uma das pontas está o cliente mais velho. */
    (Idade1 = 40; Idade5 = 40),

    /* Na quarta posição está o cliente de camiseta Vermelha. */
    Cor4 = vermelha,
    Cor1 \= vermelha,
    Cor2 \= vermelha,
    Cor3 \= vermelha,
    Cor5 \= vermelha,

    /* O cliente que escolheu o perfume mais caro está
    em algum lugar à direita do cliente de Branco. */
    a_direita(homem(_, _, _, 300, _, _), homem(branca, _, _, _, _, _), Fila),
    Preco1 \= 300,
    Cor5 \= branca,
    \+ member(homem(branca, _, _, _, _, 300), Fila),

    /* O cliente de 20 anos está ao lado do cliente acompanhado da Esposa. */
    ao_lado(homem(_, _, _, _, _, 20), homem(_, _, _, _, esposa, _), Fila),
    \+ member(homem(_, _, _, _, esposa, 20), Fila),

    /* Quem escolheu o perfume Cítrico tem 35 anos. */
    member(homem(_, _, citrico, _, _, 35), Fila),

    /* Cauê está exatamente à direita do cliente que escolheu o perfume Fresco. */
    direita(homem(_, caue, _, _, _, _), homem(_, _, fresco, _, _, _), Fila),
    Nome1 \= caue,
    Perfume5 \= fresco,
    \+ member(homem(_, caue, _, _, _, fresco), Fila),

    /* Silvio está exatamente à esquerda do cliente que está acompanhado da Irmã. */
    esquerda(homem(_, silvio, _, _, _, _), homem(_, _, _, _, irma, _), Fila),
    \+ member(homem(_, silvio, _, _, irma, _), Fila),
    Companhia1 \= irma,
    Nome5 \= silvio,

    /* Quem escolheu o perfume Amadeirado está em algum lugar
    entre quem escolheu o perfume Floral e o cliente de Vermelho, nessa ordem. */
    entre(homem(_, _, floral, _, _, _), homem(_, _, amadeirado, _, _, _), homem(vermelha, _, _, _, _, _), Fila),
    Perfume5 \= floral,
    Perfume1 \= amadeirado,
    Perfume5 \= amadeirado,
    \+ member(homem(vermelha, _, amadeirado, _, _, _), Fila),
    \+ member(homem(vermelha, _, floral, _, _, _), Fila),

    /* O cliente de camiseta Azul escolheu o perfume de R$ 150. */
    member(homem(azul, _, _, 150, _, _), Fila),

    /* O cliente de camiseta Verde está em algum lugar
    à direita do cliente de camiseta Branca. */
    a_direita(homem(verde, _, _, _, _, _), homem(branca, _, _, _, _, _), Fila),
    Cor1 \= verde,
    Cor5 \= branca,

    /* O cliente que escolheu o perfume Cítrico está em algum lugar
    à esquerda de quem escolheu o perfume de R$ 150. */
    a_esquerda(homem(_, _, citrico, _, _, _), homem(_, _, _, 150, _, _), Fila),
    Perfume5 \= citrico,
    Preco1 \= 150,
    \+ member(homem(_, _, citrico, 150, _, _), Fila),

    /* Testa todas as possibilidades */
    camiseta(Cor1), camiseta(Cor2), camiseta(Cor3), camiseta(Cor4), camiseta(Cor5),
    todos_diferentes([Cor1, Cor2, Cor3, Cor4, Cor5]),

    nome(Nome1), nome(Nome2), nome(Nome3), nome(Nome4), nome(Nome5),
    todos_diferentes([Nome1, Nome2, Nome3, Nome4, Nome5]),

    perfume(Perfume1), perfume(Perfume2), perfume(Perfume3), perfume(Perfume4), perfume(Perfume5),
    todos_diferentes([Perfume1, Perfume2, Perfume3, Perfume4, Perfume5]),

    preco(Preco1), preco(Preco2), preco(Preco3), preco(Preco4), preco(Preco5),
    todos_diferentes([Preco1, Preco2, Preco3, Preco4, Preco5]),

    companhia(Companhia1), companhia(Companhia2), companhia(Companhia3), companhia(Companhia4), companhia(Companhia5),
    todos_diferentes([Companhia1, Companhia2, Companhia3, Companhia4, Companhia5]),

    idade(Idade1), idade(Idade2), idade(Idade3), idade(Idade4), idade(Idade5),
    todos_diferentes([Idade1, Idade2, Idade3, Idade4, Idade5]).

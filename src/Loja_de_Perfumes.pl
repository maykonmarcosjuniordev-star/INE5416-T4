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

% Estrutura da fila
fila([H1, H2, H3, H4, H5]) :-
    homem(H1), homem(H2), homem(H3), homem(H4), homem(H5),
    todos_diferentes([H1, H2, H3, H4, H5]).

homem(homem(Camiseta, Nome, Perfume, Preco, Companhia, Idade)) :-
    camiseta(Camiseta),
    nome(Nome),
    perfume(Perfume),
    preco(Preco),
    companhia(Companhia),
    idade(Idade).

todos_diferentes([]).
todos_diferentes([H|T]) :- not(member(H, T)), todos_diferentes(T).

entre(X, Y, Z, [X, Y, Z, _, _]).
entre(X, Y, Z, [X, Y, _, Z, _]).
entre(X, Y, Z, [X, Y, _, _, Z]).
entre(X, Y, Z, [X, _, Y, _, Z]).
entre(X, Y, Z, [X, _, Y, Z, _]).
entre(X, Y, Z, [X, _, _, Y, Z]).
entre(X, Y, Z, [_, X, Y, Z, _]).
entre(X, Y, Z, [_, X, Y, _, Z]).
entre(X, Y, Z, [_, X, _, Y, Z]).
entre(X, Y, Z, [_, _, X, Y, Z]).

a_esquerda(X, Y, [X | T]) :- member(Y, T).
a_esquerda(X, Y, [_ | T]) :- a_esquerda(X, Y, T).

a_direita(X, Y, Lista) :- a_esquerda(Y, X, Lista).

direita(X, Y, [X, Y | _]).
direita(X, Y, [_ | T]) :- direita(X, Y, T).

esquerda(X, Y, Lista) :- direita(Y, X, Lista).

ao_lado(X, Y, [X, Y | _]).
ao_lado(X, Y, [Y, X | _]).
ao_lado(X, Y, [_ | T]) :- ao_lado(X, Y, T).


/* Regras baseadas nas dicas */

/* O cliente de camiseta Branca está em algum lugar
entre o Ramon e o cliente de 25 anos, nessa ordem. */
restricao_ramon_nao_branca(homem(Camiseta, ramon, _, _, _, _)) :- Camiseta \= branca.
restricao_ramon_nao_25(homem(_, ramon, _, _, _, Idade)) :- Idade \= 25.
restricao_branca_nao_25(homem(branca, _, _, _, _, Idade)) :- Idade \= 25.
restricao_ramon_nao_ponta_direita(fila([_, _, _, _, homem(_, Nome, _, _, _, _)])) :- Nome \= ramon.
restricao_25_nao_ponta_esquerda(fila([homem(_, _, _, _, _, Idade), _, _, _, _])) :- Idade \= 25.
restricao_branca_nao_pontas(fila([homem(branca, _, _, _, _, _), _, _, _, _])) :- false.
restricao_branca_nao_pontas(fila([_, _, _, _, homem(branca, _, _, _, _, _)])) :- false.
restricao_branca_entre_ramon_25(fila([H1, H2, H3, H4, H5])) :-
    entre(nome(_, ramon), camiseta(_, branca), idade(_, 25), [H1, H2, H3, H4, H5]).

/* O homem acompanhado da Esposa escolheu o perfume de R$ 100. */
restricao_esposa_100(homem(_, _, _, 100, esposa, _)).

/* Quem escolheu o perfume de R$ 200 está em uma das pontas. */
regra_dica3(Fila) :- 
    (Fila = fila([H1, _, _, _, _]), preco(H1, 200));
    (Fila = fila([_, _, _, _, H5]), preco(H5, 200)).

/* Lucas está na quarta posição. */
lucas_na_4_p(fila([_, _, _, homem(_, lucas, _, _, _, _), _])) :- true.
lucas_nao_em1(fila([homem(_, lucas, _, _, _, _), _, _, _, _])) :- false.
lucas_nao_em2(fila([_, homem(_, lucas, _, _, _, _), _, _, _])) :- false.
lucas_nao_em3(fila([_, _, homem(_, lucas, _, _, _, _), _, _])) :- false.
lucas_nao_em5(fila([_, _, _, _, homem(_, lucas, _, _, _, _)])) :- false.

/* O cliente de Verde está exatamente à direita do
cliente que escolheu o perfume Floral. */
regra_dica5(fila([H1, H2, H3, H4, H5])) :-
    direita(perfume(_, floral), camiseta(_, verde), [H1, H2, H3, H4, H5]).

/* Na quarta posição está o cliente de 30 anos. */
na_4_com_30_anos(fila([_, _, _, homem(_, _, _, _, _, 30), _])).
nao_na_1_com_30_anos(fila([homem(_, _, _, _, _, 30), _, _, _, _])) :- false.
nao_na_2_com_30_anos(fila([_, homem(_, _, _, _, _, 30), _, _, _])) :- false.
nao_na_3_com_30_anos(fila([_, _, homem(_, _, _, _, _, 30), _, _])) :- false.
nao_na_5_com_30_anos(fila([_, _, _, _, homem(_, _, _, _, _, 30)])) :- false.

/* O cliente que está acompanhado da Amiga está
exatamente à esquerda do cliente mais novo. */
regra_dica7(fila([H1, H2, H3, H4, H5])) :-
    esquerda(companhia(_, amiga), idade(_, 20), [H1, H2, H3, H4, H5]).
amiga_nao_com_o_mais_novo(home(_, _, _, _, amiga, 20)) :- false.
amiga_nao_na_5(fila([_, _, _, _, homem(_, _, _, _, amiga, _)])) :- false.
mais_novo_nao_na_1(fila([homem(_, _, _, _, _, 20), _, _, _, _])) :- false.

/* O homem de 40 anos escolheu o perfume de R$ 150. */
regra_dica8(homem(_, _, _, 150, _, 40)).

/* Silvio está em algum lugar à esquerda do
cliente acompanhado da Mãe. */
regra_dica9(fila([H1, H2, H3, H4, H5])) :-
    a_esquerda(nome(_, silvio), companhia(_, mae), [H1, H2, H3, H4, H5]).
silvio_nao_esta_com_a_mae(homem(_, silvio, _, _, mae, _)) :- false.
silvio_nao_na_5(fila([_, _, _, _, homem(_, silvio, _, _, _, _)])) :- false.
mae_nao_na_1(fila([homem(_, _, _, _, mae, _), _, _, _, _])) :- false.

/* O cliente acompanhado da Namorada está em algum lugar
entre o Ramon e o cliente acompanhado da Esposa, nessa ordem. */
regra_dica10(fila([H1, H2, H3, H4, H5])) :-
    entre(nome(H1, ramon), companhia(_, namorada), companhia(_, esposa), [H1, H2, H3, H4, H5]).
ramon_nao_esta_com_a_esposa(homem(_, ramon, _, _, esposa, _)) :- false.
ramon_nao_esta_com_a_namorada(homem(_, ramon, _, _, namorada, _)) :- false.
esposa_nao_na_1(fila([homem(_, _, _, _, esposa, _), _, _, _, _])) :- false.
namorada_nao_na_5(fila([_, _, _, _, homem(_, _, _, _, namorada, _)])) :- false.
namorada_nao_na_1(fila([homem(_, _, _, _, namorada, _), _, _, _, _])) :- false.

/* Em uma das pontas está o cliente mais velho. */
regra_dica11(Fila) :-
    (Fila = fila([H1, _, _, _, _]), idade(H1, 40));
    (Fila = fila([_, _, _, _, H5]), idade(H5, 40)).

/* Na quarta posição está o cliente de camiseta Vermelha. */
regra_dica12(fila([_, _, _, homem(vermelha, _, _, _, _, _), _])).
nao_na_1_de_vermelho(fila([homem(vermelha, _, _, _, _, _), _, _, _, _])) :- false.
nao_na_2_de_vermelho(fila([_, homem(vermelha, _, _, _, _, _), _, _, _])) :- false.
nao_na_3_de_vermelho(fila([_, _, homem(vermelha, _, _, _, _, _), _, _])) :- false.
nao_na_5_de_vermelho(fila([_, _, _, _, homem(vermelha, _, _, _, _, _)])) :- false.

/* O cliente que escolheu o perfume mais caro está
em algum lugar à direita do cliente de Branco. */
regra_dica13(fila([H1, H2, H3, H4, H5])) :-
    a_direita(camiseta(_, branca), preco(_, 300), [H1, H2, H3, H4, H5]).
de_branco_nao_na_5(fila([_, _, _, _, homem(branca, _, _, _, _, _)])) :- false.
de_300_nao_na_1(fila([homem(_, _, _, 300, _, _), _, _, _, _])) :- false.
de_branco_nao_300(homem(branca, _, _, 300, _, _)) :- false.

/* O cliente de 20 anos está ao lado do cliente acompanhado da Esposa. */
regra_dica14(fila([H1, H2, H3, H4, H5])) :-
    ao_lado(idade(_, 20), companhia(_, esposa), [H1, H2, H3, H4, H5]).
esposa_nao_com_20_anos(homem(_, _, _, _, esposa, 20)) :- false.

/* Quem escolheu o perfume Cítrico tem 35 anos. */
regra_dica15(homem(_, _, citrico, _, _, 35)).

/* Cauê está exatamente à direita do cliente que escolheu o perfume Fresco. */
regra_dica16(fila([H1, H2, H3, H4, H5])) :-
    direita(perfume(_, fresco), nome(_, caue), [H1, H2, H3, H4, H5]).
caue_nao_Fresco(homem(_, caue, fresco, _, _, _)) :- false.
fresco_nao_na_5(fila([_, _, _, _, homem(_, _, fresco, _, _, _)])) :- false.
caue_nao_na_1(fila([homem(_, caue, _, _, _, _), _, _, _, _])) :- false.

/* Silvio está exatamente à esquerda do cliente que está acompanhado da Irmã. */
regra_dica17(fila([H1, H2, H3, H4, H5])) :-
    esquerda(nome(_, silvio), companhia(_, irma), [H1, H2, H3, H4, H5]).
silvio_nao_esta_com_a_irma(homem(_, silvio, _, _, irma, _)) :- false.
irma_nao_na_1(fila([homem(_, _, _, _, irma, _), _, _, _, _])) :- false.

/* Quem escolheu o perfume Amadeirado está em algum lugar
entre quem escolheu o perfume Floral e o cliente de Vermelho, nessa ordem. */
regra_dica18(fila([H1, H2, H3, H4, H5])) :-
    entre(perfume(H1, floral), perfume(_, amadeirado), camiseta(_, vermelha), [H1, H2, H3, H4, H5]).
floral_nao_na_5(fila([_, _, _, _, homem(_, _, floral, _, _, _)])) :- false.
amadeirado_nao_na_1(fila([homem(_, _, amadeirado, _, _, _), _, _, _, _])) :- false.
amadeirado_nao_na_5(fila([_, _, _, _, homem(_, _, amadeirado, _, _, _)])) :- false.
vermelha_nao_na_1(fila([homem(vermelha, _, _, _, _, _), _, _, _, _])) :- false.
vermelha_nao_amadeirado(homem(vermelha, _, amadeirado, _, _, _)) :- false.
vermelha_nao_floral(homem(vermelha, _, floral, _, _, _)) :- false.

/* O cliente de camiseta Azul escolheu o perfume de R$ 150. */
regra_dica19(homem(azul, _, _, 150, _, _)).

/* O cliente de camiseta Verde está em algum lugar
à direita do cliente de camiseta Branca. */
regra_dica20(fila([H1, H2, H3, H4, H5])) :-
    a_direita(camiseta(_, branca), camiseta(_, verde), [H1, H2, H3, H4, H5]).
verde_nao_na_1(fila([homem(verde, _, _, _, _, _), _, _, _, _])) :- false.

/* O cliente que escolheu o perfume Cítrico está em algum lugar
à esquerda de quem escolheu o perfume de R$ 150. */
regra_dica21(fila([H1, H2, H3, H4, H5])) :-
    a_esquerda(perfume(_, citrico), preco(_, 150), [H1, H2, H3, H4, H5]).
citrico_na_5(fila([_, _, _, _, homem(_, _, citrico, _, _, _)])) :- false.
de_150_nao_na_1(fila([homem(_, _, _, 150, _, _), _, _, _, _])) :- false.
citrico_nao_150(homem(_, _, citrico, 150, _, _)) :- false.

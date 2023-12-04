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

% Funções Auxiliares Revisadas
ao_lado(X, Y, Lista) :- nextto(X, Y, Lista); nextto(Y, X, Lista).

direita(X, Y, Lista) :- nextto(X, Y, Lista).
esquerda(X, Y, Lista) :- nextto(Y, X, Lista).

a_esquerda(X, Y, Lista) :- nth0(IndexX, Lista, X), nth0(IndexY, Lista, Y), IndexX < IndexY.
a_direita(X, Y, Lista) :- aEsquerda(Y, X, Lista).

noCanto(X, Lista) :- last(Lista, X).
noCanto(X, [X|_]).

entre(X, Y, Z, Lista) :- a_esquerda(X, Y, Lista) ; a_direita(Y, Z, Lista).

/* Regras baseadas nas dicas */

/* O cliente de camiseta Branca está em algum lugar
entre o Ramon e o cliente de 25 anos, nessa ordem. */
ramon_nao_branca(homem(Camiseta, ramon, _, _, _, _)) :- Camiseta \= branca.
ramon_nao_25(homem(_, ramon, _, _, _, Idade)) :- Idade \= 25.
branca_nao_25(homem(branca, _, _, _, _, Idade)) :- Idade \= 25.
ramon_nao_ponta_direita(fila([_, _, _, _, homem(_, Nome, _, _, _, _)])) :- Nome \= ramon.
ponta_esquerda_nao_25(fila([homem(_, _, _, _, _, Idade), _, _, _, _])) :- Idade \= 25.
branca_nao_em_1(fila([homem(branca, _, _, _, _, _), _, _, _, _])) :- false.
branca_nao_em_2(fila([_, _, _, _, homem(branca, _, _, _, _, _)])) :- false.
branca_entre_ramon_25(fila([H1, H2, H3, H4, H5])) :-
    entre(nome(_, ramon), camiseta(_, branca), idade(_, 25), [H1, H2, H3, H4, H5]).

/* O homem acompanhado da Esposa escolheu o perfume de R$ 100. */
esposa_perfume_de_100(homem(_, _, _, 100, esposa, _)).

/* Quem escolheu o perfume de R$ 200 está em uma das pontas. */
duzentos_em_uma_ponta(Fila) :- 
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
verde_a_exata_direita_do_floral(fila([H1, H2, H3, H4, H5])) :-
    direita(perfume(_, floral), camiseta(_, verde), [H1, H2, H3, H4, H5]).

/* Na quarta posição está o cliente de 30 anos. */
na_4_com_30_anos(fila([_, _, _, homem(_, _, _, _, _, 30), _])).
nao_na_1_com_30_anos(fila([homem(_, _, _, _, _, 30), _, _, _, _])) :- false.
nao_na_2_com_30_anos(fila([_, homem(_, _, _, _, _, 30), _, _, _])) :- false.
nao_na_3_com_30_anos(fila([_, _, homem(_, _, _, _, _, 30), _, _])) :- false.
nao_na_5_com_30_anos(fila([_, _, _, _, homem(_, _, _, _, _, 30)])) :- false.

/* O cliente que está acompanhado da Amiga está
exatamente à esquerda do cliente mais novo. */
amiga_a_exata_esquerda_do_mais_novo(fila([H1, H2, H3, H4, H5])) :-
    esquerda(companhia(_, amiga), idade(_, 20), [H1, H2, H3, H4, H5]).
amiga_nao_com_o_mais_novo(home(_, _, _, _, amiga, 20)) :- false.
amiga_nao_na_5(fila([_, _, _, _, homem(_, _, _, _, amiga, _)])) :- false.
mais_novo_nao_na_1(fila([homem(_, _, _, _, _, 20), _, _, _, _])) :- false.

/* O homem de 40 anos escolheu o perfume de R$ 150. */
o_de_40_anos_escolheu_o_de_150(homem(_, _, _, 150, _, 40)).

/* Silvio está em algum lugar à esquerda do
cliente acompanhado da Mãe. */
silvio_a_esquerda_do_com_a_mae(fila([H1, H2, H3, H4, H5])) :-
    a_esquerda(nome(_, silvio), companhia(_, mae), [H1, H2, H3, H4, H5]).
silvio_nao_esta_com_a_mae(homem(_, silvio, _, _, mae, _)) :- false.
silvio_nao_na_5(fila([_, _, _, _, homem(_, silvio, _, _, _, _)])) :- false.
mae_nao_na_1(fila([homem(_, _, _, _, mae, _), _, _, _, _])) :- false.

/* O cliente acompanhado da Namorada está em algum lugar
entre o Ramon e o cliente acompanhado da Esposa, nessa ordem. */
namorada_entre_ramon_e_a_esposa(fila([H1, H2, H3, H4, H5])) :-
    entre(nome(H1, ramon), companhia(_, namorada), companhia(_, esposa), [H1, H2, H3, H4, H5]).
ramon_nao_esta_com_a_esposa(homem(_, ramon, _, _, esposa, _)) :- false.
ramon_nao_esta_com_a_namorada(homem(_, ramon, _, _, namorada, _)) :- false.
esposa_nao_na_1(fila([homem(_, _, _, _, esposa, _), _, _, _, _])) :- false.
namorada_nao_na_5(fila([_, _, _, _, homem(_, _, _, _, namorada, _)])) :- false.
namorada_nao_na_1(fila([homem(_, _, _, _, namorada, _), _, _, _, _])) :- false.

/* Em uma das pontas está o cliente mais velho. */
de_40_em_uma_ponta(Fila) :-
    (Fila = fila([H1, _, _, _, _]), idade(H1, 40));
    (Fila = fila([_, _, _, _, H5]), idade(H5, 40)).

/* Na quarta posição está o cliente de camiseta Vermelha. */
vermelha_na_4(fila([_, _, _, homem(vermelha, _, _, _, _, _), _])).
vermelha_nao_na_1(fila([homem(vermelha, _, _, _, _, _), _, _, _, _])) :- false.
vermelha_nao_na_2(fila([_, homem(vermelha, _, _, _, _, _), _, _, _])) :- false.
vermelha_nao_na_3(fila([_, _, homem(vermelha, _, _, _, _, _), _, _])) :- false.
vermelha_nao_na_5(fila([_, _, _, _, homem(vermelha, _, _, _, _, _)])) :- false.

/* O cliente que escolheu o perfume mais caro está
em algum lugar à direita do cliente de Branco. */
mais_caro_a_direita_do_branco(fila([H1, H2, H3, H4, H5])) :-
    a_direita(camiseta(_, branca), preco(_, 300), [H1, H2, H3, H4, H5]).
de_branco_nao_na_5(fila([_, _, _, _, homem(branca, _, _, _, _, _)])) :- false.
de_300_nao_na_1(fila([homem(_, _, _, 300, _, _), _, _, _, _])) :- false.
de_branco_nao_300(homem(branca, _, _, 300, _, _)) :- false.

/* O cliente de 20 anos está ao lado do cliente acompanhado da Esposa. */
esposa_ao_lado_do_de_20_anos(fila([H1, H2, H3, H4, H5])) :-
    ao_lado(idade(_, 20), companhia(_, esposa), [H1, H2, H3, H4, H5]).
esposa_nao_com_20_anos(homem(_, _, _, _, esposa, 20)) :- false.

/* Quem escolheu o perfume Cítrico tem 35 anos. */
citrico_tem_35_anos(homem(_, _, citrico, _, _, 35)).

/* Cauê está exatamente à direita do cliente que escolheu o perfume Fresco. */
caue_a_direita_do_fresco(fila([H1, H2, H3, H4, H5])) :-
    direita(perfume(_, fresco), nome(_, caue), [H1, H2, H3, H4, H5]).
caue_nao_Fresco(homem(_, caue, fresco, _, _, _)) :- false.
fresco_nao_na_5(fila([_, _, _, _, homem(_, _, fresco, _, _, _)])) :- false.
caue_nao_na_1(fila([homem(_, caue, _, _, _, _), _, _, _, _])) :- false.

/* Silvio está exatamente à esquerda do cliente que está acompanhado da Irmã. */
silvio_a_exata_esquerda_do_com_a_irma(fila([H1, H2, H3, H4, H5])) :-
    esquerda(nome(_, silvio), companhia(_, irma), [H1, H2, H3, H4, H5]).
silvio_nao_esta_com_a_irma(homem(_, silvio, _, _, irma, _)) :- false.
irma_nao_na_1(fila([homem(_, _, _, _, irma, _), _, _, _, _])) :- false.

/* Quem escolheu o perfume Amadeirado está em algum lugar
entre quem escolheu o perfume Floral e o cliente de Vermelho, nessa ordem. */
amadeirado_entre_floral_e_vermelha(fila([H1, H2, H3, H4, H5])) :-
    entre(perfume(H1, floral), perfume(_, amadeirado), camiseta(_, vermelha), [H1, H2, H3, H4, H5]).
floral_nao_na_5(fila([_, _, _, _, homem(_, _, floral, _, _, _)])) :- false.
amadeirado_nao_na_1(fila([homem(_, _, amadeirado, _, _, _), _, _, _, _])) :- false.
amadeirado_nao_na_5(fila([_, _, _, _, homem(_, _, amadeirado, _, _, _)])) :- false.
vermelha_nao_amadeirado(homem(vermelha, _, amadeirado, _, _, _)) :- false.
vermelha_nao_floral(homem(vermelha, _, floral, _, _, _)) :- false.

/* O cliente de camiseta Azul escolheu o perfume de R$ 150. */
azul_perfume_de_150(homem(azul, _, _, 150, _, _)).

/* O cliente de camiseta Verde está em algum lugar
à direita do cliente de camiseta Branca. */
verde_a_direita_de_branco(fila([H1, H2, H3, H4, H5])) :-
    a_direita(camiseta(_, branca), camiseta(_, verde), [H1, H2, H3, H4, H5]).
verde_nao_na_1(fila([homem(verde, _, _, _, _, _), _, _, _, _])) :- false.

/* O cliente que escolheu o perfume Cítrico está em algum lugar
à esquerda de quem escolheu o perfume de R$ 150. */
citrico_a_esquerda_do_perfume_de_150(fila([H1, H2, H3, H4, H5])) :-
    a_esquerda(perfume(_, citrico), preco(_, 150), [H1, H2, H3, H4, H5]).
citrico_na_5(fila([_, _, _, _, homem(_, _, citrico, _, _, _)])) :- false.
de_150_nao_na_1(fila([homem(_, _, _, 150, _, _), _, _, _, _])) :- false.
citrico_nao_150(homem(_, _, citrico, 150, _, _)) :- false.

/* Solução Final*/

solucao(Fila) :-
    Fila = fila([H1, H2, H3, H4, H5]),
    fila(Fila),
    ramon_nao_branca(H1),
    ramon_nao_branca(H2),
    ramon_nao_branca(H3),
    ramon_nao_branca(H4),
    ramon_nao_branca(H5),
    ramon_nao_25(H1),
    ramon_nao_25(H2),
    ramon_nao_25(H3),
    ramon_nao_25(H4),
    ramon_nao_25(H5),
    branca_nao_25(H1),
    branca_nao_25(H2),
    branca_nao_25(H3),
    branca_nao_25(H4),
    branca_nao_25(H5),
    ramon_nao_ponta_direita(Fila),
    ponta_esquerda_nao_25(Fila),
    branca_nao_em_1(Fila),
    branca_nao_em_2(Fila),
    branca_entre_ramon_25(Fila),
    esposa_perfume_de_100(H1),
    esposa_perfume_de_100(H2),
    esposa_perfume_de_100(H3),
    esposa_perfume_de_100(H4),
    esposa_perfume_de_100(H5),
    duzentos_em_uma_ponta(Fila),
    lucas_na_4_p(Fila),
    lucas_nao_em1(Fila),
    lucas_nao_em2(Fila),
    lucas_nao_em3(Fila),
    lucas_nao_em5(Fila),
    verde_a_exata_direita_do_floral(Fila),
    na_4_com_30_anos(Fila),
    nao_na_1_com_30_anos(Fila),
    nao_na_2_com_30_anos(Fila),
    nao_na_3_com_30_anos(Fila),
    nao_na_5_com_30_anos(Fila),
    amiga_a_exata_esquerda_do_mais_novo(Fila),
    amiga_nao_com_o_mais_novo(H1),
    amiga_nao_na_5(Fila),
    mais_novo_nao_na_1(Fila),
    o_de_40_anos_escolheu_o_de_150(H1),
    o_de_40_anos_escolheu_o_de_150(H2),
    o_de_40_anos_escolheu_o_de_150(H3),
    o_de_40_anos_escolheu_o_de_150(H4),
    o_de_40_anos_escolheu_o_de_150(H5),
    silvio_a_esquerda_do_com_a_mae(Fila),
    silvio_nao_esta_com_a_mae(H1),
    silvio_nao_na_5(Fila),
    mae_nao_na_1(Fila),
    namorada_entre_ramon_e_a_esposa(Fila),
    ramon_nao_esta_com_a_esposa(H1),
    ramon_nao_esta_com_a_namorada(H1),
    esposa_nao_na_1(Fila),
    namorada_nao_na_5(Fila),
    namorada_nao_na_1(Fila),
    de_40_em_uma_ponta(Fila),
    vermelha_na_4(Fila),
    vermelha_nao_na_1(Fila),
    vermelha_nao_na_2(Fila),
    vermelha_nao_na_3(Fila),
    vermelha_nao_na_5(Fila),
    mais_caro_a_direita_do_branco(Fila),
    de_branco_nao_na_5(Fila),
    de_300_nao_na_1(Fila),
    de_branco_nao_300(H1),
    esposa_ao_lado_do_de_20_anos(Fila),
    esposa_nao_com_20_anos(H1),
    citrico_tem_35_anos(H1),
    citrico_tem_35_anos(H2),
    citrico_tem_35_anos(H3),
    citrico_tem_35_anos(H4),
    citrico_tem_35_anos(H5),
    caue_a_direita_do_fresco(Fila),
    caue_nao_Fresco(H1),
    fresco_nao_na_5(Fila),
    caue_nao_na_1(Fila),
    silvio_a_exata_esquerda_do_com_a_irma(Fila),
    silvio_nao_esta_com_a_irma(H1),
    irma_nao_na_1(Fila),
    amadeirado_entre_floral_e_vermelha(Fila),
    floral_nao_na_5(Fila),
    amadeirado_nao_na_1(Fila),
    amadeirado_nao_na_5(Fila),
    vermelha_nao_na_1(Fila),
    vermelha_nao_amadeirado(H1),
    vermelha_nao_floral(H1),
    azul_perfume_de_150(H1),
    azul_perfume_de_150(H2),
    azul_perfume_de_150(H3),
    azul_perfume_de_150(H4),
    azul_perfume_de_150(H5),
    verde_a_direita_de_branco(Fila),
    verde_nao_na_1(Fila),
    citrico_a_esquerda_do_perfume_de_150(Fila),
    citrico_na_5(Fila),
    de_150_nao_na_1(Fila),
    citrico_nao_150(H1).

    
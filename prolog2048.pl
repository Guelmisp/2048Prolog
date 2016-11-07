% Formato da matrix 4x4

% L1C1 L1C2 L1C3 L1C4
% L2C1 L2C2 L2C3 L2C4
% L3C1 L3C2 L3C3 L3C4
% L4C1 L4C2 L4C3 L4C4

%Lista

% [L1C1 L1C2, L1C3, L1C4, L2C1, L2C2, L2C3, L2C4, L3C1, L3C2, L3C3,
% L3C4, L4C1, L4C2, L4C3, L4C5]


%  ********************************
%% START THE GAME - 2048         %%
%  ********************************

inicio :-
		gerar(Matriz),
		mostrar(Matriz),
		intrucoes,
		jogo(Matriz).


%  ********************************
%% AQUI GERAMOS A MATRIX DO JOGO %%
%  ********************************


% Gerando a Matrix do game
% Gera dois valores no inicio, por isso duas clausulas.
gerar(Matriz):-
	novaMatriz([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],M),
	novaMatriz(M,Matriz).

% Troca os zeros da matrix por um 2 ou 4 aleatório
novaMatriz(Matriz, NovaMatriz) :-
	contarZeros(Matriz, Z),
	posicao(Z, P),
	doisOuQuatro(N),
	replaceZero(Matriz, P, N, NovaMatriz).

%  ********************************
%  Auxiliares
%  ********************************

% Contador dos numeros de zeros na lista, resultado em N.
contarZeros([], 0).
contarZeros([H|T], N) :-
	H == 0,
	contarZeros(T, W),
	N is W + 1.
contarZeros([H|T], N) :-
	H \= 0,
	contarZeros(T, N).

% Seleciona aleatoriamento qual posicao do zero sera substituida
posicao(CountZeros, P) :-
	P is random(CountZeros).

% Gera o numero 2 ou 4. 90% de chance de sair o 2.
doisOuQuatro(N) :-
	random_member(N, [2, 2, 2, 2, 2, 2, 2, 2, 2, 4]).

% Aqui e trocado o valor de 0 na posicao de P pelo valor de 2 ou 4 em N.
% clausula sinistra :o - Internet
% replaceZero(List, P, N, NewList)
replaceZero([],_,_,[]).
replaceZero([H1|T1], P, N, [H2|T2]) :-
	H1 == 0,
	P == 0,
	H2 is N,
	replaceZero(T1, -1, N, T2).
replaceZero([H1|T1], P, N, [H2|T2]) :-
	H1 == 0,
	P > 0,
	Pn is P - 1,
	H2 is H1,
	replaceZero(T1, Pn, N, T2).
replaceZero([H1|T1], P, N, [H2|T2]) :-
	H1 == 0,
	P < 0,
	H2 is H1,
	replaceZero(T1, P, N, T2).
replaceZero([H1|T1], P, N, [H2|T2]) :-
	H1 \= 0,
	H2 is H1,
	replaceZero(T1, P, N, T2).


%  ********************************
%% Printar a Matrix              %%
%  ********************************

% Se estiver zerada nao exibe nada
mostrar([]).
mostrar([H|T]) :-
	printNumber(H),
	mostrarC2(T).
mostrarC2([H|T]) :-
	printNumber(H),
	mostrarC3(T).
mostrarC3([H|T]) :-
	printNumber(H),
	mostrarC4(T).
mostrarC4([H|T]) :-
	printNumber(H),nl,
	mostrar(T).

% PrintNumber serve para alinhar a matrix de acordo com o tamanho do N
printNumber(N) :-
	N >= 1000,
	write(' '),write(N).
printNumber(N) :-
	N >= 100,
	write('  '),write(N).
printNumber(N) :-
	N >= 10,
	write('   '),write(N).
printNumber(N) :-
	N == 0,
	write('    _').
printNumber(N) :-
	write('    '),write(N).

%  ********************************
%% Print do Menu do Jogo %%
%  ********************************

intrucoes :-
	nl,write('Esquerda: a, Baixo: s, Cima: w, Direita: d, Mostrar Matrix: b, Sair: q, Ajuda: ?'),nl.

%  ********************************
%%  JOGAR - MOVIMENTOS DO JOGO  %%
%  ********************************

%Realizar movimento
jogo(Matriz) :- .

%Se nao tem mais movimentos validos, acabou o jogo.
jogo(Matriz) :-
	 temJogadas(Matriz),
	 nl, write('VOCE PERDEU! :( '), nl,
	 abort.

%Predicado once verifica se o fato e verdadeiro pelo menos uma vez
%equal avalia se as listas sao iguais.
temJogadas(Matriz) :-
	once(moveEsquerda(Matriz, X)),
	equal(Matriz, X),
	once(moveDireita(Matriz, Y)),
	equal(Matriz, Y),
	once(moveCima(Matriz, Z)),
	equal(Matriz, Z),
	once(moveBaixo(Matriz, W)),
	equal(Matriz,W).


% Verifica se duas listas sao iguais
equal([],[]).
equal([H1|T1],[H2|T2]) :-
	H1 == H2,
	equal(T1,T2).


%Verificar se ganhou
jogo(Matriz) :-
	max_list(Matriz, 64),
	nl, write('VOCE VENCEUUUUUUUUU!!!!!'),nl,
	abort.


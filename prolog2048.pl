% Formato da matrix 4x4

% L1C1 L1C2 L1C3 L1C4
% L2C1 L2C2 L2C3 L2C4
% L3C1 L3C2 L3C3 L3C4
% L4C1 L4C2 L4C3 L4C4

%Lista

% [L1C1 L1C2, L1C3, L1C4, L2C1, L2C2, L2C3, L2C4, L3C1, L3C2, L3C3,
% L3C4, L4C1, L4C2, L4C3, L4C5]

%Para usar as rotacoes na matriz
:- use_module(library(clpfd)).


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
%%  JOGAR  %%
%  ********************************

%Realizar movimento
jogo(Matriz) :- 
	n, write('Sua escolha? '),
	get_single_char(X),
	move(Matriz, X, B),
	%verifica se o movimento e igual
	(equal(Matriz, B) ->
		(write('Movimento nao valido para essa direcao.'),nl,jogo(Matriz)) ;
		(novaMatriz(B,NovaMatriz),mostrar(NovaMatriz),jogo(NovaMatriz))).

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

%  ********************************
%%  MOVIMENTOS  %%
%  ********************************

% Verifica o que o usuario digitou

%Para Cima
% 199 = w (Ascii)
move(Matriz, 119, NovaMatriz) :-
	write('Para cima'), nl, nl,
	once(moveCima(Matriz, NovaMatriz)).

%Para Baixo
% 115 = s (Ascii)
move(Matriz, 115, NovaMatriz) :-
	write('Para baixo'), nl, nl,
	once(moveCima(Matriz, NovaMatriz)).

%Para Esquerda
% 97 = a (Ascii)
move(Matriz, 97, NovaMatriz) :-
	write('Para esquerda'), nl, nl,
	once(moveCima(Matriz, NovaMatriz)).

%Para Direita
% 100 = d (Ascii)
move(Matriz, 100, NovaMatriz) :-
	write('Para direita'), nl, nl,
	once(moveCima(Matriz, NovaMatriz)).

%Sair
% 113 = q (Ascii)
move(_, 113, _) :-
	write('Saindo'), nl, nl,
	abort.

%Ajuda
move(Matriz, 63, _) :-
	write('Ajuda'), nl,
	intrucoes,
	jogo(Matriz)
	abort.

% Mostrar matriz
move(Matriz, 98, _) :-
	write('exibir matriz'),nl,
	mostrar(Matriz), game(Matriz).

% Qualquer outro caracter
move(Matriz, _, _) :-
	write('Movimento INVALIDO'),nl,
	game(Matriz).

% Movimentos

moveCima(Matriz, NovaMatriz) :-
	%Rotaciona para direita
	rotate_clockwise(Matriz, 1, Aux1),
	moveDireita(Aux1, Aux2),
	%Rotaciona para esquerda, por isso -1
	rotate_clockwise(Aux2, -1, NovaMatriz).

moveBaixo(Matriz, NovaMatriz) :-
	rotate_clockwise(Matriz, -1, Aux1),
	moveDireita(Aux1, Aux2),
	rotate_clockwise(Aux2, 1, NovaMatriz).

moveEsquerda(Matriz, NovaMatriz) :-
	%Rotacao -180
	rotate_clockwise(Matriz, -2, Aux1),
	moveDireita(Aux1, Aux2),
	rotate_clockwise(Aux2, 2, NovaMatriz).

%So implementa os movimentos para direita
%O restante rotaciona a matriz e move para direita
moveDireita([], []).

% X X X X -> 0 0 2X 2X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X1 \= 0,
	X3 \= 0,
	X1 == X2,
	X3 == X4,
	N4 is X3 + X4,
	N3 is X2 + X1,
	N2 is 0,
	N1 is 0,
	moveDireita(X,N).

% X X X Y -> 0 X 2X Y
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X2 \= 0,
	X4 \= 0,
	X1 == X2,
	X3 == X4,
	N4 is X4,
	N3 is X3 + X2,
	N2 is X1,
	N1 is 0, 
	moveDireita(X,N).

% X X Y Z -> 0 2X Y Z
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X1 \= 0,
	X1 == X2,
	X3 \= 0,
	N4 is X4,
	N3 is X3,
	N2 is X1 + X2,
	N1 is 0, 
	moveDireita(X,N).

% X Y Z Z -> 0 X Y 2Z
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X1 \= 0,
	X2 \= 0,
	X1 \= X2,
	X2 \= X3,
	X3 == X4,
	N4 is X4 + X3,
	N3 is X2,
	N2 is X1,
	N1 is 0, 
	moveDireita(X,N).

% X Y Y Z -> 0 X 2Y Z
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X1 \= 0,
	X2 \= 0,
	X2 == X3,
	N4 is X4,
	N3 is X2 + X3,
	N2 is X1,
	N1 is 0, 
	moveDireita(X,N).

% X 0 0 0 -> 0 0 0 X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X2 == 0,
	X3 == 0,
	X4 == 0,
	N4 is X1,
	N3 is 0,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% X X 0 0 -> 0 0 0 2X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X3 == 0,
	X4 == 0,
	X1 == X2,
	N4 is X1 + X2,
	N3 is 0,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% X Y 0 0 -> 0 0 X Y
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X3 == 0,
	X4 == 0,
	N4 is X2,
	N3 is X1,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% 0 X 0 X -> 0 0 0 2X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X1 == 0,
	X3 == 0,
	X2 == X4,
	N4 is X2 + X4,
	N3 is 0,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% 0 X 0 Y -> 0 0 X Y
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X1 == 0,
	X3 == 0,
	N4 is X4,
	N3 is X2,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% Y X X 0 -> 0 0 Y 2X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 == 0,
	X2 == X3,
	N4 is X2 + X3,
	N3 is X1,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% Z X Y 0 -> 0 Z X Y
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 == 0,
	X3 \= 0,
	X2 \= 0,
	X1 \= 0,
	X1 \= X2,
	X3 \= X4,
	N4 is X3,
	N3 is X2,
	N2 is X1,
	N1 is 0, 
	moveDireita(X,N).

% Y Y X 0 -> 0 0 2Y X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 == 0,
	X3 \= 0,
	X1 == X2,
	N4 is X3,
	N3 is X2 + X1,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% Y Y 0 X -> 0 0 2Y X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 == 0,
	X1 == X2,
	N4 is X4,
	N3 is X2 + X1,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% Y X 0 X -> 0 0 Y 2X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 == 0,
	X4 == X2,
	N4 is X4 + X2,
	N3 is X1,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% Z Y 0 X -> 0 Z Y X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 == 0,
	X2 \= 0,
	N4 is X4,
	N3 is X2,
	N2 is X1,
	N1 is 0, 
	moveDireita(X,N).

% X 0 0 X -> 0 0 0 2X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 == 0,
	X2 == 0,
	X1 == X4,
	N4 is X1 + X4,
	N3 is 0,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% X 0 0 Y -> 0 0 X Y
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 == 0,
	X2 == 0,
	N4 is X4,
	N3 is X1,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% X 0 0 X -> 0 0 0 2X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 == 0,
	X2 == 0,
	X1 == X4
	N4 is X4 + X1,
	N3 is 0,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% X 0 0 Y -> 0 0 X Y
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 == 0,
	X2 == 0,
	N4 is X4,
	N3 is X1,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% Y 0 X X -> 0 0 Y 2X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 == X4,
	X2 == 0,
	N4 is X4 + X3,
	N3 is X1,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% Y 0 Y X -> 0 0 2Y X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 \= 0,
	X3 \= X4,
	X2 == 0,
	X1 == X3,
	N4 is X4,
	N3 is X1 + X3,
	N2 is 0,
	N1 is 0, 
	moveDireita(X,N).

% Z 0 Y X -> 0 Z Y X
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 \= 0,
	X2 == 0,
	N4 is X4,
	N3 is X3,
	N2 is X1,
	N1 is 0, 
	moveDireita(X,N).

% X Y Z W -> X Y Z W
moveDireita([X1,X2,X3,X4|X]), [N1,N2,N3,N4|N] :-
	X4 \= 0,
	X3 \= 0,
	X2 \= 0,
	N4 is X4,
	N3 is X3,
	N2 is X2,
	N1 is X1, 
	moveDireita(X,N).

%  ********************************
%%  ROTACOES NA MATRIZ  %%
%  ********************************

%usa a biblioteca clpfd
rotate_clockwise(Matrix, N, Rotated) :-
    N_mod_4 #= N mod 4,
    rotate_clockwise_(N_mod_4, Matrix, Rotated).

rotate_clockwise_(0, M, M).
rotate_clockwise_(1, M, R) :-
    transpose(M, R0),
    maplist(reverse, R0, R).
rotate_clockwise_(2, M, R) :-
    reverse(M, R0),
    maplist(reverse, R0, R).
rotate_clockwise_(3, M, R) :-
    transpose(M, R0),
    reverse(R0, R).

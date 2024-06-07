shape(Sol) :-
Sol = [[1,N1,C1],[2,N2,C2],[3,N3,C3],[4,N4,C4]],

swap([circle,square,romb,triangle],[N1,N2,N3,N4]),
swap([red,blue,white,green],[C1,C2,C3,C4]),

not(member([_,circle,white],Sol)), %ограничение 1 - круг не белый и не зеленый
not(member([_,circle,green],Sol)),
 
not(member([_,triangle,blue],Sol)), %органичение 3 - треугольник не синий и не зеленый
not(member([_,triangle,green],Sol)),
 
member([SF,_,blue],Sol), member([RB,romb,_],Sol), member([KF,_,red],Sol),
(SF < RB, SF > KF ; SF > RB, SF < KF), %ограничение 2 - синяя фигура между ромбом и красной фигурой
 
member([KV,square,_],Sol), member([TK,triangle,_],Sol), member([BL,_,white],Sol),
(KV < TK, KV > BL ; KV > TK, KV < BL). %органичение 4 - квадрат между треугольником и белой фигурой
 
swap([],[]).
swap([X|L],P):-swap(L,L1),insert(X,L1,P).
insert(X,L1,L2):-del(X,L2,L1).
del(X,[X|T],T).
del(X,[H|T],[H|T1]):-del(X,T,T1).
 
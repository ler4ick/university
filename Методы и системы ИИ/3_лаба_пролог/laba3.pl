:-dynamic
reported/2.

operators:-
    op(950, xfx, then),
    op(960, fx, if),
    op(970, xfx, '::').
:-operators.


find1(H, Steck, reported(H)):-reported(H, yes).
find1(H, Steck, reported(H)):-requested(H), not(reported(H,_)), ask(H, Steck).

find1(H, Steck, Fact :: H):-Fact :: H.

find1(H, Steck, Rule :: if D1 then H):-
    Rule :: if H1 then H,
    find(H1, [Rule | Steck], D1).

find([], Steck, Tree):-Tree=[].
find([H1|T], Steck, [Tree1 | Tree]):-
    find1(H1, Steck, Tree1), find(T, Steck, Tree).

requested(H):-Fact :: attribute(H).

ask(H, Steck):-write(H), write('?'), nl, read(O), answer(H, O, Steck).

answer(H, yes, Steck):-assert(reported(H, yes)),!.
answer(H, no, Steck):-assert(reported(H, no)),!, fail.

answer(H, why, []):-!,write(' You are asking too many questions'), nl, ask(H,[]).

answer(P, why, [H]):- !,write(' my hypothesis: '), write(H), nl, ask(P,[]).

answer(H, why, [Rule | Steck]):-!,
        Rule :: if H1 then H2,
        write(' trying to prove'),
        write(H2), nl,
        write(' with help of rule: '),
        write(Rule), nl,
        ask(H, Steck).

how(H, Tree):-how1(H,Tree), !.

how(H,_):- write(H), tab(2), write(' not proved'), nl.

how1(H,_):- reported(H, _),!,
            write(H),write(' was vvedeno '), nl.

how1(H, Fact :: H):-!,
            write(H),write(' is the fact '), write(Fact), nl.

how1(H, [Rule :: if _ then H]):-!,
            write(H), write(' was proved with the help of rule'), nl,
            Rule :: if H1 then H,
            show_rule(Rule :: if H1 then H).

how1(H, [Rule :: if Tree then _]):-how(H,Tree).

how1(H,[]):-!.
how1(H, [D1|D2]):-how(H,[D1]),!;
                  how1(H, D2).

show_rule(Rule :: if H1 then H):-

    write(Rule), write(':'), nl,
    write('if '), write(H1), nl,
    write('then '), write(H), nl.

init:-retractall(reported(_,_)).

start:-
        reconsult('F:/db.pl'),
        info,
        go_exp_sys.

go_exp_sys:- init,
             Fact :: hypothesis(H),
             find([H], [H], Tree),
             write(' solution: '), write(H), nl,
             explain(Tree),
             back.

explain(Tree):- write(' shall I explain ? [aim/no]: '), nl, read(H),
                (H\=no,!,how(H,Tree), explain(Tree));!.

back:- write('Shall we continue to find the solution [yes/no] ?: '), nl, read(no).
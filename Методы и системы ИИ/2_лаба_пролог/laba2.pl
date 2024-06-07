:- use_module(library(clpfd)).
solve :-
  Obj = [Sofa, Suitcase, Bag, Picture, Basket, Vase, SmallDog, BigDog],

  Sofa #= Suitcase + Bag,
  Sofa #= Picture + Vase,
  Picture #= Basket,
  Picture #= Vase,
  Picture #> SmallDog,
  BigDog + Bag #> Sofa,
  BigDog + Suitcase #> Sofa,

  % Поиск решения
  my_label(Obj),

  % Вывод решения
  format('Sofa: ~d ~n', [Sofa]),
  format('Suitcase: ~d ~n', [Suitcase]),
  format('Bag: ~d ~n', [Bag]),
  format('Picture: ~d ~n', [Picture]),
  format('Basket: ~d ~n', [Basket]),
  format('Vase: ~d ~n', [Vase]),
  format('Small Dog: ~d ~n', [SmallDog]),
  format('Big Dog: ~d ~n', [BigDog]).

my_label([]).
my_label([Var | Vars]) :-
  between(1, 10, Var),
  my_label(Vars).

%===============вспомогательный предикат========================================
% цикл повторения выполнения Цели заданное число раз (N)
rep(Aim,1):-Aim.
rep(Aim,N):-
not(not(Aim)), %стирание предыдущих подстановок 
M is N-1,rep(Aim,M).


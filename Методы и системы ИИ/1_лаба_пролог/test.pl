:-dynamic

student/5,
marks/3.

start:- menu. %предикат для запуска программы
%0============= отображение меню ==============================================
menu:- 

repeat, nl,
    write('*******************************'),nl,
    write('* 1. Correct *'),nl,
    write('* 2. Search *'),nl,
    write('* 3. Exit *'),nl,
    write('* 4. Watch *'),nl,
    write('* 5. Load *'),nl,
    write('*******************************'), nl ,nl,
    read(C),nl, 
    proc(C), 
    C=3, 
    !. %Иначе успешное завершение

%----------------Корректировка 
proc(1):-
    write('Write students number: '), nl, read(N),
    retract(student(N, _, _, _, marks(_, _, _))),
    write('Write students FIO: '), nl, read(FIO),
    write('Write students birth year: '), nl, read(Birth_year),
    write('Write students study year: '), nl, read(Stud_year),
    write('Write students phisics mark: '), nl, read(Ph),
    write('Write students math mark: '), nl, read(M),
    write('Write students programming mark: '), nl, read(Pr),
    assertz(student(N, FIO, Birth_year, Stud_year, marks(Ph, M, Pr))),
    write(N),
    write(': student was changed.').

%----------------Вывод 
proc(2):-
    student(N, FIO, Birth_year, Study_year, marks(Ph, M, Pr)),
    (Ph = '5', M = '4', Pr = '5';
    Ph = '4', M = '5', Pr = '5';
    Ph = '5', M = '5', Pr = '4'),
    %student(N, FIO, Birth_year, Study_year, marks(Ph, M, Pr)),
    nl,
    format('N: ~w, FIO: ~w, birth_year: ~w study_year: ~w marks: (~w, ~w, ~w) ~n', [N, FIO, Birth_year, Study_year, Ph, M, Pr]),
    fail,
    !; %отсечение альтернативы и завершение
	write('No more students'). %вывод сообщения о безуспешном удаленииtrue.
%-----------Выход--------------
proc(3):- retractall(student(_, _, _, _, marks(_, _, _))), write('Goodbye').

proc(4):-
    student(N, FIO, Birth_year, Study_year, marks(Ph, M, Pr)),
    nl,
    format('N: ~w, FIO: ~w, birth_year: ~w study_year: ~w marks: (~w, ~w, ~w) ~n', [N, FIO, Birth_year, Study_year, Ph, M, Pr]),
    fail;
    true.

proc(5):-
see('D:/testlab.txt'),
	retractall(student(_, _, _, _, marks(_, _, _))),
	db_load,
	seen,
	write('DB was loaded from file'), nl. 
%загрузка термов в БД из открытого вх. потока 
db_load:- 
	read(Term),
	(Term == end_of_file, !;
	assertz(Term),
	db_load).


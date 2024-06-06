:-dynamic
(zodiac/3, data/3, zodiac_s/3, data_s/3).

start:- menu. 
%============= отображение меню ==============================================
menu:-
repeat, nl,
    write('*******************************'),nl,
    write('* 1. Add record *'),nl,
    write('* 2. Delete record *'),nl,
    write('* 3. Show records *'),nl,
    write('* 4. Save DB *'),nl,
    write('* 5. Load DB *'),nl,
    write('* 6. Relational algebra operations *'),nl,
    write('* 7. Correction *'),nl,
    write('* 8. Show selection *'),nl,
    write('* 9. Exit *'),nl,
    write('*******************************'), nl ,nl,
    read(C),nl, 
    proc(C), 
    C=9, %Если С не равно 9, то авт. возврат к repeat
    !. %Иначе успешное завершение

%1------------------добавить новый элемент в БД-------------------------------
proc(1):- 
    write('FI: '), nl, read(FI),
    write('Zodiak sign: '), nl, read(Sign),
    write('Data: '), nl, 
    write('day '), nl, read(Day),
    write(' mounth '), nl, read(Mounth),
    write(' year '), nl, read(Year),
    assertz(zodiac(FI, Sign, data(Day, Mounth, Year))),
    write(' Record added to DB ').
    get0(C).

%2------------------удалить элемент-------------------------------------------
proc(2):-
    write('Write the FI of the person: '), nl, read(FI),
    write('Write zodisc sign of the person: '), nl, read(Sign),
    write('Write date of birth of the person: '), nl, 
    write('day '), nl, read(Day),
    write(' mounth '), nl, read(Mounth),
    write(' year '), nl, read(Year),
    retract(zodiac(FI, Sign, data(Day, Mounth, Year))),
    write(' The record was successfully deleted '),
    get0(C), 
    !; %отсечение альтернативы и завершение
	write('The record was not found'), nl, 
    get0(C). 

%3------------------просмотр БД-------------------------------------------------
proc(3):-
    zodiac(FI, Sign, data(Day, Mounth, Year)), nl,
    %format('FI: ~w, Sign: ~w, Day: ~w, Mounth: ~w, Year: ~w~n', [FI, Sign, Day, Mounth, Year]),
    write('Name: '), write(FI), nl,
    write('Zodiak sign: '), write(Sign), nl,
    write('Birth date: '), write(Day), write("/"), write(Mounth), write("/"), write(Year), nl,
    fail;
    true.

%4-----------------сохранение БД в файл-----------------------------------------
proc(4):-
    tell('C:/aaTemp/lab1.txt'), %открытие вых. потока 
    save_db(zodiac(FI, Sign, data(Day, Mounth, Year))), %сохранение терма
    told, %закрытие вых. потока
    write(' DB was saved '),nl.
    %сохранение терма в открытом файле
    save_db(Term):- %сохранение терма (факта!) Term в БД
    Term, %отождествление терма с термом в БД 
    write(Term), %запись терма
    write('.'),nl, %запись точки в конце терма
    fail; %неудача с целью поиска след. варианта
    true. %завершение, если вариантов отождествления нет

%5-----------------загрузка БД из файла-----------------------------------------
proc(5):- 
	
    see('C:/aaTemp/lab1.txt'),
	retractall(zodiac(_,_,data(_,_,_))),
	db_load,
	seen,
	write('DB was loaded from file'), nl. 
%загрузка термов в БД из открытого вх. потока 
db_load:- 
	read(Term),
	(Term == end_of_file, !;
	assertz(Term),
	db_load).

%6------------операции реляционной алгебры--------------------------------------
proc(6):-
    nl,
    retractall(zodiac_s(_, _, data(_, _, _))), %необходимая очисточка, чтобы не копилось после нескольких использований пункта 6
        
    %собираем записи, где знак зодиака телец
        
    write('Formation of the r1 relationship:_zodiacs(of the Auchan store '), nl,
    subset_of_zodiacs(taurus,R1), %R1 - список сотрудников филиала 1
    list_in_base(R1), %добавление элементов из R1 в базу данных
    write_list(R1),nl, %вывод списка R1 на экран
         
    %собираем записи, где знак зодиака рак
        
    write('Formation of the r2 relationship:_zodiacs( the Oksana store '), nl,
    subset_of_zodiacs(cancer,R2), %R2 - список сотрудников филиала 2
    list_in_base(R2), %добавление элементов из R2 в базу данных
    write_list(R2),nl, %вывод списка R2 на экран
            
    %Объединение - вывод информации о людях со знаком зодиака телец или рак
        
    write('Combined ratio g1_ or g2: '), nl,
    union(Rez1), %Rez1 - список продуктов магазина1 или 2
    write_list(Rez1),nl,
            
    %Пересечение - вывод тех имен, которые встречаются и в знаке тельца, и в знаке рака
        
    write('The intersection of the relations g1_ and g2: '), nl,
    intersection(Rez2), %Rez2 - список сотрудников 2-х филиалов 
    write_list(Rez2),nl,
            
    %Разница - выводятся те тельцы, чьи имена не встречались в знаке рак
    write('The difference in the ratio r1-r2: '), nl,
    difference(Rez3), %Rez3-список сотрудников филиала 1 без фил.2
    write_list(Rez3),nl,
    R2 = [], R1 = [], Rez1 = [], Rez2 = [], Rez3 = [],
         
    write('Enter any character'),nl,
    get0(C). %Ожидание ввода символа
        

subset_of_zodiacs(Sign,R):-
    bagof(zodiac_s(FI, Sign, data(Day, Mounth, Year)),
    zodiac(FI, Sign, data(Day, Mounth, Year)), R).
         
    %правило объединения отношений - r1 или r2
    
    union_r1_r2(X1, X2, data(X3,X4,X5)):-
        zodiac_s(X1, taurus, data(X3,X4,X5)),X2=taurus;
        zodiac_s(X1, cancer, data(X3,X4,X5)),X2=cancer.
        
        
    union(Rez):-
        bagof(zodiac_s1_or_s2(X1, X2, data(X3,X4,X5)),
            union_r1_r2(X1, X2, data(X3,X4,X5)), %условие вкл. в список
            Rez).
        
        %одно и то же имя в двух знаках зодиака
    intersection_r1_r2(X11, X12, X13, X14, X15, X22, X23, X24, X25):-
        zodiac_s(X11, taurus, data(X13,X14,X15)),X12=taurus,
        zodiac_s(X11, cancer, data(X23,X24,X25)),X22=cancer.
        
        
    intersection(Rez):-
        bagof(zodiac_s1_and_s2(X11, X12, X13, X14, X15, X22, X23, X24, X25),
        intersection_r1_r2(X11, X12, X13, X14, X15, X22, X23, X24, X25), 
        Rez). 
        
    difference_r1_r2(X11, X13, X14,X15):-
        zodiac_s(X11, taurus, data(X13,X14,X15)),X12=taurus,
        not(zodiac_s(X11, cancer, data(X23,X24,X25))),X22=cancer.
        
    difference(Rez):-
        bagof(zodiac_s1_and_no_s2(X11, X13, X14,X15),
        difference_r1_r2(X11, X13, X14,X15), %условие вкл. в список
        Rez). 
        
        %добавление термов из списка [H|T] в БД 
    list_in_base([]).
    list_in_base([H|T]):-
        H=zodiac_s(FI, Sign, data(Day, Mounth, Year)),
        assertz(zodiac_s(FI, Sign, data(Day, Mounth, Year))),
        list_in_base(T). %Рекурсивный вызов для след. терма
        %вывод элементов списка [H|T] в каждой строке
    write_list([]).
    write_list([H|T]):-write(H),nl,write_list(T).

%7----------------Корректировка данных по месяцу рождения
proc(7):-
    write(' Enter the month of birth: '), nl, read(Data),
    write(' Write new record: '), nl, read(FI), nl, read(Sign), nl, read(Day), nl, read(Month), nl, read(Year),
    retract(zodiac(_, _, data(_, Data, _))),
    assertz(zodiac(FI, Sign, data(Day, Month, Year))),
    write(' The record was changed ').

%8----------------Вывод информации о людях, родившихся в выбранный месяц
proc(8):-
    write('Enter mounth: '),
    read(Month), nl,
    print_people(Month).

    % Предикат, который выводит информацию о людях, родившихся в заданном месяце
    print_people(Month) :-
        zodiac(Name, Zodiac, data(Day, Month, Year)),
        write('FI: '), write(Name), nl,
        write('Zodiak: '), write(Zodiac), nl,
        write('Birthday: '), write(Day), write('/'), write(Month), write('/'), write(Year), nl,
        nl,
        fail.

%9-----------Выход--------------
proc(9):-
    write('End'),nl.

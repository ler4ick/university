%====================ВНИМАНИЕ============================================
%открываем файлик, создаем новый терминал
%пишем в него swipl
%затем consult("название-файла.pl"). - обязательно всё, что пишем, завершаем точкой.
%при любом изменении в файле пишем в терминале consult("название-файла.pl").
%чтобы запустить прогу, пишем start.
%===================СПАСИБО ЗА ВНИМАНИЕ==================================

:-dynamic
product/3, product_s/3.

student(1, ivanov_Petr, 2003, 2020, marks(5, 4, 4)).
student(2, creepy_Basta, 2002, 2020, marks(4, 4, 4)).
student(3, petrov_Ivan, 2001, 2020, marks(5, 5, 4)).
student(4, ivanov_Dmitriy, 2003, 2020, marks(5, 4, 4)).
student(5, ivanov_Kirill, 2003, 2020, marks(5, 4, 4)).


start:- menu. %предикат для запуска программы
%0============= отображение меню ==============================================
menu:-
repeat, nl,
    write('*******************************'),nl,
    write('* 1. Add *'),nl,
    write('* 2. Delete *'),nl,
    write('* 3. Watch *'),nl,
    write('* 4. Load *'),nl,
    write('* 5. Save *'),nl,
    write('* 6. Operat. rel. alg. *'),nl,
    write('* 7. Correct *'),nl,
    write('* 8. Search *'),nl,
    write('* 9. Exit *'),nl,
    write('*******************************'), nl ,nl,
    read(C),nl, 
    proc(C), 
    C=9, %Если С не равно 9, то авт. возврат к repeat
    !. %Иначе успешное завершение
%0----------------------------------------------------------------------------
%1------------------добавить новый элемент в таблицу--------------------------
proc(1):- 
    write('Name: '), nl, read(Prod),
    write('Shop: '), nl, read(Shop),
    write('Price: '), nl, read(Price),
    assertz(product(Prod, Shop, Price)),
    write(Prod),
    write(' added to DB.').
    get0(C).

%2------------------удалить элемент-------------------------------------------
proc(2):-
    write('Write the name of product: '), nl, read(Prod),
    write('Write the name of the shop: '), nl, read(Shop),
    write('Price: '), nl, read(Price),
    retract(product(Prod, Shop, Price)),
    write('It was successfully deleted.'),

    get0(C), %ожидание ввода символа
    !; %отсечение альтернативы и завершение
	write('There is no '), %вывод сообщения о безуспешном удалении
	write('product in DB'),nl, 
	write('Write any tab'),nl,
    get0(C). %ожидание ввода символа

%3------------------просмотр----------------------------------------------------
proc(3):-
    product(Prod, Shop, Price),
    nl,
    format('Name: ~w, Shop: ~w, Price: ~w~n', [Prod, Shop, Price]),
    %write('Название товара: '), write(Prod), nl,
    %write('Название магазина: '), write(Shop), nl,
    %write('Цена товара: '), write(Price), nl,
    fail;
    true.
%4========== загрузка БД из файла ===============================================
proc(4):- 
	see('D:/1lab.txt'),
	retractall(product(_,_,_)),
	db_load,
	seen,
	write('DB was loaded from file'), nl. 
%загрузка термов в БД из открытого вх. потока 
db_load:- 
	read(Term),
	(Term == end_of_file, !;
	assertz(Term),
	db_load).

%5========== сохранение БД в файле ============================================
proc(5):-
    tell('D:/1lab.txt'), %открытие вых. потока 
    save_db(product(Prod, Shop, Price)), %сохранение терма
    told, %закрытие вых. потока
    write('DB was saved in file'),nl.

%сохранение терма в открытом файле
save_db(Term):- %сохранение терма (факта!) Term в БД
    Term, %отождествление терма с термом в БД 
    write(Term), %запись терма
    write('.'),nl, %запись точки в конце терма
    fail; %неудача с целью поиска след. варианта
    true. %завершение, если вариантов отождествления нет

%6------------операции реляционной алгебры--------------------------------------
proc(6):-
nl,
    retractall(product_s(_, _, _)), %необходимая очисточка, чтобы не копилось после нескольких использований пункта 6

    %собираем записи, где магазин - Ашан

    write('Formation of the r1 relationship: products of the Auchan store '), nl,
    subset_of_products(ashan,R1), %R1 - список сотрудников филиала 1
    list_in_base(R1), %добавление элементов из R1 в базу данных
    write_list(R1),nl, %вывод списка R1 на экран
 
    %собираем записи, где магазин - Оксана

    write('Formation of the r2 relationship: products of the Oksana store '), nl,
    subset_of_products(oksana,R2), %R2 - список сотрудников филиала 2
    list_in_base(R2), %добавление элементов из R2 в базу данных
    write_list(R2),nl, %вывод списка R2 на экран
    
    %Объединение - вывод всех продуктов двух магазинов - Ашана и Оксаны

    write('Combined ratio g1_ or g2: '), nl,
    union(Rez1), %Rez1 - список продуктов магазина1 или 2
    write_list(Rez1),nl,
    
    %Пересечение - вывод продуктов, которые есть и в Ашане, и в Оксане, в виде (назван_прод., ашан, цена_ашана, оксана, цена_оксаны)

    write('The intersection of the relations g1_ and g2: '), nl,
    intersection(Rez2), %Rez2 - список сотрудников 2-х филиалов 
    write_list(Rez2),nl,
    
    %Разница - выводятся все продукты Ашана, за исключением тех, что есть в Оксане
    write('The difference in the ratio r1-r2: '), nl,
    difference(Rez3), %Rez3-список сотрудников филиала 1 без фил.2
    write_list(Rez3),nl,
    R2 = [], R1 = [], Rez1 = [], Rez2 = [], Rez3 = [],
 
    write('Enter any character'),nl,
    get0(C). %Ожидание ввода символа
%--------------вспомогалка для 6 пункта----------------------------------------------------
%формирование подмножества сотрудников R заданного Филиала
%подмножество R представляется в виде списка термов "сотрудник_ф(...)"
subset_of_products(Shop,R):-
    bagof(product_s(Prod, Shop, Price),
    product(Prod, Shop, Price), R).
 
%правило объединения отношений - r1 или r2
%объединяются отношения сотрудник_ф(одесса) и сотрудник_ф(киев)
union_r1_r2(X1,X2,X3):-
    product_s(X1,ashan,X3),X2=ashan;
    product_s(X1,oksana,X3),X2=oksana.

%формирование списка Rez из фактов "сотрудник_ф1_или_ф2"
union(Rez):-
    bagof(product_s1_or_s2(X1,X2,X3),
         union_r1_r2(X1,X2,X3), %условие вкл. в список
         Rez).

%один и тот же продукт в двух магазинах
intersection_r1_r2(X11,X12,X13,X22,X23):-
    product_s(X11,ashan,X13),X12=ashan,
    product_s(X11,oksana,X23),X22=oksana.

%формирование списка Rez из фактов "сотрудник_ф1_и_ф2"
intersection(Rez):-
    bagof(product_s1_and_s2(X11,X12,X13,X22,X23),
    intersection_r1_r2(X11,X12,X13,X22,X23), 
    Rez). 

difference_r1_r2(X11,X12,X13):-
    product_s(X11,ashan,X13),X12=ashan,
    not(product_s(X11,oksana,X23)),X22=oksana.
%построение списка Rez из фактов "сотрудник_ф1_и_не_ф2"
difference(Rez):-
    bagof(product_s1_and_no_s2(X11,X12,X13),
    difference_r1_r2(X11,X12,X13), %условие вкл. в список
    Rez). 
%добавление термов из списка [H|T] в БД 
list_in_base([]).
list_in_base([H|T]):-
    H=product_s(Prod, Shop, Price),
    assertz(product_s(Prod, Shop, Price)),
    list_in_base(T). %Рекурсивный вызов для след. терма
%вывод элементов списка [H|T] в каждой строке
write_list([]).
write_list([H|T]):-write(H),nl,write_list(T).

%----------------Корректировка цены по названию продукта и магазу, в котором он находится
proc(7):-
    write('Write the name of product: '), nl, read(Prod),
    write('Write the name of the shop: '), nl, read(Shop),
    write('Write new price: '), nl, read(NewPrice),
    retract(product(Prod, Shop, _)),
    assertz(product(Prod, Shop, NewPrice)),
    write(Prod),
    write(': the price was changed.').

%----------------Вывод продуктов магаза с клавы
proc(8):-
    write('Write the name of the shop: '), nl, read(Shop),
    findall(Prod, product(Prod, Shop, _), Products),
    (Products = [] ->
        write('No shop.');
        write('Goods of the shop '), write(Shop), write(':'), nl,
        print_products(Products)
    ).

    % Помощник для печати списка товаров
    print_products([]).
    print_products([Prod|Rest]) :-
        write(Prod), nl,
        print_products(Rest).

%-----------Выход--------------
proc(9):-write('Goodbye'),nl.



info:-
	nl, 
	write('******************************'),nl,
	write('*       Expert system        *'),nl,
	write('*          Medicine       *'),nl,
	write('*                            *'),nl,
	write('*----------------------------*'),nl,
	write('*   Answer on questions :    *'),nl,
	write('*       yes, no, why         *'),nl,
	write('*      *'),nl,
	write('*                *'),nl,
	write('******************************'),nl,
	write('Write any symbol'),nl,
	get0(_).

% база правил

rule1 :: if [bolit(gorlo)] then angina.
rule2 :: if [bolit(gorlo), weakness] then angina.
rule3 :: if [bolit(golova), high_temp, weakness] then flu.
rule4 :: if [nasmork, bolit(golova), high_temp] then ORVI.


% гипотезы


h1 :: hypothesis(ORVI). 
h2 :: hypothesis(angina). 
h3 :: hypothesis(flu).    


% признаки

q1 :: attribute(bolit(golova)).
q2 :: attribute(bolit(gorlo)).
q3 :: attribute(high_temp).
q4 :: attribute(nasmork).
q5 :: attribute(weakness).

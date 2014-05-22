:- use_module(library(clpfd)).

% medidor de tiempo
ponTiempo:- retractall(tiempo(_)), get_time(T),
        assert(tiempo(T)).

escribeTiempo:-
        get_time(T2), tiempo(T1), T is (T2-T1),
        nl, nl, write('Elapsed time: '),write(T), write(' secs.').

futoshiki(Rows, Lts) :-
        length(Rows, N), maplist(length_(N), Rows),
        append(Rows, Cells), Cells ins 1..N,
        latin_square(Rows),
        unequals(Rows, Lts),
        label(Cells).

length_(L, Ls) :-
        length(Ls, L).

cell(I, J,Rows,C) :-    
        nth0(I,Rows,Row),
        nth0(J,Row,C).

unequal(Rows, [I1,J1,I2,J2]) :-
        cell(I1,J1, Rows, C1),
        cell(I2,J2, Rows, C2),
        C1 #< C2.

unequals(Rows, Lts) :- 
        maplist(unequal(Rows), Lts).

latin_square(Rows) :-
        maplist(all_distinct, Rows),
        transpose(Rows, Columns),
        maplist(all_distinct, Columns).

problem(1, 
        [[_,_,3,2,_],  % problem grid
         [_,_,_,_,_],
         [_,_,_,_,_],
         [_,_,_,_,_],
         [_,_,_,_,_]],
                        
        [[0,1,0,0],    % [i1,j1, i2,j2] requires that values[i1,j1] < values[i2,j2]
         [0,3,0,4],
         [1,2,0,2],
         [2,2,1,2],
         [2,3,1,3],
         [1,4,2,4],
         [2,1,3,1],
         [3,3,3,2],
         [4,1,4,0],
         [4,3,4,2],
         [4,4,3,4]]).

solution(1,
         [[5,1,3,2,4],
          [1,4,2,5,3],
          [2,3,1,4,5],
          [3,5,4,1,2],
          [4,2,5,3,1]]).

futoshiki_solve(X, Rows) :- ponTiempo, problem(X, Rows, Lts), futoshiki(Rows, Lts), maplist(writeln, Rows), escribeTiempo.
futoshiki_check(X) :- futoshiki_solve(X, Rows1), solution(X, Rows2), Rows1 == Rows2.

unique_solution :- findall(Rows, futoshiki_solve(1, Rows), L), 
                    length(L, N),
                    N == 1.
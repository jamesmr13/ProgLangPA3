:- dynamic value/1.
loop(N) :-
    retractall(value(_)),
    assert(value(N)),
    repeat,
            retract(value(V)),
            writeln(V),
            V1 is V - 1,
            assert(value(V1)),
            V = 0,
    !.
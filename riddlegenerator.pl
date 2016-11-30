:- dynamic hint/1.

generateRiddle(Filename) :-
    open(Filename, read, S),
    read_line(S, Words),
    assert(hint(Words)),
    repeat,
        retract(hint(W)),
        parse(W, List),
        read_line(S, W1),
        assert(hint(W1)),
        % do something
        at_end_of_stream(S),
    !.
    
write_sentence([H|[]]) :- writeln(H).    
write_sentence([H|T]) :- write(H), write(' '), write_sentence(T).

parse(W, List) :-
    List = [none, A, B, C, D, E, F],
    (
    (has_club(W, X), nth0(6, List, X));
    (reads_something(W, X), nth0(4, List, X));
    (eats_pizza(W, X), nth0(5, List, X));
    (is_major(W, X), nth0(3, List, X));
    (has_poster(W, X), nth0(2, List, X))
    ),
    write_sentence(List).

has_club(List, X) :- nextto(X, club, List).
reads_something(List, X) :- nextto(reads, X, List).
eats_pizza(List, X) :- nextto(X, pizza, List).
is_major(List, X) :- nextto(X, major, List).
has_poster(List, X) :- nextto(X, comic, List).
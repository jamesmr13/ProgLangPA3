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
        at_end_of_stream(S),
    !.

parse(W, List) :-
    List = [none, _, _, _, _, _, _],
    % we will have at least one rule every time
    % but sometimes we will need to make 3 rules
    List2 = [ignore, _, _, _, _, _, _],
    List3 = [ignore, _, _, _, _, _, _],
    (
    (has_club(W, X), nth0(6, List, X));
    (reads_something(W, X), nth0(4, List, X));
    (eats_pizza(W, X), nth0(5, List, X));
    (is_major(W, X), nth0(3, List, X));
    (has_poster(W, X), nth0(2, List, X))
    ),
    (
    (
    (office_next(W, X), nth0(0, List3, next_),
    nth0(1, List, Var1),
    nth0(1, List2, Var2),
    nth0(0, List2, none),
    nth0(1, List3, Var1),
    nth0(2, List3, Var2)
    )
    ,(
    (has_club(W, X), nth0(6, List2, X));
    (reads_something(W, X), nth0(4, List2, X));
    (eats_pizza(W, X), nth0(5, List2, X));
    (is_major(W, X), nth0(3, List2, X));
    (has_poster(W, X), nth0(2, List2, X))
    ));
    (
    (has_club(W, X), nth0(6, List, X));
    (reads_something(W, X), nth0(4, List, X));
    (eats_pizza(W, X), nth0(5, List, X));
    (is_major(W, X), nth0(3, List, X));
    (has_poster(W, X), nth0(2, List, X))
    )
    ),

    write(List),nl.

has_club(List, X) :- nextto(X, club, List).
reads_something(List, X) :- nextto(reads, X, List).
eats_pizza(List, X) :- nextto(X, pizza, List).
is_major(List, X) :- nextto(X, major, List).
has_poster(List, X) :- nextto(X, comic, List).
office_next(List, X) :- nextto(next, X, List); nextto(left, X, List); nextto(right, X, List).
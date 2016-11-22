next_to(N, M) :- M is N - 1; M is N + 1.
right_of(N, M) :- M is N + 1.
left_of(N, M) :- M is N - 1.

uniquehelp(_, []).
uniquehelp(A, [B|C]) :- A \= B, uniquehelp(A, C), uniquehelp(B, C).

unique([]).
unique([H|T]) :- uniquehelp(H, T). 

student(Major) :-
    Problem = [
        office(1, Poster1, Major1, Genre1, Eats1, Belongs1),
        office(2, Poster2, Major2, Genre2, Eats2, Belongs2),
        office(3, Poster3, Major3, Genre3, Eats3, Belongs3),
        office(4, Poster4, Major4, Genre4, Eats4, Belongs4),
        office(5, Poster5, Major5, Genre5, Eats5, Belongs5)
    ],

    member(office(_, cad, architecture, _, _, _), Problem),
    member(office(_, _, cse, _, _, flying), Problem),
    member(office(_, _, gs, scifi, _, _), Problem),
    member(office(X, calvinhobbes, _, _, _, _), Problem),
    member(office(Y, dilbert, _, _, _, _), Problem),
    left_of(X, Y),
    member(office(_, dilbert, _, fantasy, _, _), Problem),
    member(office(_, _, _, _, pepperoni, rcos), Problem),
    member(office(_, xkcd, _, _, cheese, _), Problem),
    member(office(3, _, _, fiction, _, _), Problem),
    member(office(1, _, cs, _, _, _), Problem),
    member(office(Ox, _, _, _, buffalochicken, _), Problem),
    member(office(Oy, _, _, _, _, rgaming), Problem),
    next_to(Ox, Oy),
    member(office(Ow, _, _, _, cheese, _), Problem),
    member(office(Oz, _, _, _, _, csclub), Problem),
    next_to(Ow, Oz),
    member(office(_, _, _, poetry, hawaiian, _), Problem),
    member(office(_, _, itws, _, broccoli, _), Problem),
    member(office(Oa, _, cs, _, _, _), Problem),
    member(office(Ob, phd, _, _, _, _), Problem),
    next_to(Oa, Ob),
    member(office(Oc, _, _, _, buffalochicken, _), Problem),
    member(office(Od, _, _, history, _, _), Problem),
    next_to(Oc, Od),
    member(office(_, _, Major, _, _, taekwondo), Problem),
    unique([Poster1, Poster2, Poster3, Poster4, Poster5]),
    unique([Major1, Major2, Major3, Major4, Major5]),
    unique([Genre1, Genre2, Genre3, Genre4, Genre5]),
    unique([Eats1, Eats2, Eats3, Eats4, Eats5]),
    unique([Belongs1, Belongs2, Belongs3, Belongs4, Belongs5]).
:- dynamic hint/1, rule/1.

major(cs).
major(cse).
major(itws).
major(architecture).
major(gs).

% reads through every line in the file
% calls parse on every line in order to get the rules
generateRiddle(Filename) :-
    retractall(rule(_)),
    retractall(hint(_)),
    open(Filename, read, S),
    read_line(S, Words),
    assert(hint(Words)),
    parse(Words),
    repeat,
        retract(hint(W)),
        read_line(S, W1),
        assert(hint(W1)),
        parse(W1),
        at_end_of_stream(S),
    !.
   
% in order to find the second rule specified in the hint
% must use this function since if we put it in parse
% parse would remember the first rule and basically skip 
% over the second rule
parse_helper(List, List2, List3, W) :-
    (
    (office_next(W), 
    nth0(0, List3, next_),
    nth0(1, List, Var1),
    nth0(1, List2, Var2),
    nth0(0, List2, none),
    nth0(1, List3, Var1),
    nth0(2, List3, Var2)
    )
    ,(
    (has_poster(W, X), nth0(2, List2, X));
    (is_major(W, X), nth0(3, List2, X));
    (eats_pizza(W, X), nth0(5, List2, X));
    (reads_something(W, X), nth0(4, List2, X));
    (has_club(W, X), nth0(6, List2, X))
    ));
    (
    (has_poster(W, X), nth0(2, List, X));
    (is_major(W, X), nth0(3, List, X));
    (eats_pizza(W, X), nth0(5, List, X));
    (reads_something(W, X), nth0(4, List, X));
    (has_club(W, X), nth0(6, List, X))
    ).

% parse through the sentence and find vital info
parse(W) :-
    List = [none, _, _, _, _, _, _],
    List2 = [ignore, _, _, _, _, _, _],
    List3 = [ignore, _, _, _, _, _, _],
    (
    (has_club(W, X), nth0(6, List, X)), parse_helper(List, List2, List3, W);
    (reads_something(W, X), nth0(4, List, X)), parse_helper(List, List2, List3, W);
    (eats_pizza(W, X), nth0(5, List, X)), parse_helper(List, List2, List3, W);
    (is_major(W, X), nth0(3, List, X)), parse_helper(List, List2, List3, W);
    (has_poster(W, X), nth0(2, List, X)), parse_helper(List, List2, List3, W)
    ),
    
    !,
    %write(List),nl.
    make_rule(List).%, make_rule(List2), make_rule(List3).
    %write(List), nl, write(List2),nl, write(List3),nl.

% helper functions to find the vital info
has_club(List, X) :- nextto(X, club, List).
reads_something(List, X) :- nextto(reads, X, List).
eats_pizza(List, X) :- nextto(X, pizza, List).
is_major(List, X) :- nextto(X, major, List).
has_poster(List, X) :- nextto(X, comic, List).
office_next(List) :- member(next, List); member(left, List); member(right, List); member(neighbor, List); member(neighbors, List).

% simple function to assert the rule
make_rule([]).
make_rule(R) :- assert(rule(R)).

% the solver
student(Major) :-
    % store all the rules in a list of lists
    findall(X, rule(X), Rules),
    % pass that list of lists to solve
    solve(Major, Rules).
    
solve(Major, Rules) :-
    Problem = [
        [1, Poster1, Major1, Genre1, Eats1, Belongs1],
        [2, Poster2, Major2, Genre2, Eats2, Belongs2],
        [3, Poster3, Major3, Genre3, Eats3, Belongs3],
        [4, Poster4, Major4, Genre4, Eats4, Belongs4],
        [5, Poster5, Major5, Genre5, Eats5, Belongs5]
    ],
    
    % test all 5 majors for a solution
    major(X),
    
    Solution = [_, _, X, _, _, taekwondo],
    
    check_rules(Solution, Rules, Problem),
    Major = X.
    
% recursive function that checks through every rule
% continuosly checks if Solution matches with the next rule
% automatically backtracks if Solution fails and tries to put
% new values in Solution
check_rules(_, [], _).
check_rules(Solution, [ [none|T1] |[]], Problem) :- member(T1, Problem), member(Solution, Problem).
check_rules(Solution, [ [none|T1] | T], Problem) :- member(T1, Problem), member(Solution, Problem), check_rules(Solution, T, Problem).
check_rules(Solution, [ [next_|T1]| T], Problem) :- nth0(0, T1, X), nth0(1, T1, Y), next_to(X, Y), member(Solution, Problem), check_rules(Solution, T, Problem).
check_rules(Solution, [ [next_|T1]| []], Problem) :- nth0(0, T1, X), nth0(1, T1, Y), next_to(X, Y), member(Solution, Problem).
check_rules(Solution, [ [left_|T1]| T], Problem) :- nth0(0, T1, X), nth0(1, T1, Y), left_of(X, Y), member(Solution, Problem), check_rules(Solution, T, Problem).
check_rules(Solution, [ [left_|T1]| []], Problem) :- nth0(0, T1, X), nth0(1, T1, Y), left_of(X, Y), member(Solution, Problem).
check_rules(Solution, [ [right_|T1]| T], Problem) :- nth0(0, T1, X), nth0(1, T1, Y), right_of(X, Y), member(Solution, Problem), check_rules(Solution, T, Problem).
check_rules(Solution, [ [right_|T1]| []], Problem) :- nth0(0, T1, X), nth0(1, T1, Y), right_of(X, Y), member(Solution, Problem).
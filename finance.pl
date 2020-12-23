finance_menu:-
    nl, nl, write('The query options are: '),
    nl, write('1. contribute_shares.'),
    nl, nl, write('2. request_loan.'),
    nl, write('3. loan_repayment.').


request_loan:-
    nl, write('Enter the member id: '), 
    read(Member),
    current_member_shares(Member, Shares), Previous is Shares,
    format("\n The current Shares owned by that Member is: ~w \n", [Shares]),
    nl, write('Requested loan amount: '),
    read(Principle),
    nl, write('Time in years to repay: '),
    read(Years),
    Limit is Previous * 5,
    find_loans(Member, Outstanding), New_Limit is Limit - Outstanding,

    approve_loan(Member, Previous, New_Limit, Principle, Years).
    

approve_loan(_,Shares, _, _, _):-
    Shares < 1,
    nl, nl, write('This member has zero shares, Sacco automatically rejects request.').

approve_loan(_,_, Limit, Principle, _):-
    Principle > Limit,
    nl, nl, format("The requested amount is past the limit for that member of(5 times the shares): ~w", [Limit]).

%this is what will be executed when the loan request is valid
approve_loan(Member, _, _, Principle, Years):-
    compound(Principle, Years, Amount), Outstanding is Amount, 
    get_time_str(Daterequested),
    Type is 0,
    record_loan(Member, Principle, Years, Outstanding, Type, Daterequested).

loan_repayment:-
    nl, write('Enter the member id: '),
    read(Member),
    find_loans(Member, Outstanding),
    nl, write("Enter the amount you want to repay: "),
    read(Repayment),
    New_Outstanding is Outstanding -Repayment,
    get_time_str(Daterequested),
    Type is 1,
    record_loan(Member, Repayment, 0, New_Outstanding, Type, Daterequested).


contribute_shares:- 
    nl, write('Enter the member id: '),
    read(Member),
    current_member_shares(Member, Shares), Previous is Shares,
    nl, format("The member's previous total shares was: ~w", [Shares]),
    nl, write('Enter the recent contribution: '),
    read(Contribution),
    Total is Previous + Contribution,
    get_time_str(DateContributed),
    open('data/contribution.csv', append, Fh),
    csv_write_stream(Fh, [contribution(Member, Contribution, Total, DateContributed)], []),
    format("Contribution recorded successfully.\n"),
    close(Fh).
    

record_loan(Member, Principle, Years, Outstanding, Type, Daterequested):-
    open('data/loans.csv', append, Fh),
    csv_write_stream(Fh, [loan(Member, Principle, Years, Outstanding, Type, Daterequested)], [functor(loan), arity(6)]),
    format("Loan request registered successfully.\n"),
    close(Fh).


find_loans(Member, Remaining):-
    retractall(loan(_, _, _, _, _, _)),
    open('data/loans.csv', read, Fh),
    csv_read_stream(Fh, Rows, [functor(loan), arity(6)]),
    maplist(assertz, Rows),
    findall(Outstanding, loan(Member, _, _, Outstanding, _, _), Total),
    nl, format("List of Loan Progression: ~w", [Total]),
    nl, write("Enter the last Outstanding Loan amount: "),
    read(Remaining),
    close(Fh).

current_member_shares(Member, Shares):-
    retractall(contribution(Member, _, _, _)),
    open('data/contribution.csv', read, Fh),
    csv_read_stream(Fh, Rows, [functor(contribution), arity(4)]),
    maplist(assertz, Rows),
    findall(C, contribution(Member, _, C, _), Total),
    nl, format("Shares Contribution List: ~w", [Total]),
    nl, write("Enter the last Total Shares: "),
    read(Shares),
    close(Fh).
 
compound(P, T, Total):-
	amount(P, T, Amount), Total is Amount.

amount(P, T, Amount):-
	I is 0.2 / 12,
	E is 12 * T,
	Total is (I + 1) ^ E,
	Amount is Total * P.

:- module(member, [register_member/0,show_members/0,search_member/0,members_with_loans/0,initialize_member_module/0]).

:- use_module(utils).

register_member :-
    format("\nEnter member ID Number:\n"),
    read(ID),
    format("Enter Member's First Name:\n"),
    read(FNAME),
    format("Enter Member's  Last Name:\n"),
    read(LNAME),
    format("Enter Member's shares count:\n"),
    read(SHARES),
    LOAN_STATUS is 400,
    get_time_str(REG_TIMESTAMP),
    assertz(member(ID, FNAME, LNAME,SHARES, LOAN_STATUS, REG_TIMESTAMP)),
    add_member.

show_members :-
    forall(member(ID, FNAME, LNAME,SHARES, LOAN_STATUS, REG_TIMESTAMP),
    format("\nMember ID: ~w\nName: ~w ~w\nNumber of Shares: ~w\nLoan Status: ~w\nRegistration Timestamp: ~w\n", [ID, FNAME, LNAME,SHARES, LOAN_STATUS, REG_TIMESTAMP])).

search_member :-
    format("\nEnter member's ID Number:\n"),
    read(ID),
    forall(member(ID, FNAME, LNAME,SHARES, LOAN_STATUS, REG_TIMESTAMP),
    format("\nMember ID: ~w\nName: ~w ~w\nNumber of Shares: ~w\nLoan Status: ~w\nRegistration Timestamp: ~w\n", [ID, FNAME, LNAME,SHARES, LOAN_STATUS, REG_TIMESTAMP])).

members_with_loans :-
    forall(member(ID, FNAME, LNAME,SHARES, LOAN_STATUS,REG_TIMESTAMP), LOAN_STATUS > 1,
    format("\nMember ID: ~w\nName: ~w ~w\nNumber of Shares: ~w\nLoan Status: ~w\nRegistration Timestamp: ~w\n", [ID, FNAME, LNAME,SHARES, LOAN_STATUS, REG_TIMESTAMP])).

initialize_member_module :-
    read_members.


% CSV FILES MANAGEMENT

read_members :-
    csv_read_file('data/members.csv', Rows, [functor(member), arity(6)]),
    maplist(assert, Rows).

add_member:-
    findall(row(ID, FNAME, LNAME, SHARES, LOAN_STATUS, REG_TIMESTAMP), member(ID, FNAME, LNAME, SHARES, LOAN_STATUS, REG_TIMESTAMP), Rows),
    csv_write_file('data/members.csv', Rows).
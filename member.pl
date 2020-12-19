
read_members:-
    csv_read_file('members.csv', Rows, [functor(table), arity(6)]),
    maplist(assert, Rows).

add_member:-
    findall(row(ID, FNAME, LNAME, VEHICLE_REG_NO,SHARES,LOAN_STATUS),
    member(ID, FNAME, LNAME, VEHICLE_REG_NO, SHARES, LOAN_STATUS), Rows),
      csv_write_file('members.csv', Rows).

register_member:-
    format("\nEnter member ID Number:\n"),
    read(ID),
    format("Enter Member's Fisrt Name:\n"),
    read(FNAME),
    format("Enter Member's  Last Name:\n"),
    read(LNAME),
    format("Enter Member's Vehicle Reg. No:\n"),
    read(VEHICLE_REG_NO),
    format("Enter Member's shares count:\n"),
    read(SHARES),
    LOAN_STATUS is 0,
    assertz(member(ID, FNAME, LNAME, VEHICLE_REG_NO,SHARES, LOAN_STATUS)),
    add_member.

show_members:-
    format("\n\nID_NUMBER\tFIRST_NAME.\tLAST_NAME\tVEHICLE_REG_NO\tSHARES\tLOAN_STATUS\n"),
    forall(member(ID, FNAME, LNAME, VEHICLE_REG_NO,SHARES, LOAN_STATUS),
    format("~w\t\t~w\t\t~w\t\t~w\t\t~w\t\t~w~n", [ID, FNAME, LNAME, VEHICLE_REG_NO,SHARES, LOAN_STATUS])).
   

search_member:-
    format("\nEnter member ID Number:\n"),
    read(X),
    format("\n\nID_NUMBER\tFIRST_NAME.\tLAST_NAME\tVEHICLE_REG_NO\tSHARES\tLOAN_STATUS\n"),
    forall(member(X,FNAME, LNAME, VEHICLE_REG_NO,SHARES, LOAN_STATUS),
    format("~w\t\t~w\t\t~w\t\t~w\t\t~w\t\t~w~n", [X, FNAME, LNAME, VEHICLE_REG_NO,SHARES, LOAN_STATUS])).

members_with_loans:-
    format("\n\nID_NUMBER\tFIRST_NAME.\tLAST_NAME\tVEHICLE_REG_NO\tSHARES\tLOAN_STATUS\n"),
    forall(member(ID,FNAME, LNAME, VEHICLE_REG_NO,SHARES, L),L>0,
    format("~w\t\t~w\t\t~w\t\t~w\t\t~w\t\t~w~n", [ID, FNAME, LNAME, VEHICLE_REG_NO,SHARES, L])).




:- module(member, [register_member/0,list_members/0,search_member/0,delete_member/0]).

:- use_module(library(persistency)).
:- use_module(vehicle).

:- persistent
    member(id:integer, fname:atom, lname:atom).

:- db_attach('data/member.journal', []).

save_member(ID, FName, LName) :-
    assert_member(ID, FName, LName).

register_member :-
    format("\nEnter member ID Number:\n"),
    read(ID),
    format("Enter Member's First Name:\n"),
    read(FName),
    format("Enter Member's  Last Name:\n"),
    read(LName),
    save_member(ID, FName, LName).

list_members :-
    forall(member(ID, _, _), print_member(ID)).

search_member :-
    format("\nEnter member's ID Number:\n"),
    read(ID),
    print_member(ID).

print_member(OwnerID) :-
    member(OwnerID, OwnerFName, OwnerLName),
    setof(RegNo, vehicle:vehicle(OwnerID, RegNo, _, _, _), Vehicles),
    format("\nMember ID: ~w\nName: ~w ~w\nVehicles Owned: ~w\n", [OwnerID, OwnerFName, OwnerLName, Vehicles]).

delete_member :-
    format("\nEnter member's ID Number:\n"),
    read(ID),
    retract_member(ID, _, _).
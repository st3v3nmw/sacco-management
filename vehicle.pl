:- module(vehicle, [register_vehicle/0,search_vehicle/0,list_vehicles/0,delete_vehicle/0]).

:- use_module(library(persistency)).
:- use_module(member).

:- persistent
    vehicle(owner_id:integer, regno:atom, manufacturer:atom, model:atom, year: integer),
    driver(id: integer, fname: atom, lname: atom, phone: integer),
    drives(driver: integer, vehicle: atom),
    bus_stop(name: atom),
    plies(vehicle: atom, route_start: atom, route_end: atom).

:- db_attach('data/vehicle.journal', []).

save_vehicle(ID, RegNo, Manufacturer, Model, Year) :-
    assert_vehicle(ID, RegNo, Manufacturer, Model, Year).

save_driver(ID, FName, LName, Phone) :-
    assert_driver(ID, FName, LName, Phone).

save_drives(DriverID, VehicleRegNo) :-
    assert_drives(DriverID, VehicleRegNo).

save_bus_stop(Name) :-
    assert_bus_stop(Name).

save_plies(VehicleRegNo, RouteStart, RouteEnd) :-
    assert_plies(VehicleRegNo, RouteStart, RouteEnd).

register_vehicle :-
    format("\nNote that all input should be in lowercase letters with no whitespaces.\n"),
    format("\nEnter owner's ID Number:\n"),
    read(OwnerID),
    format("Enter vehicle plate number (i.e. klp_987c):\n"),
    read(RegNo),
    format("Enter vehicle manufacturer:\n"),
    read(Manufacturer),
    format("Enter vehicle model:\n"),
    read(Model),
    format("Enter vehicle year of manufacture:\n"),
    read(Year),
    save_vehicle(OwnerID, RegNo, Manufacturer, Model, Year),

    format("Enter route start (i.e. nairobi):\n"),
    read(RouteStart),
    save_bus_stop(RouteStart),
    format("Enter route end (i.e. nakuru):\n"),
    read(RouteEnd),
    save_bus_stop(RouteEnd),
    save_plies(RegNo, RouteStart, RouteEnd),

    format("Enter driver\'s ID number:\n"),
    read(D_ID),
    format("Enter driver\'s first name:\n"),
    read(FName),
    format("Enter driver\'s last name:\n"),
    read(LName),
    format("Enter driver\'s phone number:\n"),
    read(Phone),
    save_driver(D_ID, FName, LName, Phone),
    save_drives(D_ID, RegNo).

search_vehicle :-
    format("\nNote that all input should be in lowercase letters with no whitespaces.\n"),
    format("\nEnter vehicle\'s plate number:\n"),
    read(RegNo),
    print_vehicle(RegNo).

list_vehicles :-
    forall(vehicle(_,RegNo,_,_,_), print_vehicle(RegNo)).

print_vehicle(RegNo) :-
    vehicle(OwnerID, RegNo, Manufacturer, Model, Year),
    member:member(OwnerID, OwnerFName, OwnerLName),
    drives(D_ID, RegNo),
    driver(D_ID, FName, LName, Phone),
    plies(RegNo, RouteStart, RouteEnd),
    format("\nOwner\'s Name: ~w ~w\nOwner\'s ID: ~w\nPlate Number: ~w\nManufacturer: ~w\nModel: ~w\nYear: ~w\nRoute: ~w-~w\nDriver\'s Name: ~w ~w\nDriver\'s ID: ~w\nDriver\'s Phone Contact: ~w\n", [OwnerFName,OwnerLName,OwnerID,RegNo,Manufacturer,Model,Year,RouteStart,RouteEnd,FName,LName,D_ID,Phone]).

delete_vehicle :- 
    format("\nNote that all input should be in lowercase letters with no whitespaces.\n"),
    format("\nEnter vehicle\'s plate number:\n"),
    read(RegNo),
    retract_vehicle(_,RegNo,_,_,_),
    retract_drives(D_ID, RegNo),
    retract_driver(D_ID,_,_,_),
    retract_plies(RegNo,_,_).
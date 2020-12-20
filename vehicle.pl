:- module(vehicle, [register_vehicle/0,search_vehicle/0,list_vehicles/0,delete_vehicle/0,initialize_vehicle_module/0]).

:- use_module(utils).

register_vehicle :-
    format("\nNote that all input should be in lowercase letters with no whitespaces.\n"),
    format("Enter owner's ID:\n "),
    read(ID),
    format("Enter vehicle plate number (i.e. klp_987c):\n"),
    read(RegNo),
    format("Enter vehicle manufacturer:\n"),
    read(Manufacturer),
    format("Enter vehicle model:\n"),
    read(Model),
    format("Enter vehicle year of manufacture:\n"),
    read(Year),
    format("Enter route (i.e. nairobi_nakuru):\n"),
    read(Route),
    format("Enter driver\'s ID number:\n"),
    read(D_ID),
    format("Enter driver\'s first name:\n"),
    read(FName),
    format("Enter driver\'s last name:\n"),
    read(LName),
    format("Enter driver\'s phone number:\n"),
    read(Phone),
    get_time_str(RegTimestamp),
    assertz(vehicle(ID,RegNo,Manufacturer,Model,Year,Route,FName,LName,D_ID,Phone,RegTimestamp)),
    format("Vehicle registered successfully.\n"),
    save_vehicle_data.

search_vehicle :-
    format("\nNote that all input should be in lowercase letters with no whitespaces.\n"),
    format("\nEnter vehicle\'s plate number:\n"),
    read(RegNo),
    forall(vehicle(ID,RegNo,Manufacturer,Model,Year,Route,FName,LName,D_ID,Phone,RegDate),
        format("\nOwner\'s ID: ~w\nPlate Number: ~w\nManufacturer: ~w\nModel: ~w\nYear: ~w\nRoute: ~w\nDriver\'s Name: ~w ~w\nDriver\'s ID: ~w\nDriver\'s Phone Contact: ~w\nRegistration Timestamp: ~w\n",
                [ID,RegNo,Manufacturer,Model,Year,Route,FName,LName,D_ID,Phone,RegDate])).

list_vehicles :-
    forall(vehicle(ID,RegNo,Manufacturer,Model,Year,Route,FName,LName,D_ID,Phone,RegDate),
        format("\nOwner\'s ID: ~w\nPlate Number: ~w\nManufacturer: ~w\nModel: ~w\nYear: ~w\nRoute: ~w\nDriver\'s Name: ~w ~w\nDriver\'s ID: ~w\nDriver\'s Phone Contact: ~w\nRegistration Timestamp: ~w\n",
            [ID,RegNo,Manufacturer,Model,Year,Route,FName,LName,D_ID,Phone,RegDate])).

delete_vehicle :- 
    format("\nNote that all input should be in lowercase letters with no whitespaces.\n"),
    format("\nEnter vehicle\'s plate number:\n"),
    read(RegNo),
    retract(vehicle(_,RegNo,_,_,_,_,_,_,_,_,_)),
    save_vehicle_data.

initialize_vehicle_module :-
    read_vehicle_data.


% CSV FILES MANAGEMENT

read_vehicle_data :-
    csv_read_file('data/vehicle_data.csv', Rows, [functor(vehicle), arity(11)]),
    maplist(assert, Rows).

save_vehicle_data :-
    findall(row(ID,RegNo,Manufacturer,Model,Year,Route,FName,LName,D_ID,Phone,RegTimestamp), vehicle(ID,RegNo,Manufacturer,Model,Year,Route,FName,LName,D_ID,Phone,RegTimestamp), Rows),
    csv_write_file('data/vehicle_data.csv', Rows).
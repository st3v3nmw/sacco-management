:- module(vehicle, [register_vehicle/0,search_vehicle/0,list_vehicles/0,delete_vehicle/0,register_driver/0,search_driver/0,list_drivers/0,delete_driver/0,initialize_vehicle_module/0]).

:- use_module(utils).

register_vehicle :-
    format("\nEnter owner's ID:\n "),
    read(ID),
    format("Enter vehicle plate number:\n"),
    read(RegNo),
    format("Enter vehicle manufacturer:\n"),
    read(Manufacturer),
    format("Enter vehicle model:\n"),
    read(Model),
    format("Enter vehicle year of manufacture:\n"),
    read(Year),
    get_time_str(RegTimestamp),
    assertz(vehicle(ID, RegNo, Manufacturer, Model, Year, RegTimestamp)),
    format("Vehicle registered successfully.\n"),
    save_vehicle_data.

search_vehicle :-
    format("\nEnter vehicle\'s plate number:\n"),
    read(RegNo),
    forall(vehicle(ID,RegNo,Manufacturer,Model,Year,RegDate),
        format("\nOwner\'s ID: ~w\nPlate Number: ~w\nManufacturer: ~w\nModel: ~w\nYear: ~w\nRegistration Timestamp: ~w\n",
                [ID,RegNo,Manufacturer,Model,Year,RegDate])).

list_vehicles :-
    forall(vehicle(ID,RegNo,Manufacturer,Model,Year,RegDate),
        format("\nOwner\'s ID: ~w\nPlate Number: ~w\nManufacturer: ~w\nModel: ~w\nYear: ~w\nRegistration Timestamp: ~w\n",
            [ID,RegNo,Manufacturer,Model,Year,RegDate])).

delete_vehicle :- 
    format("\nEnter vehicle\'s plate number:\n"),
    read(RegNo),
    retract(vehicle(_,RegNo,_,_,_)),
    format("Vehicle deleted successfully.\n"),
    save_vehicle_data.

register_driver :-
    format("\nEnter driver\'s ID number:\n"),
    read(ID),
    format("Enter driver\'s first name:\n"),
    read(FName),
    format("Enter driver\'s last name:\n"),
    read(LName),
    format("Enter driver\'s phone number:\n"),
    read(Phone),
    get_time_str(RegTimestamp),
    assertz(driver(ID, FName, LName, Phone, RegTimestamp)),
    format("Driver registered successfully.\n"),
    save_driver_data.

search_driver :-
    format("\nEnter driver\'s ID number:\n"),
    read(ID),
    forall(driver(ID, FName, LName, Phone, RegTimestamp),
        format("\nID: ~w\nFirst Name: ~w\nLast Name: ~w\nPhone: ~w\nRegistration Timestamp: ~w\n",
            [ID, FName, LName, Phone, RegTimestamp])).

list_drivers :-
    forall(driver(ID, FName, LName, Phone, RegTimestamp),
        format("\nID: ~w\nFirst Name: ~w\nLast Name: ~w\nPhone: ~w\nRegistration Timestamp: ~w\n",
            [ID, FName, LName, Phone, RegTimestamp])).

delete_driver :-
    format("\nEnter driver\'s ID:\n"),
    read(ID),
    retract(driver(ID,_,_,_)),
    format("Driver deleted successfully.\n"),
    save_driver_data.

initialize_vehicle_module :-
    read_vehicle_data,
    read_driver_data,
    read_rship_drives_data.


% CSV FILES MANAGEMENT

read_vehicle_data :-
    csv_read_file('data/vehicle_data.csv', Rows, [functor(vehicle), arity(6)]),
    maplist(assert, Rows).

save_vehicle_data :-
    findall(row(ID,RegNo,Manufacturer,Model,Year,RegTimestamp), vehicle(ID,RegNo,Manufacturer,Model,Year,RegTimestamp), Rows),
    csv_write_file('data/vehicle_data.csv', Rows).

read_driver_data :-
    csv_read_file('data/driver_data.csv', Rows, [functor(driver), arity(5)]),
    maplist(assert, Rows).

save_driver_data :-
    findall(row(ID, FName, LName, Phone, RegTimestamp), driver(ID, FName, LName, Phone, RegTimestamp), Rows),
    csv_write_file('data/driver_data.csv', Rows).

read_rship_drives_data :-
    csv_read_file('data/rship_drives_data.csv', Rows, [functor(drives), arity(2)]),
    maplist(assert, Rows).

save_rship_drives_data :-
    findall(row(DriverID, VehicleRegNo), drives(DriverID, VehicleRegNo), Rows),
    csv_write_file('data/rship_drives_data.csv', Rows).
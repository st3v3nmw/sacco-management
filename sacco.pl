:- use_module(member).
:- use_module(vehicle).

:- initialization(main_menu_loop).

% Main Menu

get_action_main_menu(Action) :-
    menu('Sacco Management Main Menu',
        [members    : 'Members',
         loans      : 'Loans and Shares',
         vehicles   : 'Vehicles and Drivers',
         quit       : 'Quit'], Action).

main_menu_action(members) :-
    member_submenu_loop.

main_menu_action(loans) :-
    format("\nAwaiting merge :)\n").

main_menu_action(vehicles) :-
    vehicle_submenu_loop.

main_menu_action(quit) :-
    format("\nExiting...\n"),
    halt.

main_menu_loop :-
    get_action_main_menu(X),
    main_menu_action(X),
    format("\nEnter c. to continue:\n"),
    read(_),
    main_menu_loop.

% Members Submenu

get_member_submenu_action(Action) :-
    menu('Sacco Management Members Menu',
        [register_member_opt   : 'Register Member',
         search_member_opt     : 'Search Member',
         list_members_opt       : 'List Members',
         delete_member_opt     : 'Delete Member',
         back_v                : 'Go back to main menu'], Action).

member_submenu_action(register_member_opt) :-
    register_member.

member_submenu_action(search_member_opt) :-
    search_member.

member_submenu_action(list_members_opt) :-
    list_members.

member_submenu_action(delete_member_opt) :-
    delete_member.

member_submenu_action(back_v) :-
    main_menu_loop.

member_submenu_loop :-
    get_member_submenu_action(X),
    member_submenu_action(X),
    format("\nEnter c. to continue:\n"),
    read(_),
    member_submenu_loop.


% Vehicle Submenu

get_vehicle_submenu_action(Action) :-
    menu('Sacco Management Vehicles Menu',
        [register_vehicle_opt   : 'Register Vehicle',
         search_vehicle_opt     : 'Search Vehicle',
         list_vehicles_opt      : 'List Vehicles',
         delete_vehicle_opt     : 'Delete Vehicle',
         back_v                 : 'Go back to main menu'], Action).

vehicle_submenu_action(register_vehicle_opt) :-
    register_vehicle.

vehicle_submenu_action(search_vehicle_opt) :-
    search_vehicle.

vehicle_submenu_action(list_vehicles_opt) :-
    list_vehicles.

vehicle_submenu_action(delete_vehicle_opt) :-
    delete_vehicle.

vehicle_submenu_action(back_v) :-
    main_menu_loop.

vehicle_submenu_loop :-
    get_vehicle_submenu_action(X),
    vehicle_submenu_action(X),
    format("\nEnter c. to continue:\n"),
    read(_),
    vehicle_submenu_loop.
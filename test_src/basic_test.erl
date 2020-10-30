%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(basic_test).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
%% --------------------------------------------------------------------

-define(Master,"asus").
-define(MnesiaNodes,['iaas@asus']).

-define(WorkerVmIds,["30000","30001","30002","30003","30004","30005","30006","30007","30008","30009"]).


%% External exports
-export([start/0]).



%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
start()->
 
    ?debugMsg("Start start_stop_computer "),
    ?assertEqual(ok,start_stop_computer()),
    ?debugMsg("Stop start_stop_computer "),

    ?debugMsg("Start start_stop_service "),
    ?assertEqual(ok,start_stop_service()),
    ?debugMsg("Stop start_stop_service "),

    ?debugMsg("Start deploy "),
    ?assertEqual(ok,deploy()),
    ?debugMsg("Stop deploy "),

    ?debugMsg("Start add_db_node "),
    ?assertEqual(ok,add_db_node()),
    ?debugMsg("Stop add_db_node "),

   %% End application tests
    cleanup(),
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
deploy()->
    R=op:add_deployment("math","1.0.0"),
    io:format(" ~p~n",[{?MODULE,?LINE,R}]),
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
add_db_node()->
    rpc:call('10250@sthlm_1',mnesia,stop,[]),
    op:add_db_node("sthlm_1","10250"),
    io:format("all ~p~n",[{?MODULE,?LINE,mnesia:system_info(all)}]),
    ok.

%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start_stop_computer()->
    op:stop_host("sthlm_1"),
    ?assertEqual(pang,net_adm:ping('10250@sthlm_1')),
    op:start_host("sthlm_1"),
    ?assertEqual(pong,net_adm:ping('10250@sthlm_1')),
    ok.
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
start_stop_service()->
    ?assertMatch({badrpc,_},rpc:call('10250@sthlm_1',adder_service,add,[20,22])),
    op:create_service("adder_service","1.0.0","sthlm_1","10250"),
    ?assertEqual(42,rpc:call('10250@sthlm_1',adder_service,add,[20,22])),
    op:delete_service("adder_service","1.0.0","sthlm_1","10250"),
    ?assertMatch({badrpc,_},rpc:call('10250@sthlm_1',adder_service,add,[20,22])),
    ok.
    
%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
setup()->
    
    ok.

cleanup()->


    ok.



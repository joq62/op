%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(op_tests).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
%% --------------------------------------------------------------------

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
    ?debugMsg("Test system setup"),
    ?assertEqual(ok,setup()),

    %% Start application tests
    
    
    ?debugMsg("Start basic_test "),
    ?assertEqual(ok,basic_test:start()),
    ?debugMsg("Stop basic_test "),

    ?debugMsg("Start stop_test_system:start"),
    %% End application tests
  %  cleanup(),
    ok.


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
setup()->
    application:start(op),
    ok.

cleanup()->
  %  application:stop(sd_service),
  %  rpc:call('node1@asus',init,stop,[]),
    init:stop(),
    ok.



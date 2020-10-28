%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(op_lib).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
-include_lib("eunit/include/eunit.hrl").
%% --------------------------------------------------------------------

-define(WAIT_FOR_TABLES,5000).
%% External exports
-export([db_init/1,
	 start_host/1,
	 stop_host/1,
	 create_service/4,
	 delete_service/4,
	 add_db_node/2
	]).

%% ====================================================================
%% External functions
%% ====================================================================
db_init(TextFile)->
    mnesia:stop(),
    mnesia:delete_schema([node()]),
    mnesia:create_schema([node()]),
    

    mnesia:load_textfile(?TEXTFILE),
    mnesia:start(),    
    timer:sleep(1000),

    
%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
add_db_node(HostId,VmId)->
    Vm=list_to_atom(VmId++"@"++HostId),
    ok=rpc:call(Vm,mnesia,start,[]),
    mnesia:change_config(extra_db_nodes, [Vm]),
    
    Tables=mnesia:system_info(tables),
    mnesia:wait_for_tables(Tables,?WAIT_FOR_TABLES),
  %  Tables=rpc:call(Vm,mnesia,system_info,[tables]),
    io:format("~p~n",[{?MODULE,?LINE,Tables}]),
  %  rpc:call(Vm,mnesia,wait_for_tables,[Tables,?WAIT_FOR_TABLES]),
    ok.



%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
create_service(ServiceId,Vsn,HostId,VmId)->
    Result=service:create(ServiceId,Vsn,HostId,VmId),
    Result.

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
delete_service(ServiceId,Vsn,HostId,VmId)->
    Result=service:delete(ServiceId,Vsn,HostId,VmId),
    Result.



%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------

start_host(HostId)->
    Controllers=db_vm:type(controller),
   % io:format("~p~n",[{?MODULE,?LINE,Controllers}]),
    Result=case [{XVm,XVmId}||{XVm,XHostId,XVmId,controller,_XStatus}<-Controllers,
					HostId==XHostId] of
	       []->
		   {error,[eexist, HostId,?MODULE,?LINE]};
	       [{XVm,XVmId}]->
		   case net_adm:ping(XVm) of
		       pong->
			   {error,[already_started, HostId,?MODULE,?LINE]};
		       pang->
			   computer:start_computer(HostId,XVmId)
		   end
	   end,
    Result.
    

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
stop_host(HostId)->
     Controllers=db_vm:type(controller),
    Result=case [XVmId||{_XVm,XHostId,XVmId,controller,_XStatus}<-Controllers,
					HostId==XHostId] of
	       []->
		   {error,[eexist, HostId]};
	       [XVmId]->
		   computer:clean_computer(HostId,XVmId)
	   end,
    Result.

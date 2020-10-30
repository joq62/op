%%% -------------------------------------------------------------------
%%% Author  : uabjle
%%% Description : dbase using dets 
%%% 
%%% Created : 10 dec 2012
%%% -------------------------------------------------------------------
-module(dbase).  
   
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------


%% External exports
-export([start/0,
	 master/1,
	 slave/0,
	 add_extra_nodes/1
	]).


-define(AllVms,['b0@asus','b1@asus','b2@asus']).
-define(AllVmId,["b0","b1","b2"]).
-define(WAIT_FOR_TABLES,5000).

%% ====================================================================
%% External functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function:tes cases
%% Description: List of test cases 
%% Returns: non
%% --------------------------------------------------------------------
load_info()->
    db_computer:create(host1,sshid1,sshpwd1,ipaddr1,port1,status1),
    db_computer:create(host2,sshid2,sshpwd2,ipaddr2,port2,status2),
    ?assertEqual([{host2,sshid2,sshpwd2,ipaddr2,port2,status2},
		  {host1,sshid1,sshpwd1,ipaddr1,port1,status1}],
		 db_computer:read_all()),
    ok.
   


%% --------------------------------------------------------------------
%% Function:start/0 
%% Description: Initiate the eunit tests, set upp needed processes etc
%% Returns: non
%% --------------------------------------------------------------------
add_node(Node)->
    ok=rpc:call(Node,mnesia,start,[]),
    mnesia:change_config(extra_db_nodes, [Node]) ,
    Tables=rpc:call(Node,mnesia,system_info,[tables]),
    rpc:call(Node,mnesia,wait_for_tables,[Tables,?WAIT_FOR_TABLES]),
    ok.


init(AllVms)->
    mnesia:stop(),
    mnesia:delete_schema([node()]),
    mnesia:start(),
    dynamic_db_init(lists:delete(node(), AllVms)).


dynamic_db_init([],TableCreateList)->
    % All known tables add!
    [mnesia:create_table(Table,[Attributes])||{Table,Attributes}<-TableCreateList],
    mnesia:create_table(vm,[{attributes, record_info(fields, vm)}]),
    mnesia:create_table(computer,[{attributes, record_info(fields, computer)}]);
dynamic_db_init(AllNodes,TableList)->
  %  io:format(" ~p~n",[{?MODULE,?LINE,AllNodes}]),
    add_extra_nodes(AllNodes,TableList).

add_extra_nodes([Node|T],TableList)->
    case mnesia:change_config(extra_db_nodes, [Node]) of
	{ok,[Node]}->
%	    io:format(" ~p~n",[{?MODULE,?LINE,node()}]),
	    mnesia:add_table_copy(schema, node(),ram_copies),
	    % All known tables add!
	    mnesia:add_table_copy(Table, node(), CopyType)||{,
	    mnesia:add_table_copy(vm, node(), ram_copies),
	    mnesia:add_table_copy(computer, node(), ram_copies),
	    
	    Tables=mnesia:system_info(tables),
	    mnesia:wait_for_tables(Tables,?WAIT_FOR_TABLES);
	_ ->
	    add_extra_nodes(T,TableList)
    end.

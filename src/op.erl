%%% -------------------------------------------------------------------
%%% @author  : Joq Erlang
%%% @doc: : 
%%% Manage Computers
%%% 
%%% Created : 
%%% -------------------------------------------------------------------
-module(op). 

-behaviour(gen_server).
%% --------------------------------------------------------------------
%% Include files
%% --------------------------------------------------------------------
%-include("timeout.hrl").
%-include("log.hrl").
%-include("config.hrl").
%% --------------------------------------------------------------------


%% --------------------------------------------------------------------
%% Key Data structures
%% 
%% --------------------------------------------------------------------
-record(state, {}).



%% --------------------------------------------------------------------
%% Definitions 
%% --------------------------------------------------------------------
-define(HbInterval,20*1000).
-define(ControlVmId,"10250").
-define(WorkerVmIds,["30000","30001","30002","30003","30004","30005","30006","30007","30008","30009"]).

-export([start_host/1,stop_host/1,
	 create_service/4,delete_service/4,
	 add_db_node/2
	]).

-export([start/0,
	 stop/0,
	 ping/0,
	 heart_beat/1
	]).

%% gen_server callbacks
-export([init/1, handle_call/3,handle_cast/2, handle_info/2, terminate/2, code_change/3]).


%% ====================================================================
%% External functions
%% ====================================================================

%% Asynchrounus Signals



%% Gen server functions

start()-> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop()-> gen_server:call(?MODULE, {stop},infinity).


ping()-> 
    gen_server:call(?MODULE, {ping},infinity).

%%-----------------------------------------------------------------------
add_db_node(HostId,VmId)-> 
    gen_server:call(?MODULE, {add_db_node,HostId,VmId},infinity).


start_host(HostId)-> 
    gen_server:call(?MODULE, {start_host,HostId},infinity).
stop_host(HostId)-> 
    gen_server:call(?MODULE, {stop_host,HostId},infinity).

create_service(ServiceId,Vsn,HostId,VmId)-> 
    gen_server:call(?MODULE, {create_service,ServiceId,Vsn,HostId,VmId},infinity).
delete_service(ServiceId,Vsn,HostId,VmId)-> 
    gen_server:call(?MODULE, {delete_service,ServiceId,Vsn,HostId,VmId},infinity).


%%----------------------------------------------------------------------

heart_beat({Interval,ComputerStatus,VmStatus})->
    gen_server:cast(?MODULE, {heart_beat,{Interval,ComputerStatus,VmStatus}}).


%% ====================================================================
%% Server functions
%% ====================================================================

%% --------------------------------------------------------------------
%% Function: init/1
%% Description: Initiates the server
%% Returns: {ok, State}          |
%%          {ok, State, Timeout} |
%%          ignore               |
%%          {stop, Reason}
%
%% --------------------------------------------------------------------

% To be removed
-define(TEXTFILE,"./src/db_op_init.hrl").

init([]) ->
    ssh:start(),
    mnesia:stop(),
    mnesia:delete_schema([node()]),
    mnesia:create_schema([node()]),
    mnesia:load_textfile(?TEXTFILE),
    mnesia:start(),    
    timer:sleep(1000),

  %  spawn(fun()->h_beat(?HbInterval) end),
    {ok, #state{}}.
    
%% --------------------------------------------------------------------
%% Function: handle_call/3
%% Description: Handling call messages
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (aterminate/2 is called)
%% --------------------------------------------------------------------
handle_call({ping},_From,State) ->
    Reply={pong,node(),?MODULE},
    {reply, Reply, State};

handle_call({add_db_node,HostId,VmId},_From,State) ->
    Reply=op_lib:add_db_node(HostId,VmId),
    {reply, Reply, State};

handle_call({create_service,ServiceId,Vsn,HostId,VmId},_From,State) ->
    Reply=rpc:call(node(),service,create,[ServiceId,Vsn,HostId,VmId]),
    {reply, Reply, State};

handle_call({delete_service,ServiceId,Vsn,HostId,VmId},_From,State) ->
    Reply=rpc:call(node(),service,delete,[ServiceId,Vsn,HostId,VmId]),
    {reply, Reply, State};

handle_call({start_host,HostId},_From,State) ->
    Reply=op_lib:start_host(HostId),
    {reply, Reply, State};

handle_call({stop_host,HostId},_From,State) ->
    Reply=op_lib:stop_host(HostId),
    {reply, Reply, State};

handle_call({stop}, _From, State) ->
    {stop, normal, shutdown_ok, State};

handle_call(Request, From, State) ->
    Reply = {unmatched_signal,?MODULE,Request,From},
    {reply, Reply, State}.

%% --------------------------------------------------------------------
%% Function: handle_cast/2
%% Description: Handling cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% -------------------------------------------------------------------
handle_cast({heart_beat,{Interval,ComputerStatus,VmStatus}}, State) ->
 %   io:format("ComputerStatus ~p~n",[{?MODULE,?LINE,time(),ComputerStatus}]),
 %   io:format("VmStatus ~p~n",[{?MODULE,?LINE,time(),VmStatus}]),
 %   io:format("h_beat ~p~n",[{time(),?MODULE,?LINE}]),

%    RunningComputers=[HostId||{running,HostId}<-ComputerStatus],
%    AvailableComputers=[HostId||{available,HostId}<-ComputerStatus],
 %   NotAvailableComputers=[HostId||{not_available,HostId}<-ComputerStatus],

 %   RunningVms=vms:vm_status(VmStatus,running),
 %   AvailableVms=vms:vm_status(VmStatus,available),
 %   NotAvailableVms=vms:vm_status(VmStatus,not_available),

 %   NewVmCandidates=vms:candidates(State#state.vm_candidates,RunningVms),
 %   NewState=State#state{comp
%Ruter_running=RunningComputers,
%			 computer_available=AvailableComputers,
%			 computer_not_available=NotAvailableComputers,
%			 vms_running=RunningVms,
%			 vms_available=AvailableVms,
%			 vms_not_available=NotAvailableVms,
%			 vm_candidates=NewVmCandidates},
 
    spawn(fun()->h_beat(Interval) end),    
    {noreply, State};
			     
handle_cast(Msg, State) ->
    io:format("unmatched match cast ~p~n",[{?MODULE,?LINE,Msg}]),
    {noreply, State}.

%% --------------------------------------------------------------------
%% Function: handle_info/2
%% Description: Handling all non call/cast messages
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%% --------------------------------------------------------------------

handle_info(Info, State) ->
   % io:format("unmatched match info ~p~n",[{?MODULE,?LINE,Info}]),
    {noreply, State}.


%% --------------------------------------------------------------------
%% Function: terminate/2
%% Description: Shutdown the server
%% Returns: any (ignored by gen_server)
%% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

%% --------------------------------------------------------------------
%% Func: code_change/3
%% Purpose: Convert process state when code is changed
%% Returns: {ok, NewState}
%% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% --------------------------------------------------------------------
%%% Internal functions
%% --------------------------------------------------------------------
%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------
h_beat(Interval)->
    timer:sleep(Interval),
 %   io:format(" *************** "),
 %   io:format(" ~p",[{time()}]),
 %   io:format(" *************** ~n"),
  
   % io:format("computer status 1 ~p~n",[{time(),?MODULE,?LINE,db_computer:read_all()}]),
    ComputerStatus=computer:status_computers(),
  %  io:format("ComputerActualState ~p~n",[{?MODULE,?LINE,time(),ComputerStatus}]),
    [db_computer:update(HostId,Status)||{Status,HostId}<-ComputerStatus],
  %  io:format("computer status 2 ~p~n",[{time(),?MODULE,?LINE,db_computer:read_all()}]),

 
%    Controllers=db_vm:type(controller),
 %   io:format("Controllers ~p~n",[{?MODULE,?LINE,Controllers}]),
 %   WorkerVmIds=dbread(worker),
%    io:format("WorkerVmIds ~p~n",[{?MODULE,?LINE,WorkerVmIds}]),
   
    AvailableComputers=db_computer:status(available),
    _CleanComputers=[computer:clean_computer(HostId)||{HostId,available}<-AvailableComputers],
    io:format("AvailableComputers ~p~n",[{?MODULE,?LINE,AvailableComputers}]),
    io:format("RunningComputers ~p~n",[{?MODULE,?LINE,db_computer:status(running)}]),

    
%    _CleanComputers=[computer:clean_computer(HostId,ControlVmId)||HostId<-AvailableComputers],
%    io:format("CleanComputers ~p~n",[{?MODULE,?LINE,CleanComputers}]),

%    _StartComputers=[computer:start_computer(HostId,ControlVmId)||HostId<-AvailableComputers],
 %   io:format("StartComputers ~p~n",[{?MODULE,?LINE,StartComputers}]),  

   % _CleanVms=[computer:clean_vms(WorkerVmIds,HostId)||HostId<-AvailableComputers],
  %  io:format("CleanVms ~p~n",[{?MODULE,?LINE,CleanVms }]),

%    _StartVms=[computer:start_vms(WorkerVmIds,HostId)||HostId<-AvailableComputers],
 %   io:format("StartVms ~p~n",[{?MODULE,?LINE,StartVms}]),
  
   % RunningComputers=[HostId||{running,HostId}<-ComputerStatus],
   % VmStatus=[vms:status_vms(HostId,WorkerVmIds)||HostId<-RunningComputers],
 %   io:format("VmStatus ~p~n",[{?MODULE,?LINE,VmStatus}]),

  %  _CleanVms2=[computer:clean_vms(VmIds,HostId)||{HostId,_,{available,VmIds},_}<-VmStatus],
%    io:format("CleanVms2 ~p~n",[{?MODULE,?LINE,CleanVms2 }]),

  %  _StartVms2=[computer:start_vms(VmIds,HostId)||{HostId,_,{available,VmIds},_}<-VmStatus],
%    io:format("StartVms2 ~p~n",[{?MODULE,?LINE,StartVms2}]),
    
    
  %  ComputerStatus2=computer:status_computers(),
   % VmStatus2=[vms:status_vms(HostId,WorkerVmIds)||HostId<-RunningComputers],


    rpc:cast(node(),?MODULE,heart_beat,[{Interval,glurk,glurk}]).
  %  rpc:cast(node(),?MODULE,heart_beat,[{Interval,ComputerStatus2,VmStatus2}]).

%% --------------------------------------------------------------------
%% Internal functions
%% --------------------------------------------------------------------

%% --------------------------------------------------------------------
%% Function: 
%% Description:
%% Returns: non
%% --------------------------------------------------------------------

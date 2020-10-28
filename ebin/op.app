%% This is the application resource file (.app file) for the 'base'
%% application.
{application, op,
[{description, "op" },
{vsn, "0.0.1" },
{modules, 
	  [op_app,op_sup,op]},
{registered,[op]},
{applications, [kernel,stdlib]},
{mod, {op_app,[]}},
{start_phases, []}
]}.

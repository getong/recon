-module(recon_trace_SUITE).
-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").
-compile(export_all).

all() -> [dangerous_combo, dangerous_combo_specific_pids,
          dangerous_combo_self_pid, dangerous_combo_io_server_pid].

%%%%%%%%%%%%%
%%% TESTS %%%
%%%%%%%%%%%%%

dangerous_combo(_Config) ->
    ?assertError({dangerous_combo, {'_', '_', '_'}},
                  recon_trace:calls([{'_', '_', '_'}], 1)),
    ?assertError({dangerous_combo, {'_', '_', []}},
                  recon_trace:calls([{'_', '_', []}], 1)),
    ?assertError({dangerous_combo, {io, '_', []}},
                  recon_trace:calls([{io, '_', []}], 1)),
    ?assertError({dangerous_combo, {lists, '_', []}},
                  recon_trace:calls([{lists, '_', []}], 1)),
    ?assertError({dangerous_combo, {'_', '_', [{'_', [], [{return_trace}]}]}},
                  recon_trace:calls([{'_', '_', return_trace}], 1)),
    ?assertError({dangerous_combo, {io, '_', [{'_', [], [{return_trace}]}]}},
                  recon_trace:calls([{io, '_', return_trace}], 1)),
    ?assertError({dangerous_combo, {lists, '_', [{'_', [], [{return_trace}]}]}},
                  recon_trace:calls([{lists, '_', return_trace}], 1)),
    ?assertError({dangerous_combo, {recon_trace, '_', [{'_', [], [{return_trace}]}]}},
                  recon_trace:calls([{recon_trace, '_', return_trace}], 1)).

dangerous_combo_specific_pids(_Config) ->
    Pid = spawn(fun() -> timer:sleep(infinity) end),
    Pid2 = spawn(fun() -> timer:sleep(infinity) end),
    try
        recon_trace:calls([{'_', '_', '_'}], 1, [{pid, Pid}]),
        recon_trace:calls([{'_', '_', '_'}], 1, [{pid, [Pid, Pid2]}]),
        recon_trace:clear()
    after
        exit(Pid, kill),
        exit(Pid2, kill)
    end,
    ?assertError({dangerous_combo, {'_', '_', '_'}},
        recon_trace:calls([{'_', '_', '_'}], 1, [{pid, [new, Pid, Pid2]}])).

dangerous_combo_self_pid(_Config) ->
    ?assertError({dangerous_combo, {'_', '_', '_'}},
        recon_trace:calls([{'_', '_', '_'}], 1, [{pid, self()}])).

dangerous_combo_io_server_pid(_Config) ->
    GL = group_leader(),
    ?assertError({dangerous_combo, {'_', '_', '_'}},
        recon_trace:calls([{'_', '_', '_'}], 1, [{pid, GL}])).

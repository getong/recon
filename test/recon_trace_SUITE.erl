-module(recon_trace_SUITE).
-include_lib("common_test/include/ct.hrl").
-include_lib("eunit/include/eunit.hrl").
-compile(export_all).

all() -> [dangerous_combo].

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

:- module(value_dict, [value/1, description/2, support/2, discussion/2, example/3, example/4, lookup/3, value_lookup/1, set_example/4, get_example/4, set_example/3, get_example/3, set_current_discussion/1]).
:- dynamic tension/2.
:- dynamic support/2.
:- dynamic value/1.
:- dynamic description/2.
:- dynamic example/3.
:- dynamic example/4.
:- dynamic discussion/2.
:- dynamic current_discussion/1.

tension(?, ?).
value(?).
description(?, ?).
example(?, ?, ?, ?).
example(?, ?, ?).
discussion(?, ?).
current_discussion(?).

lookup(_, _, Goal) :-
  Goal.
lookup(Key, _, Goal) :-
  not(Goal),
  value_lookup(Key),
  assert(Goal).

set_current_discussion(Discussion) :-
  current_discussion(A),
  retract(current_discussion(A)),
  assert(current_discussion(Discussion)).

set_discussion(Example) :-
  current_discussion(A),
  assert(discussion(A, Example)).

set_example(Type, A, B, E) :-
  example(Type, A, B, E).
set_example(Type, A, B, E) :-
  not(example(Type, A, B, E)),
  set_discussion(E),
  assert(example(Type, A, B, E)).
set_example(Type, A, E) :-
  example(Type, A, E).
set_example(Type, A, E) :-
  not(example(Type, A, E)),
  set_discussion(E),
  assert(example(Type, A, E)).

get_example(Type, A, B, E) :-
  example(Type, A, B, E).

get_example(Type, A, E) :-
  example(Type, A, E).

value_lookup(Key) :-
  value(Key).
value_lookup(Key) :-
  not(value(Key)),
  assert(support(Key, ?)),
  assert(tension(Key, ?)),
  assert(value(Key)).

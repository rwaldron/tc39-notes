:- module(dot_emitter, [dot_emitter/1]).
:- use_module(value_dict).

get_color(support, "blue").
get_color(tension, "red").

dot_emitter([]).

dot_emitter(Ins) :-
  format("digraph {"),
  sub_emitter(Ins).

sub_emitter([]) :-
  format("}").
sub_emitter([?|Ins]) :-
  sub_emitter(Ins).
sub_emitter([In|Ins]) :-
  findall(X, lookup(In, X, tension(In, X)), Tensions),
  findall(X, lookup(In, X, support(In, X)), Supports),
  print_subgraph(tension, In, Tensions, blue),
  print_subgraph(support, In, Supports, red),
  sub_emitter(Ins).

print_subgraph(_, _, [], _).
print_subgraph(Type, A, [?|Ls], Color) :-
  print_subgraph(Type, A, Ls, Color).
print_subgraph(Type, A, Ls, Color) :-
  format("\n"),
  format("subgraph "),
  format(Type),
  format(" {"),
  print_segment(Type, A, Ls),
  format("}"),
  format("\n").

print_segment(_, _, []).
print_segment(Type, A, [?|Ls]) :-
  print_segment(Type, A, Ls).

print_segment(Type, A, [" "|Ls]) :-
  print_segment(Type, A, Ls).

print_segment(Type, A, [L|Ls]) :-
  format(A),
  format("->"),
  format(L),
  format(" "),
  format("[style=\"stroke: "),
  get_color(Type, Color),
  format(Color),
  format(";"),
  format("stroke-width: 2px;\" arrowheadStyle=\"fill: #f77\"]"),
  format("\n"),
  print_segment(Type, A, Ls).


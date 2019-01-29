:- module(pl_emitter, [pl_emitter/1]).
:- use_module(value_dict).

pl_emitter([]).
pl_emitter(Ins) :-
  format(":- use_module(library(clpfd))."),
  format("\n"),
  format(":- use_module(value_dict)."),
  format("\n"),
  print_info(Ins).

print_info([]).
print_info([In|Ins]) :-
  findall(X, get_example(value, In, X), ExampleValue),
  findall(X, lookup(In, X, tension(In, X)), Tensions),
  findall(X, lookup(In, X, support(In, X)), Supports),
  format("\n"),
  print_value(value, In, ExampleValue),
  format("\n"),
  print_segment(tension, In, Tensions, _),
  format("\n"),
  print_segment(support, In, Supports, _),
  format("\n"),
  print_info(Ins).

print_value(_, _, []).
print_value(Type, A, Out) :-
  print_examples(Type, A, Out).

print_segment(_, _, [], []).
print_segment(Type, A, [" "|Ls], Outs) :-
  print_segment(Type, A, Ls, Outs).

print_segment(Type, A, [L|Ls], [Out|Outs]) :-
  format(Type),
  format("("),
  format(A),
  format(","),
  format(L),
  format(")"),
  format("."),
  format("\n"),
  findall(X, get_example(Type, A, L, X), Out),
  print_examples(Type, A, L, Out),
  print_segment(Type, A, Ls, Outs).

print_examples(_, _, []).
print_examples(Type, A, [In|Ins]) :-
  format("value_lookup"),
  format("("),
  format(A),
  format(")"),
  format("."),
  format("\n"),
  format("set_example"),
  format("("),
  format(Type),
  format(","),
  format(A),
  format(","),
  format(In),
  format(")"),
  format("."),
  format("\n"),
  discussion(Discussion, In),
  format("set_discussion"),
  format("("),
  format(Discussion),
  format(In),
  format(")"),
  format("."),
  format("\n"),
  print_examples(Type, A, Ins).

print_examples(_, _, _, []).
print_examples(Type, A, B, [In|Ins]) :-
  format("set_example"),
  format("("),
  format(Type),
  format(","),
  format(A),
  format(","),
  format(B),
  format(","),
  format("\""),
  format(In),
  format("\""),
  format(")"),
  format("."),
  format("\n"),
  discussion(Discussion, In),
  format("set_discussion"),
  format("("),
  format("\""),
  format(Discussion),
  format("\""),
  format(","),
  format("\""),
  format(In),
  format("\""),
  format(")"),
  format("."),
  format("\n"),
  print_examples(Type, A, Ins).




:- module(print_info, [print_info/1, print_segment/4]).
:- use_module(value_dict).

print_info([]).
print_info([In|Ins]) :-
  findall(X, get_example(value, In, X), ExampleValue),
  findall(X, lookup(In, X, tension(In, X)), Tensions),
  findall(X, lookup(In, X, support(In, X)), Supports),
  format("Value: "),
  format(In),
  format("\n"),
  format("Examples:"),
  format("\n"),
  print_examples(ExampleValue),
  format("\n"),
  print_segment(tension, In, Tensions, _),
  format("\n"),
  print_segment(support, In, Supports, _),
  format("---"),
  format("\n"),
  format("\n"),
  print_info(Ins).

print_segment(_, _, [], []).
print_segment(Type, A, [?|Ls], Outs) :-
  print_segment(Type, A, Ls, Outs).

print_segment(Type, A, [" "|Ls], Outs) :-
  print_segment(Type, A, Ls, Outs).

print_segment(Type, A, [L|Ls], [Out|Outs]) :-
  format("\n"),
  format("Edge Type: "),
  format(Type),
  format("\n"),
  format(A),
  format("->"),
  format(L),
  format("\n"),
  format("\n"),
  findall(X, get_example(Type, A, L, X), Out),
  format("Examples:"),
  print_examples(Out),
  print_segment(Type, A, Ls, Outs).

print_examples([]).
print_examples([In|Ins]) :-
  format("Text:"),
  format("\n"),
  format(In),
  format("\n"),
  format("Found in:"),
  discussion(Discussion, In),
  format(Discussion),
  format("\n"),
  print_examples(Ins).

print_discussion([]).
print_discussion([In|Ins]) :-
  format("Example:"),
  format("\n"),
  format(In),
  format("\n"),
  format("All Interactions:"),
  findall([B, A, L], get_example(B, A, L, In), Out),
  format("\n"),
  print(Out),
  format("\n"),
  print_examples(Ins).


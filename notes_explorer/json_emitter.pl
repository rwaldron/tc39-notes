:- module(json_emitter, [json_emitter/1]).
:- use_module(value_dict).

json_emitter([]).
json_emitter(Ins) :-
  format("\n"),
  format("["),
  format("\n"),
  print_info(Ins).

print_info([]) :-
  format("]").
print_info([In|Ins]) :-
  findall(X, get_example(value, In, X), ExampleValue),
  findall(X, lookup(In, X, tension(In, X)), Tensions),
  findall(X, lookup(In, X, support(In, X)), Supports),
  format("\n"),
  format("{"),
  format("\n"),
  format("\"value\": "),
  format("\""),
  format(In),
  format("\""),
  format(","),
  format("\n"),
  format("\"examples\": ["),
  format("\n"),
  print_examples(ExampleValue),
  format("\n"),
  format("],"),
  format("\n"),
  format("\"tensions\": ["),
  print_segment(tension, In, Tensions, _),
  format("],"),
  format("\n"),
  format("\"supports\": ["),
  print_segment(support, In, Supports, _),
  format("]"),
  format("\n"),
  format("}"),
  has_coma(Ins),
  format("\n"),
  print_info(Ins).

has_coma([]).
has_coma(Ins) :-
  format(","),
  format("\n").

print_segment(_, _, [], []).
print_segment(Type, A, [?|Ls], Outs) :-
  print_segment(Type, A, Ls, Outs).

print_segment(Type, A, [" "|Ls], Outs) :-
  print_segment(Type, A, Ls, Outs).

print_segment(Type, A, [L|Ls], [Out|Outs]) :-
  format("\n"),
  format("{"),
  format("\n"),
  format("\"value\": "),
  format("\""),
  format(L),
  format("\""),
  format(","),
  format("\n"),
  findall(X, get_example(Type, A, L, X), Out),
  format("\"examples\": ["),
  format("\n"),
  print_examples(Out),
  format("]"),
  format("\n"),
  format("}"),
  has_coma(Ls),
  format("\n"),
  print_segment(Type, A, Ls, Outs).

print_examples([]).
print_examples([In|Ins]) :-
  format("{"),
  format("\n"),
  format("\"text\":"),
  format("\""),
  format(In),
  format("\""),
  format(","),
  format("\n"),
  format("\"foundIn\":"),
  discussion(Discussion, In),
  replace_substring(Discussion, "\"", "\\\"", NewDiscussion),
  format("\""),
  format(NewDiscussion),
  format("\""),
  format("\n"),
  format("}"),
  has_coma(Ins),
  format("\n"),
  print_examples(Ins).

replace_substring(String, To_Replace, Replace_With, Result) :-
    (    append([Front, To_Replace, Back], String)
    ->   append([Front, Replace_With, Back], R),
         replace_substring(Back, To_Replace, Replace_with, Result)
    ;    Result = String
    ).

:- use_module(library(clpfd)).
:- use_module(value_dict).
:- use_module(print_info).
:- use_module(dot_emitter).
:- use_module(json_emitter).
:- use_module(pl_emitter).

expr(A) --> a_instruction(A) | c_instruction(A).

load_note(Argv) :-
  string_concat(Argv, '.md', Input),
  open(Input, read, Str),
  read_file(Str),
  close(Str).

write_to_dot :-
  findall(X, value(X), Vals),
  dot_emitter(Vals).

write_to_pl :-
  findall(X, value(X), Vals),
  pl_emitter(Vals).

write_to_json :-
  findall(X, value(X), Vals),
  json_emitter(Vals).

write_to_text :-
  findall(X, value(X), Vals),
  print_info(Vals).

inspect_value_tensions(Value) :-
  findall(X, lookup(Value, X, tension(Value, X)), Tensions),
  format("Inspecting tensions for:"),
  format(Value),
  format("\n"),
  print_segment(tension, Value, Tensions, _).

inspect_value_supports(Value) :-
  findall(X, lookup(Value, X, support(Value, X)), Supports),
  format("Inspecting supports for:"),
  format(Value),
  format("\n"),
  print_segment(supports, Value, Supports, _).

inspect_value(Value) :-
  print_info([Value]).

inspect_discussion(DiscussionName) :-
  findall(X, lookup(Value, X, discussion(X, DiscussionName)), Discussions),
  format("Discussion:"),
  format("\n"),
  format(DiscussionName),
  format("\n"),
  print_discussion(Discussions).

read_file(Stream) :-
  \+ at_end_of_stream(Stream),
  read_line_to_string(Stream,Tmp),
  test_string(Stream, Tmp),
  read_file(Stream).

read_file(Stream) :-
  at_end_of_stream(Stream).

test_string(Stream, String) :-
  \+ skip_line(String),
  parse_line(String, Group),
  next_line(Stream, Group2, Example),
  append(Group, Group2, Groups),
  build_relationship(Groups, _, Example).

test_string(Stream, String) :-
  is_discussion(String),
  set_c_discussion(Stream).

test_string(_, String) :-
  skip_line(String).

is_discussion(String) :-
  String = "[Discussion]".

set_c_discussion(Stream) :-
  at_end_of_stream(Stream).

set_c_discussion(Stream) :-
  \+ at_end_of_stream(Stream),
  read_line_to_string(Stream, String),
  set_current_discussion(String).

skip_line(String) :-
  not(sub_string(String, 0, 7, _, _)).

skip_line("").
skip_line(String) :-
  sub_string(String, 0, 7, _, TestString),
  not(TestString = "[Value:").

parse_line(String, Groups) :-
  string_length(String, Length),
  Newlength is Length - 2,
  sub_string(String, 1, Newlength, _, SubString),
  split_string(SubString, " ", "", Groups).

next_line(Stream, Values, Out) :-
  \+ at_end_of_stream(Stream),
  read_line_to_string(Stream, String),
  check_line(Stream, String, Values, Out).

check_line(Stream, String, Values, Out) :-
  \+ skip_line(String),
  parse_line(String, Value),
  next_line(Stream, NextValues, Out),
  append(Value, NextValues, Values).

check_line(_, String, [], String) :-
  skip_line(String).

build_relationship([], _, _).
build_relationship([Group|Groups], _, Example) :-
  split_string(Group, ":", "", [Key,V]),
  Key = "Value",
  atom_string(AtomValue, V),
  downcase_atom(AtomValue, Value),
  value_lookup(Value),
  set_example(value, Value, Example),
  build_relationship(Groups, Value, Example).

build_relationship([Group|Groups], Ref, Example) :-
  split_string(Group, ":", "", [Key,V]),
  Key = "Tension",
  atom_string(AtomValue, V),
  downcase_atom(AtomValue, Value),
  lookup(Ref, Value, tension(Ref,Value)),
  set_example(tension, Ref, Value, Example),
  build_relationship(Groups, Ref, Example).

build_relationship([Group|Groups], Ref, Example) :-
  split_string(Group, ":", "", [Key,V]),
  Key = "Support",
  atom_string(AtomValue, V),
  downcase_atom(AtomValue, Value),
  lookup(Ref, Value, support(Ref, Value)),
  set_example(support, Ref, Value, Example),
  build_relationship(Groups, Ref, Example).


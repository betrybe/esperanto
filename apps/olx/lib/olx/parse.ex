defmodule Olx.Parser do
  alias Olx

  @type tree() :: NaryTree.t()

  @doc """
  Parse given input
  paremters:
    * `walker`- Parse is responsible to walk trough input
    * `tree`- Current AST tree
    * `parent_id`- id of the parent node
    * `opts`- id of the parent node
  returns: A tuple with the new tree and new walker
  """
  @callback parse(walker::Walker.t(), tree::tree(), parent_id::integer(), opts::keyword())::{ tree(), Walker.t()}
  @doc """
  Parse given input
  paremters:
    * `walker`- Parse is responsible to walk trough input
    * `tree`- Current AST tree
    * `parent_id`- id of the parent node
    * `opts`- id of the parent node
  returns: true if the the parse should be used. Note that if two parsers returns true an `AmbigousSyntaxError` is raised
  """
  @callback should_parse(walker::Walker.t(), tree::tree(), parent_id::integer(), opts::keyword())::boolean()

end

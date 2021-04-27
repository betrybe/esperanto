defmodule Olx.Parser do
  alias NaryTree.Tree
  alias NaryTree.Node
  alias Olx

  @type ast_node() :: NaryTree.Node.t()
  @type tree() :: NaryTree.t()

  @callback parse(String.t(), tree(), ast_node(), keyword())::{ ast_node(), String.t()}
  @callback should_parse(String.t(), tree(), node(), keyword())::boolean()

end

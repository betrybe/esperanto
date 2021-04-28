defmodule Olx.Parser do
  alias Olx

  @type ast_node() :: NaryTree.Node.t()
  @type tree() :: NaryTree.t()

  @callback parse(Walker.t(), tree(), ast_node(), keyword())::{ ast_node(), Walker.t()}
  @callback should_parse(Walker.t(), tree(), node(), keyword())::boolean()

end

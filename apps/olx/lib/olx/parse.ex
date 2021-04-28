defmodule Olx.Parser do
  alias Olx

  @type ast_node() :: NaryTree.Node.t()
  @type tree() :: NaryTree.t()

  @doc """
  Parse given input

    * `real_time_url`- Url to fetch bus coordinates, default to `https://temporeal.pbh.gov.br/?param=C"`
    * `pull_interval`- Time in miliseconds that should be pulled", default to `60s`
    * `bus_line_provider`- Default to `Crawler.CachexBusLineProvider`
  """
  @callback parse(Walker.t(), tree(), ast_node(), keyword())::{ ast_node(), Walker.t()}
  @callback should_parse(Walker.t(), tree(), node(), keyword())::boolean()

end

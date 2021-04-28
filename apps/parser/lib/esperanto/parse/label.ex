defmodule Esperanto.Parse.Label do
  def astify(
        %Markright.Continuation{ast: {:blockquote, attrs, [<<">", label::binary>> | rest]}} = cont
      ) do
    {label_elements, rest} =
      Enum.split_while([label] ++ rest, fn
        x when is_binary(x) -> !String.ends_with?(x, "<<")
        _ -> true
      end)

    # split while leaves de << element in the second list ...
    # lets transfer it to the first list
    {end_element, rest} =
      case List.pop_at(rest, 0) do
        {nil, rest} -> {nil, rest}
        {end_element, rest} -> {String.replace_suffix(end_element, "<<", ""), rest}
      end

    label_elements = label_elements ++ [end_element]
    %Markright.Continuation{cont | ast: [{:label, attrs, unwrapper_list(label_elements)}] ++ rest}
  end

  def astify(%Markright.Continuation{ast: {:blockquote, _attrs, _ast}} = cont) do
    cont
  end

  # unwapper a list if it has only 1 element
  defp unwrapper_list([x]), do: x
  defp unwrapper_list(x), do: x
end

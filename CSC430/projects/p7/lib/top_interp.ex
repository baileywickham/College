defmodule TopInterp do
  @doc """
  Given a program in the surface language expressed as an s-expression, evaluates it and returns the
  result, or raises an error if the program is malformatted
  """
  def top_interp(str) do
    str
    |> Tokenize.tokenize()
    |> Parse.parse()
    |> Interp.interp(TopEnv.top_env())
    |> Serialize.serialize()
  end
end

defmodule DxuqError, do: defexception(message: "encountered an error while evaluating")

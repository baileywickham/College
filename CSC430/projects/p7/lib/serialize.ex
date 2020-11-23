defmodule Serialize do
  @doc """
  Given a value, returns a string representation
  """
  def serialize(v) do
    case v do
      %ClosV{} -> "#<procedure>"
      %PrimV{} -> "#<primop>"
      int when is_integer(int) -> "#{int}"
      str when is_bitstring(str) -> "\"#{str}\""
      bool when is_boolean(bool) -> if bool, do: "true", else: "false"
    end
  end
end

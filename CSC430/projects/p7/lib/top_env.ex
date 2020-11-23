defmodule TopEnv do
  @doc """
  Globally scoped top environment containing prim-ops and boolean values
  (Made this a function, so it does not have to be below all the functions it calls)
  """
  def top_env do
    %{
      true => true,
      false => false,
      :+ => binop_prim(&(&1 + &2)),
      :* => binop_prim(&(&1 * &2)),
      :- => binop_prim(&(&1 - &2)),
      :/ => binop_prim(&div_safe/2),
      :<= => binop_prim(&(&1 <= &2)),
      :error => %PrimV{
        o: &error_prim/1,
        arity: 1
      },
      :equal? => %PrimV{
        o: &equal_prim/1,
        arity: 2
      }
    }
  end

  @doc """
  Given a function that expects 2 reals, creates a PrimV representation
  """
  def binop_prim(o) do
    %PrimV{o: &o.(check_int(hd(&1)), check_int(hd(tl(&1)))), arity: 2}
  end

  @doc """
  Given a list containing 2 Values, returns whether they are both comparable and equal
  """
  def error_prim(v) do
    raise DxuqError, message: "User error: #{Serialize.serialize(hd(v))}"
  end

  @doc """
  Given a list containing 1 Value, raises an error containing DXUQ, user error, and the
  serialization of the value
  """
  def equal_prim(v) do
    comparable(hd(v)) and comparable(hd(tl(v))) and hd(v) == hd(tl(v))
  end

  @doc """
  Given a value, determines whether it is comparable, not a procedure
  """
  def comparable(v) do
    case v do
      %PrimV{} -> false
      %ClosV{} -> false
      _ -> true
    end
  end

  @doc """
  A version of division that throws our error (instead of the racket error) when dividing by 0
  """
  def div_safe(l, r) do
    if r == 0 do
      raise DxuqError, message: "Cannot divide #{l} by 0"
    end

    l / r
  end

  @doc """
  Wraps a value and ensures it is an int, throwing an error otherwise
  """
  def check_int(v) do
    unless is_integer(v) do
      raise DxuqError, message: "Type mismatch: #{Serialize.serialize(v)} is not an integer"
    end

    v
  end
end

defmodule Tokenize do
  @doc """
  Given a string representation of an s-expression converts it to an s-expression
  """
  def tokenize(string) do
    string
    |> split_strings
    |> split_spaces
    |> split_braces
    |> parse_sexp
    |> elem(0)
    |> hd
  end

  @doc """
  Given a string, splits it into sections representing strings and sections representing
  code, delimited by quotes
  """
  def split_strings(split) do
    String.split(split, ~r|(?<!\\)"|, include_captures: true)
  end

  @doc """
  Given a list containing strings representing either strings or blocks of code,
  breaks the blocks of code apart and wraps the strings in a struct for bookkeeping
  """
  def split_spaces(splits) do
    case splits do
      [] -> []
      ["\"", str, "\"" | rest] -> [%Str{str: str} | split_spaces(rest)]
      [syntax | rest] -> String.split(syntax, ~r|\s+|, trim: true) ++ split_spaces(rest)
    end
  end

  @doc """
  Given a list containing blocks of code and strings wrapped in structs, breaks up
  the blocks of code by curly braces and leaves the strings alone
  """
  def split_braces(splits) do
    for s <- splits do
      case s do
        %Str{} -> s
        _ -> String.split(s, ~r|[\{\}]|, include_captures: true, trim: true)
      end
    end
    |> List.flatten()
  end

  @doc """
  If a value is wrapped in a string struct, unwraps it and does a bit of string
  escape character handling. Given a non string value, if it is an integer casts
  it to that and otherwise casts it to an atom
  """
  def parse_val(%Str{str: str}) do
    str
    |> String.replace("\\\"", "\"")
    |> String.replace("\\n", "\n")
  end

  def parse_val(other) do
    cond do
      String.match?(other, ~r|^[-+]?\d+$|) -> String.to_integer(other)
      true -> String.to_atom(other)
    end
  end

  @doc """
  Given a string that has been fully split into a list with curly braces and literals
  parses that into an s-expression and returns that s-expression in a tuple with the
  remainder of the list that was not parsed
  """
  def parse_sexp(input) do
    case input do
      ["{" | rest] ->
        {inside, remainder} = parse_sexp(rest)
        {r1, r2} = parse_sexp(remainder)
        {[inside | r1], r2}

      ["}" | rest] ->
        {[], rest}

      [val | rest] ->
        {inside, remainder} = parse_sexp(rest)
        {[parse_val(val) | inside], remainder}

      [] ->
        {[], []}
    end
  end
end

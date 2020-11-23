defmodule TopInterpTest do
  use ExUnit.Case

  test "top level stress tests" do
    assert TopInterp.top_interp("{+ 2 3}") == "5"
    assert TopInterp.top_interp("{{fn {a b} {+ a b}} 2 3}") == "5"
    assert TopInterp.top_interp("{let {a = 2} {f = {fn {x y} {* x y}}} in {f a 3}}") == "6"
    assert TopInterp.top_interp("{if true \"hello\" \"hi\"}") == "\"hello\""
    assert TopInterp.top_interp("{<= 2 2}") == "true"

    assert TopInterp.top_interp("{let {add = {fn {nlf1} {fn {nlf2}                   
                                                              {fn {f} {fn {a} {{nlf1 f} {{nlf2 f} a}}}}}}}
                                    {one = {fn {f} {fn {a} {f a}}}}                   
                                    {two = {fn {f} {fn {a} {f {f a}}}}}               
                                    {double = {fn {x} {* 2 x}}}                       
                                    in {if {equal? {{{{add one} two} double} 1} 8}    
                                            \"Result Correct\" \"Result Incorrect\"}}") ==
             "\"Result Correct\""
  end
end

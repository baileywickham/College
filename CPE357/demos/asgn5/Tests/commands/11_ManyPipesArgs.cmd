NAME: 08_ManyPipesArgs
INPUT: ls a b c | tee /dev/null |  tee /dev/null |  tee /dev/null | tee /dev/null 
SHOULDFAIL: no

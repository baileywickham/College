rm p03 two *.run
gcc -Wall p03.c -o p03
gcc two.c -o two

./p03 500 ./two 1 : ./two 2 : ./two 3 > 500.run
./p03 10000 ./two 1 : ./two 2 : ./two 3 > 10k.run
diff 500.run 500.expected
diff 10k.run 10k.expected


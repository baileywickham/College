rm -f a.out
make
./a.out 10 4 > 10.4.run
diff 10.4.expected 10.4.run
#./a.out 10000 5 10k.5.run

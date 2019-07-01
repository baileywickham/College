
for i in 1 2 16 32 64 128 256 512 1024 2048
do
    echo "bytes $i"
    time ./reads.out $i
    time ./freads.out $i
    echo "\n"
done

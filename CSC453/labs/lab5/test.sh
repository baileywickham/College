#!/bin/bash
rm test.out
for i in $(seq 1 20); do ./a.out 10000 >> test.out; done
diff test.out test.valid

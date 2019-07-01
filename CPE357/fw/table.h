typedef struct  {
    char* word;
    int count;
} WordBucket;

typedef struct {
    int size;
    int num_items;
    WordBucket** buckets;
    int top;
} Table;

WordBucket* find(unsigned long, Table*, char*);
unsigned long hash(char*, int);
Table* insert(unsigned long, WordBucket*, Table*);
void printTable(WordBucket**, int);
float getLoadFactor(Table*);
Table* resize(Table*);
void freeTable(Table*);

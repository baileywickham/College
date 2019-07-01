#ifndef PART5_H
#define PART5_H

struct point {
    double x;
    double y;
};

typedef struct {
    struct point tl;
    struct point br;
} Rect;

struct point create_point(double x, double y);
double is_a_square(Rect r);

#endif

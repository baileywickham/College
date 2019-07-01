#include "part6.h"

struct point create_point(double x, double y)
{
    struct point p = { x, y };
    return p;
}

double is_a_square(Rect r)
{
    return r.tl.y - r.br.y == r.tl.x - r.br.x;
}

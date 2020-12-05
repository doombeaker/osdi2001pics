size(80cm, 25cm);
unitsize(30, 0);
defaultpen(fontsize(12pt));

//circle radius
real rsize = 0.4;
real shiftscale = 1.4;
real shiftunit = 2.5;
pen fillpen = rgb(156,194,230);

picture getCircle(string s, pair pos, pen p = defaultpen)
{
    picture pic;
    path pt_circle = circle(pos, rsize);
    draw(pic, pt_circle, p);
    label(pic, s, pos);
    return pic;
}

picture LineLeft2Rgiht(picture nodeLeft, picture nodeRight)
{
    picture pic;
    path l2r = point(nodeLeft, E){right}..{right}point(nodeRight, W);
    draw(pic, l2r, Arrow);
    return pic;
}

picture LineUp2Down(picture nodeUp, picture nodeDown)
{
    picture pic;
    path pth = point(nodeUp, S){down}..{down}point(nodeDown, N);
    draw(pic, pth, Arrow);
    return pic;
}

picture LineRight2Left(picture nodeRight, picture nodeLeft)
{
    picture pic;
    path pth = point(nodeRight, W){left}..{left}point(nodeLeft, E);
    draw(pic, pth, Arrow);
    return pic;
}

picture f1= getCircle("$f_1$", (0,0));
add(f1);

picture f2= getCircle("$f_2$", (shiftunit,0));
add(f2);

picture f3= getCircle("$f_3$", (2shiftunit,0));
add(f3);

picture b1= getCircle("$b_1$", (0, -0.6shiftunit));
add(b1);

picture b2= getCircle("$b_2$", (shiftunit, -0.6shiftunit));
add(b2);

picture b3= getCircle("$b_3$", (2shiftunit, -0.6shiftunit));
add(b3);

add(LineLeft2Rgiht(f1, f2));
add(LineLeft2Rgiht(f2, f3));
add(LineRight2Left(b3, b2));
add(LineRight2Left(b2, b1));
add(LineUp2Down(f1, b1));
add(LineUp2Down(f2, b2));
add(LineUp2Down(f3, b3));






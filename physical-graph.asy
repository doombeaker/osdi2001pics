import math;

size(80cm, 25cm);
unitsize(30, 0);
defaultpen(fontsize(12pt));

//circle radius
real rsize = 0.4;
real shiftscale = 1.4;

picture getCircle(string s, pair pos, pen p = defaultpen)
{
    picture pic;
    path pt_circle = circle(pos, rsize);
    filldraw(pic, pt_circle, p);
    label(pic, s, pos);
    return pic;
}

picture getRectBox(string s, pen p = lightgray, bool leftdown=true)
{
    picture pic;
    real xsize = 2.5;
    path boxpath = box((0,0), (xsize, xsize*0.618));
    filldraw(pic, boxpath, p);

    // dot(pic, boxpath, darkblue);
    label(pic, s, (0,0), NE,fontsize(8pt));
    return pic;
}

picture getCircleFromBox(picture boxpic, string s="", int idx=0, pen p = currentpen)
{
    picture pic;
    pair leftedge_pt = point(boxpic, W);
    pair rightedt_pt = point(boxpic, E);

    pair cir_pt = shift(shiftscale*rsize, 0)*leftedge_pt;
    if(idx == 1)
    {
        cir_pt = shift(-shiftscale*rsize, 0)*rightedt_pt;
    }

    // dot(pic, cir_pt);
    // write(cir_pt);

    path circle_path = circle(cir_pt, rsize);
    filldraw(pic, circle_path, p);
    
    label(pic, s, cir_pt);
    return pic;
}

picture getCircleBtween4Box(picture LeftUp, picture LeftDown,
                            picture RightUp, picture RightDown,
                            string s="",
                            pen p = currentpen)
{
    picture pic;
    pair ptLeftUp = point(LeftUp, E);
    pair ptLeftDown = point(LeftDown, E);
    pair ptRightUp = point(RightUp, W);
    pair ptRightDown = point(RightDown, W);

    pair ptCenter = midpoint(ptLeftUp--ptLeftDown--ptRightUp--ptRightDown);

    path cir_path = circle(ptCenter, rsize);
    filldraw(cir_path, p);
    label(pic, s, ptCenter);
    // write(ptCenter);
    // dot(pic, ptCenter);

    return pic;
}

real shiftunit = 3;
picture boxpic00 = shift(0, 0)*getRectBox("$d_1$", false);
picture boxpic01 = shift(1shiftunit, 0)*getRectBox("$d_3$", false);
picture boxpic02 = shift(2shiftunit, 0)*getRectBox("$d_1$", false);
picture boxpic03 = shift(3.5shiftunit, 0)*getRectBox("$d_1$", false);
add(boxpic00);
add(boxpic01);
add(boxpic02);
add(boxpic03);

real yshift=-1.1shiftunit;
picture boxpic10 = shift(0, yshift)*getRectBox("$d_2$", false);
picture boxpic11 = shift(1shiftunit, yshift)*getRectBox("$d_4$", false);
picture boxpic12 = shift(2shiftunit, yshift)*getRectBox("$d_2$", false);
picture boxpic13 = shift(3.5shiftunit, yshift)*getRectBox("$d_2$", false);
add(boxpic10);
add(boxpic11);
add(boxpic12);
add(boxpic13);

//-------------Draw circle node in box--------------


picture f11 = getCircleFromBox(boxpic00, "$f_{11}$", white);
picture f12 = getCircleFromBox(boxpic00, "$f_{12}$", 1, white);
add(f11);
add(f12);

picture f13 = getCircleFromBox(boxpic01, "$f_{13}$", white);
picture b13 = getCircleFromBox(boxpic01, "$b_{13}$", 1, white);
add(f13);
add(b13);

picture b12 = getCircleFromBox(boxpic02, "$b_{12}$", white);
picture b11 = getCircleFromBox(boxpic02, "$b_{11}$", 1, white);
add(b12);
add(b11);

picture f31 = getCircleFromBox(boxpic03, "$f_{31}$", 0, white);
picture f12 = getCircleFromBox(boxpic03, "$f_{12}$", 1, white);
add(f31);
add(f12);

picture f21 = getCircleFromBox(boxpic10, "$f_{21}$", 0, white);
picture f22 = getCircleFromBox(boxpic10, "$f_{22}$", 1, white);
add(f21);
add(f22);

picture f23 = getCircleFromBox(boxpic11, "$f_{23}$", 0, white);
picture b23 = getCircleFromBox(boxpic11, "$b_{23}$", 1, white);
add(f23);
add(b23);

picture b22 = getCircleFromBox(boxpic12, "$b_{22}$", 0, white);
picture b21 = getCircleFromBox(boxpic12, "$b_{21}$", 1, white);
add(b22);
add(b21);

picture f41 = getCircleFromBox(boxpic13, "$f_{41}$", 0, white);
picture f12 = getCircleFromBox(boxpic13, "$f_{12}$", 1, white);
add(f41);
add(f12);

// ------------ draw circle node out of box --------
picture g = getCircleBtween4Box(boxpic00, boxpic01, boxpic10, boxpic11, "$g$", Cyan);
add(g);

picture s = getCircleBtween4Box(boxpic01, boxpic02, boxpic11, boxpic12, "$s$", Cyan);
add(s);

picture r1 = getCircleBtween4Box(boxpic02, boxpic03, boxpic12, boxpic13, "$r_1$", Cyan);
add(r1);

picture r2;
pair ptR2 = midpoint(point(b11, S)--point(b21, N));
r2 = getCircle("$r_2$", ptR2, Cyan);
add(r2);

picture c11;
pair ptC11 = shift(-shiftscale, 0)*point(boxpic00, W);
c11 = getCircle("$c_{11}$", ptC11, Cyan);
add(c11);

picture c21;
pair ptC21 = shift(-shiftscale, 0)*point(boxpic10, W);
c21 = getCircle("$c_{21}$", ptC21, Cyan);
add(c21);

picture c31;
pair ptC31 = midpoint(point(boxpic02, E)--point(boxpic03, W));
c31 = getCircle("$c_{31}$", ptC31, Cyan);
add(c31);

picture c41;
pair ptC41 = midpoint(point(boxpic12, E)--point(boxpic13, W));
c41 = getCircle("$c_{41}$", ptC41, Cyan);
add(c41);
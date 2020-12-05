import math;

size(80cm, 25cm);
unitsize(30, 0);
defaultpen(fontsize(12pt));

//circle radius
real rsize = 0.4;
real shiftscale = 1.4;
real shiftunit = 4.5;
pen fillpen = rgb(156,194,230);

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
    filldraw(pic, cir_path, p);
    label(pic, s, ptCenter);
    // write(ptCenter);
    // dot(pic, ptCenter);

    return pic;
}

picture LineTwo2One(picture nodeUp, picture nodeDown, picture nodeMidlle)
{
    picture pic;
    path up2Mid = point(nodeUp, E){right}..{SE}point(nodeMidlle, W);
    draw(pic, up2Mid, Arrow);
    path down2Mid = point(nodeDown, E){right}..{NE}point(nodeMidlle, W);
    draw(pic, down2Mid, Arrow);
    return pic;
}

picture LineOne2Two(picture nodeMidlle, picture nodeUp, picture nodeDown)
{
    picture pic;
    path mid2Up = point(nodeMidlle, E){NE}..{right}point(nodeUp, W);
    draw(pic, mid2Up, Arrow);
    path mid2Down = point(nodeMidlle, E){SE}..{right}point(nodeDown, W);
    draw(pic, mid2Down, Arrow);
    return pic;
}

picture LineLeft2Rgiht(picture nodeLeft, picture nodeRight)
{
    picture pic;
    path l2r = point(nodeLeft, E){right}..{right}point(nodeRight, W);
    draw(pic, l2r, Arrow);
    return pic;
}

picture LineUpCurve(picture nodeLeft, picture nodeRight, int tvalue=5)
{
    picture pic;
    path left2right= point(nodeLeft, N){up}.. tension tvalue ..{down}point(nodeRight, N);
    draw(pic, left2right, Arrow);
    return pic;
}

picture LineDownCurve(picture nodeLeft, picture nodeRight, int tvalue=5)
{
    picture pic;
    path left2right= point(nodeLeft, S){down}.. tension tvalue ..{up}point(nodeRight, S);
    draw(pic, left2right, Arrow);
    return pic;
}

picture boxpic00 = shift(0, 0)*getRectBox("$d_1$", false);
picture boxpic01 = shift(1shiftunit, 0)*getRectBox("$d_3$", false);
picture boxpic02 = shift(2shiftunit, 0)*getRectBox("$d_1$", false);
picture boxpic03 = shift(3.5shiftunit, 0)*getRectBox("$d_1$", false);
add(boxpic00);
add(boxpic01);
add(boxpic02);
add(boxpic03);

real yshift=-shiftunit;
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
picture f12_ = getCircleFromBox(boxpic03, "$f_{12}$", 1, white);
add(f31);
add(f12_);

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
picture f12__ = getCircleFromBox(boxpic13, "$f_{12}$", 1, white);
add(f41);
add(f12__);

// ------------ draw circle node out of box --------
picture g = getCircleBtween4Box(boxpic00, boxpic01, boxpic10, boxpic11, "$g$", fillpen);
write(point(g, E));
write(point(g, W));
write(point(g, S));
write(point(g, N));
add(g);

picture s = getCircleBtween4Box(boxpic01, boxpic02, boxpic11, boxpic12, "$s$", fillpen);
add(s);

picture r1 = getCircleBtween4Box(boxpic02, boxpic03, boxpic12, boxpic13, "$r_1$", fillpen);
add(r1);

picture r2;
pair ptR2 = midpoint(point(b11, S)--point(b21, N));
r2 = getCircle("$r_2$", ptR2, fillpen);
add(r2);

picture c11;
pair ptC11 = shift(-shiftscale, 0)*point(boxpic00, W);
c11 = getCircle("$c_{11}$", ptC11, fillpen);
add(c11);

picture c21;
pair ptC21 = shift(-shiftscale, 0)*point(boxpic10, W);
c21 = getCircle("$c_{21}$", ptC21, fillpen);
add(c21);

picture c31;
pair ptC31 = midpoint(point(boxpic02, E)--point(boxpic03, W));
c31 = getCircle("$c_{31}$", ptC31, fillpen);
add(c31);

picture c41;
pair ptC41 = midpoint(point(boxpic12, E)--point(boxpic13, W));
c41 = getCircle("$c_{41}$", ptC41, fillpen);
add(c41);

//----------- draw link lines

//two to ones, one to twos
add(LineTwo2One(f12, f22, g));
add(LineOne2Two(g, f13, f23));
add(LineTwo2One(b13, b23, s));
add(LineOne2Two(s, b12, b22));
add(LineTwo2One(b12, b22, r2));
add(LineTwo2One(b11, b21, r1));
add(LineOne2Two(r1, f31, f41));

// strait lines
//   row 1
add(LineLeft2Rgiht(c11, f11));
add(LineLeft2Rgiht(f11, f12));

add(LineLeft2Rgiht(f13, b13));

add(LineLeft2Rgiht(b12, b11));

add(LineLeft2Rgiht(c31, f31));
add(LineLeft2Rgiht(f31, f12_));

//   row 2
add(LineLeft2Rgiht(c21, f21));
add(LineLeft2Rgiht(f21, f22));

add(LineLeft2Rgiht(f23, b23));
add(LineLeft2Rgiht(b22, b21));

add(LineLeft2Rgiht(c41, f41));
add(LineLeft2Rgiht(f41, f12__));

// up curve lines
add(LineUpCurve(f11, b11));
add(LineUpCurve(f12, b12));

// down curve lines
add(LineDownCurve(f21, b21));
add(LineDownCurve(f22, b22));

// r2 to f12
path r2Tof12 = point(r2, N){up}.. tension 3 ..{up}point(f12_, S);
draw(r2Tof12, Arrow);
path r2Tof12 = point(r2, S){down}.. tension 3 ..{down}point(f12__, N);
draw(r2Tof12, Arrow);

// left most line
path leftLine1 = point(f12_, E)--shift(shiftscale)*point(f12_, E);
draw(leftLine1, Arrow);

path leftLine2 = point(f12__, E)--shift(shiftscale)*point(f12__, E);
draw(leftLine2, Arrow);


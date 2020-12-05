import math;
import graph;

size(80cm, 25cm);
unitsize(30, 0);
defaultpen(fontsize(12pt));

real shiftunit = 3.5;
pen fillpen = rgb(156,194,230);
real ypadding = 0.8shiftunit;

//circle radius
real rsize = 0.4;
real shiftscale = 1.4;

picture getContextBox(pair pos=(0,0), pen p= currentpen)
{
    picture pic;
    real boxwidth = 2.5;
    real boxheight = 0.618*boxwidth;
    path boxpath = box((0,0), (boxwidth, boxheight));
    draw(pic, boxpath, p);
    return shift(pos)*pic;
}

picture getActorBox(pair pos=(0,0), real width = 2.5, real height = width*0.618, pen p= currentpen)
{
    picture pic;
    path boxpath = box((0,0), (width, height));
    draw(pic, boxpath, p);
    return shift(pos)*pic;
}

picture getCenterNode(picture box00, picture box01, picture box10, picture box11)
{
    picture pic;
    pair ptcenter = midpoint(point(box00, E)--point(box01, W)--point(box10, E)--point(box11, W));

    path connectellipse = ellipse(ptcenter, 0.8, 0.4);
    draw(pic, connectellipse);
    return pic;
}

picture drawBlocksInBox(picture boxpic)
{
    picture pic;
    pair ptLeftDown = min(boxpic);
    pair ptRightUp = max(boxpic);
    pair weightHeight = size(boxpic);
    
    real edgeLeftUp = ptLeftDown.x +0.1;
    real edgeWidth = weightHeight.x/2*0.9;
    real itemUnit = edgeWidth / 4.5;
    real squreUnit = 0.8*itemUnit;
    
    //blocks
    path block;
    for(int row = 0; row < 5; ++row)
    {
        for(int col = 0; col < 4; ++col)
        {
            block = scale(squreUnit)*unitsquare;
            block = shift(itemUnit*col, itemUnit*row)*block;
            fill(pic, block, lightgray);
        }        
    }

    return shift(ptLeftDown + (edgeWidth*1.13, 0.94*itemUnit))*pic;
}

picture drawThreadsInBox(picture boxpic)
{
    picture pic;
    pair ptLeftDown = min(boxpic);
    pair ptRightUp = max(boxpic);
    pair weightHeight = size(boxpic);

    real itemUnit = weightHeight.x/5;
    
    real f(real x) {return 0.2sin(5x);}
    // pair F(real x) {return (x,f(x));}
    guide mypath = rotate(90)*scale(0.3)*graph(f,0,4,operator ..);
    mypath = shift(ptLeftDown+(0.6itemUnit, 0.7itemUnit))*mypath;
    draw(pic, mypath);

    for(int i = 0; i < 4; ++i)
    {
        mypath = shift(itemUnit/2.5, 0)*mypath;
        draw(pic, mypath);
    }
    return pic;
}

picture getClusterPic()
{
    picture mainPic;
    size(mainPic, 40cm, 25cm);
    unitsize(mainPic, 30, 0);

    picture box00 = getContextBox((0, 0));
    picture box01 = getContextBox((shiftunit, 0));
    picture box10 = getContextBox((0, -ypadding));
    picture box11 = getContextBox((shiftunit, -ypadding));
    add(mainPic, box00);
    add(mainPic, box01);
    add(mainPic, box10);
    add(mainPic, box11);

    picture picEllipse = getCenterNode(box00, box01, box10, box11);
    add(mainPic, picEllipse);

    pair ptcenter = midpoint(point(box00, E)--point(box01, W)--point(box10, E)--point(box11, W));
    path pth00 = point(box00, S){down}.. tension 3 ..{right}ptcenter;
    path pth01 = point(box01, S){down}.. tension 3 ..{left}ptcenter;
    path pth10 = point(box10, N){up}.. tension 3 ..{right}ptcenter;
    path pth11 = point(box11, N){up}.. tension 3 ..{left}ptcenter;

    draw(mainPic, pth00, Arrows);
    draw(mainPic, pth01, Arrows);
    draw(mainPic, pth10, Arrows);
    draw(mainPic, pth11, Arrows);


    add(mainPic, drawBlocksInBox(box00));
    add(mainPic, drawBlocksInBox(box01));
    add(mainPic, drawBlocksInBox(box10));
    add(mainPic, drawBlocksInBox(box11));

    add(mainPic, drawThreadsInBox(box00));
    add(mainPic, drawThreadsInBox(box01));
    add(mainPic, drawThreadsInBox(box10));
    add(mainPic, drawThreadsInBox(box11));
    return mainPic;
}

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

picture getLogicalPic()
{
    picture logicalPic;
    size(logicalPic, 40cm, 25cm);
    unitsize(logicalPic, 30, 0);

    picture f1= getCircle("$f_1$", (0,0));
    add(logicalPic, f1);

    picture f2= getCircle("$f_2$", (shiftunit,0));
    add(logicalPic, f2);

    picture f3= getCircle("$f_3$", (2shiftunit,0));
    add(logicalPic, f3);

    add(logicalPic, LineLeft2Rgiht(f1, f2));
    add(logicalPic, LineLeft2Rgiht(f2, f3));
    return logicalPic;
}

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

picture getPlacementPic()
{
    picture placementPic;
    size(placementPic, 80cm, 25cm);
    unitsize(placementPic, 30, 0);

    picture boxpic00 = shift(0, 0)*getRectBox("$d_1$", false);
    picture boxpic01 = shift(1shiftunit, 0)*getRectBox("$d_3$", false);
    picture boxpic02 = shift(2shiftunit, 0)*getRectBox("$d_1$", false);
    picture boxpic03 = shift(3.5shiftunit, 0)*getRectBox("$d_1$", false);
    add(placementPic, boxpic00);
    add(placementPic, boxpic01);
    add(placementPic, boxpic02);
    add(placementPic, boxpic03);

    real yshift=-shiftunit;
    picture boxpic10 = shift(0, yshift)*getRectBox("$d_2$", false);
    picture boxpic11 = shift(1shiftunit, yshift)*getRectBox("$d_4$", false);
    picture boxpic12 = shift(2shiftunit, yshift)*getRectBox("$d_2$", false);
    picture boxpic13 = shift(3.5shiftunit, yshift)*getRectBox("$d_2$", false);
    add(placementPic, boxpic10);
    add(placementPic, boxpic11);
    add(placementPic, boxpic12);
    add(placementPic, boxpic13);

    //-------------Draw circle node in box--------------


    picture f11 = getCircleFromBox(boxpic00, "$f_{11}$", white);
    picture f12 = getCircleFromBox(boxpic00, "$f_{12}$", 1, white);
    add(placementPic, f11);
    add(placementPic, f12);

    picture f13 = getCircleFromBox(boxpic01, "$f_{13}$", white);
    picture b13 = getCircleFromBox(boxpic01, "$b_{13}$", 1, white);
    add(placementPic, f13);
    add(placementPic, b13);

    picture b12 = getCircleFromBox(boxpic02, "$b_{12}$", white);
    picture b11 = getCircleFromBox(boxpic02, "$b_{11}$", 1, white);
    add(placementPic, b12);
    add(placementPic, b11);

    picture f31 = getCircleFromBox(boxpic03, "$f_{31}$", 0, white);
    picture f12_ = getCircleFromBox(boxpic03, "$f_{12}$", 1, white);
    add(placementPic, f31);
    add(placementPic, f12_);

    picture f21 = getCircleFromBox(boxpic10, "$f_{21}$", 0, white);
    picture f22 = getCircleFromBox(boxpic10, "$f_{22}$", 1, white);
    add(placementPic, f21);
    add(placementPic, f22);

    picture f23 = getCircleFromBox(boxpic11, "$f_{23}$", 0, white);
    picture b23 = getCircleFromBox(boxpic11, "$b_{23}$", 1, white);
    add(placementPic, f23);
    add(placementPic, b23);

    picture b22 = getCircleFromBox(boxpic12, "$b_{22}$", 0, white);
    picture b21 = getCircleFromBox(boxpic12, "$b_{21}$", 1, white);
    add(placementPic, b22);
    add(placementPic, b21);

    picture f41 = getCircleFromBox(boxpic13, "$f_{41}$", 0, white);
    picture f12__ = getCircleFromBox(boxpic13, "$f_{12}$", 1, white);
    add(placementPic, f41);
    add(placementPic, f12__);

    // ------------ draw circle node out of box --------
    picture g = getCircleBtween4Box(boxpic00, boxpic01, boxpic10, boxpic11, "$g$", fillpen);
    write(point(g, E));
    write(point(g, W));
    write(point(g, S));
    write(point(g, N));
    add(placementPic, g);

    picture s = getCircleBtween4Box(boxpic01, boxpic02, boxpic11, boxpic12, "$s$", fillpen);
    add(placementPic, s);

    picture r1 = getCircleBtween4Box(boxpic02, boxpic03, boxpic12, boxpic13, "$r_1$", fillpen);
    add(placementPic, r1);

    picture r2;
    pair ptR2 = midpoint(point(b11, S)--point(b21, N));
    r2 = getCircle("$r_2$", ptR2, fillpen);
    add(placementPic, r2);

    picture c11;
    pair ptC11 = shift(-shiftscale, 0)*point(boxpic00, W);
    c11 = getCircle("$c_{11}$", ptC11, fillpen);
    add(placementPic, c11);

    picture c21;
    pair ptC21 = shift(-shiftscale, 0)*point(boxpic10, W);
    c21 = getCircle("$c_{21}$", ptC21, fillpen);
    add(placementPic, c21);

    picture c31;
    pair ptC31 = midpoint(point(boxpic02, E)--point(boxpic03, W));
    c31 = getCircle("$c_{31}$", ptC31, fillpen);
    add(placementPic, c31);

    picture c41;
    pair ptC41 = midpoint(point(boxpic12, E)--point(boxpic13, W));
    c41 = getCircle("$c_{41}$", ptC41, fillpen);
    add(placementPic, c41);

    //----------- draw link lines

    //two to ones, one to twos
    add(placementPic, LineTwo2One(f12, f22, g));
    add(placementPic, LineOne2Two(g, f13, f23));
    add(placementPic, LineTwo2One(b13, b23, s));
    add(placementPic, LineOne2Two(s, b12, b22));
    add(placementPic, LineTwo2One(b12, b22, r2));
    add(placementPic, LineTwo2One(b11, b21, r1));
    add(placementPic, LineOne2Two(r1, f31, f41));

    // strait lines
    //   row 1
    add(placementPic, LineLeft2Rgiht(c11, f11));
    add(placementPic, LineLeft2Rgiht(f11, f12));

    add(placementPic, LineLeft2Rgiht(f13, b13));

    add(placementPic, LineLeft2Rgiht(b12, b11));

    add(placementPic, LineLeft2Rgiht(c31, f31));
    add(placementPic, LineLeft2Rgiht(f31, f12_));

    //   row 2
    add(placementPic, LineLeft2Rgiht(c21, f21));
    add(placementPic, LineLeft2Rgiht(f21, f22));

    add(placementPic, LineLeft2Rgiht(f23, b23));
    add(placementPic, LineLeft2Rgiht(b22, b21));

    add(placementPic, LineLeft2Rgiht(c41, f41));
    add(placementPic, LineLeft2Rgiht(f41, f12__));

    // up curve lines
    add(placementPic, LineUpCurve(f11, b11));
    add(placementPic, LineUpCurve(f12, b12));

    // down curve lines
    add(placementPic, LineDownCurve(f21, b21));
    add(placementPic, LineDownCurve(f22, b22));

    // r2 to f12
    path r2Tof12 = point(r2, N){up}.. tension 3 ..{up}point(f12_, S);
    draw(placementPic, r2Tof12, Arrow);
    path r2Tof12 = point(r2, S){down}.. tension 3 ..{down}point(f12__, N);
    draw(placementPic, r2Tof12, Arrow);

    // left most line
    path leftLine1 = point(f12_, E)--shift(shiftscale)*point(f12_, E);
    draw(placementPic, leftLine1, Arrow);

    path leftLine2 = point(f12__, E)--shift(shiftscale)*point(f12__, E);
    draw(placementPic, leftLine2, Arrow);

    return placementPic;
}

picture getActorCircle(string s, pair pos, real r, pen p=defaultpen)
{
    picture pic;
    path pt_circle = circle(pos, r);
    draw(pic, pt_circle, p);
    label(pic, s, pos, fontsize(22pt));
    return pic;
}

picture getActorsPic()
{
    picture actorsPic;
    size(actorsPic, 80cm, 0);
    unitsize(actorsPic, 30);
    picture box0 = getActorBox((0, 0), 10, 4);
    //picture box1 = getActorBox((12, 0), 10, 4);
    pair ptLeft = point(box0, W);
    real movepadd = 3.2;
    real r = 1.5;
    picture actor1 = getActorCircle("$actor_1$", shift(1.8,0)*ptLeft, r);
    picture actor2 = getActorCircle("$actor_2$", shift(1.8+movepadd,0)*ptLeft, r);
    picture actor3 = getActorCircle("$actor_3$", shift(1.8+2movepadd,0)*ptLeft, r);
    picture picleft;

    add(picleft, box0);
    add(picleft, actor1);
    add(picleft, actor2);
    add(picleft, actor3);

    add(actorsPic, picleft);
    add(actorsPic, shift(11, 0)*picleft);
    return actorsPic;
}


picture logicalPic = shift(-4,-1)*getLogicalPic();
picture clusterPic = shift(6,0)*getClusterPic();
add(logicalPic);
add(clusterPic);

label("resource", point(clusterPic, S), 2down);
label("logical graph", (point(logicalPic, S).x, point(clusterPic, S).y), 2down);

// big arrows
pair ptArrowBegin  = shift(0, -0.5)*midpoint(point(logicalPic, S)--point(clusterPic, S));
draw(ptArrowBegin--shift(0, -1)*ptArrowBegin, p=defaultpen+2mm+lightgray, Arrow);

picture placementPic =shift(-3, -6)*getPlacementPic();
add(placementPic);
label("physical graph", point(placementPic, S), down);

picture actorsPic = getActorsPic();
actorsPic = scale(0.7)*actorsPic;
actorsPic = shift(-3.5, -14)*actorsPic;
add(actorsPic);

//draw brackets
pair ptUp0 = (min(logicalPic, true).x-0.3, max(clusterPic, true).y);
pair ptDown0 =  (min(logicalPic, true).x-0.3, min(placementPic, true).y);
pair ptCross0 = shift(-0.7, 0)*midpoint(ptUp0--ptDown0);
draw(ptUp0{left}.. tension 5 ..{left}ptCross0);
draw(ptDown0{left}.. tension 5 ..{left}ptCross0);


transform tshift = shift(-0.8, 0);
pair ptUp1 = tshift*(min(actorsPic, true).x-0.3, max(actorsPic, true).y);
pair ptDown1 =  tshift*(min(actorsPic, true).x-0.3, min(actorsPic, true).y);
pair ptCross1 = (ptCross0.x, (shift(-0.7, 0)*midpoint(ptUp1--ptDown1)).y );
draw(ptUp1{left}.. tension 1 ..{left}ptCross1);
draw(ptDown1{left}.. tension 1 ..{left}ptCross1);

label("compiler", ptCross0, left);
label("runtime", ptCross1, left);



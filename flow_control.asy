size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));

real rsize = 0.7;
real shiftUnit = 1;

picture getCircle(string s, pair pos, pen p = white)
{
    picture pic;
    path pt_circle = circle(pos, rsize);
    filldraw(pic, pt_circle, p);
    label(pic, s, pos);
    return pic;
}

picture getRect(string s="", pair z=(0,0), pen p = white) {
  picture pic;
  pair d=(1.5,1.5*0.618);
  filldraw(pic,box(-d/2,d/2), p);
  label(pic,s,(0,0));
  return shift(z)*pic;
}

picture getTime1Pic()
{
    picture mainPic;
    size(mainPic, 40cm, 0);
    unitsize(mainPic, 30, 0);

    real xshiftunit = 2shiftUnit;
    real yshiftunit = -shiftUnit;

    picture actor1 = getCircle("$actor_1$", (-1.3xshiftunit, yshiftunit));
    add(mainPic, actor1);

    picture r11 = getRect("$r_{11}$", (0, 0), lightgray);
    add(mainPic, r11);
    picture r12 = getRect("$r_{12}$", (0, yshiftunit));
    add(mainPic, r12);
    picture r13 = getRect("$r_{13}$", (0, 2yshiftunit));
    add(mainPic, r13);

    picture actor2 = getCircle("$actor_2$", (1.5xshiftunit, yshiftunit));
    add(mainPic, actor2);

    real paddingValue = (point(actor2, E) - point(actor1, E)).x;
    transform shiftItem = shift(paddingValue, 0);
    picture r21 = shiftItem*getRect("$r_{21}$", (0, 0));
    add(mainPic, r21);
    picture r22 = shiftItem*getRect("$r_{22}$", (0, yshiftunit));
    add(mainPic, r22);

    picture actor3 = shiftItem*getCircle("$actor_3$", (1.5xshiftunit, yshiftunit));
    add(mainPic, actor3);
    picture r31 = shiftItem*shiftItem*getRect("$r_{31}$", (0, 0));
    add(mainPic, r31);
    picture r32 = shiftItem*shiftItem*getRect("$r_{32}$", (0, yshiftunit));
    add(mainPic, r32);

    //draw lines
    path line = point(actor1, E){right}..{right}point(r11, W);
    draw(mainPic, line, Arrow);

    //label title
    label(mainPic, "$time_0$", (point(actor1, N).x, point(r11, N).y), down);
    return mainPic;
}

picture getTime2Pic()
{
    picture mainPic;
    size(mainPic, 40cm, 0);
    unitsize(mainPic, 30, 0);

    real xshiftunit = 2shiftUnit;
    real yshiftunit = -shiftUnit;

    picture actor1 = getCircle("$actor_1$", (-1.3xshiftunit, yshiftunit));
    add(mainPic, actor1);

    picture r11 = getRect("$r_{11}$", (0, 0), lightgray);
    add(mainPic, r11);
    picture r12 = getRect("$r_{12}$", (0, yshiftunit), lightgray);
    add(mainPic, r12);
    picture r13 = getRect("$r_{13}$", (0, 2yshiftunit));
    add(mainPic, r13);

    picture actor2 = getCircle("$actor_2$", (1.5xshiftunit, yshiftunit));
    add(mainPic, actor2);

    real paddingValue = (point(actor2, E) - point(actor1, E)).x;
    transform shiftItem = shift(paddingValue, 0);
    picture r21 = shiftItem*getRect("$r_{21}$", (0, 0), lightgray);
    add(mainPic, r21);
    picture r22 = shiftItem*getRect("$r_{22}$", (0, yshiftunit));
    add(mainPic, r22);

    picture actor3 = shiftItem*getCircle("$actor_3$", (1.5xshiftunit, yshiftunit));
    add(mainPic, actor3);
    picture r31 = shiftItem*shiftItem*getRect("$r_{31}$", (0, 0));
    add(mainPic, r31);
    picture r32 = shiftItem*shiftItem*getRect("$r_{32}$", (0, yshiftunit));
    add(mainPic, r32);

    //draw lines
    path line1 = point(actor1, E){right}..{right}point(r12, W);
    draw(mainPic, line1, Arrow);
    path line2 = point(r11, E){right}..{right}point(actor2, W);
    draw(mainPic, line2, Arrow);
    path line3 = point(actor2, E){right}..{right}point(r21, W);
    draw(mainPic, line3, Arrow);

    //label title
    label(mainPic, "$time_1$", (point(actor1, N).x, point(r11, N).y), down);
    return mainPic;
}

picture getTime3Pic()
{
    picture mainPic;
    size(mainPic, 40cm, 0);
    unitsize(mainPic, 30, 0);

    real xshiftunit = 2shiftUnit;
    real yshiftunit = -shiftUnit;

    picture actor1 = getCircle("$actor_1$", (-1.3xshiftunit, yshiftunit));
    add(mainPic, actor1);

    picture r11 = getRect("$r_{11}$", (0, 0));
    add(mainPic, r11);
    picture r12 = getRect("$r_{12}$", (0, yshiftunit), lightgray);
    add(mainPic, r12);
    picture r13 = getRect("$r_{13}$", (0, 2yshiftunit), lightgray);
    add(mainPic, r13);

    picture actor2 = getCircle("$actor_2$", (1.5xshiftunit, yshiftunit));
    add(mainPic, actor2);

    real paddingValue = (point(actor2, E) - point(actor1, E)).x;
    transform shiftItem = shift(paddingValue, 0);
    picture r21 = shiftItem*getRect("$r_{21}$", (0, 0), lightgray);
    add(mainPic, r21);
    picture r22 = shiftItem*getRect("$r_{22}$", (0, yshiftunit), lightgray);
    add(mainPic, r22);

    picture actor3 = shiftItem*getCircle("$actor_3$", (1.5xshiftunit, yshiftunit));
    add(mainPic, actor3);
    picture r31 = shiftItem*shiftItem*getRect("$r_{31}$", (0, 0), lightgray);
    add(mainPic, r31);
    picture r32 = shiftItem*shiftItem*getRect("$r_{32}$", (0, yshiftunit));
    add(mainPic, r32);

    //draw lines
    path line1 = point(actor1, E){right}..{right}point(r13, W);
    draw(mainPic, line1, Arrow);
    path line2 = point(r12, E){right}..{right}point(actor2, W);
    draw(mainPic, line2, Arrow);
    path line3 = point(actor2, E){right}..{right}point(r22, W);
    draw(mainPic, line3, Arrow);
    path line4 = point(actor3, E){right}..{right}point(r31, W);
    draw(mainPic, line4, Arrow);
    path line5 = point(r21, E){right}..{right}point(actor3, W);
    draw(mainPic, line5, Arrow);

    //label title
    label(mainPic, "$time_2$", (point(actor1, N).x, point(r11, N).y), down);
    return mainPic;
}

real picshiftunit = 3.7;
picture pic1 = shift(0, picshiftunit)*getTime1Pic();
add(pic1);

pair ptLeftDown = min(pic1, true);
pair ptRightUp = max(pic1, true);
pair p1 = (ptLeftDown.x -0.2, ptLeftDown.y - 0.2);
pair p2 = (ptRightUp.x+0.2, ptRightUp.y + 0.2);
path outBox =  box(p1, p2);
draw(outBox);
draw(shift(0, -picshiftunit)*outBox);
draw(shift(0, -2picshiftunit)*outBox);

picture pic2 = shift(0, 0)*getTime2Pic();
add(pic2);

picture pic3 = shift(0, -picshiftunit)*getTime3Pic();
add(pic3);
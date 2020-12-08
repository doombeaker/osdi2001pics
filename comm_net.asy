size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));

picture getCircle(string s, pair pos, real r = 1, pen p = defaultpen)
{
    picture pic;
    path pt_circle = circle(pos, r);
    draw(pic, pt_circle, p);
    label(pic, s, pos, p);
    return pic;
}

picture LineRight2Left(picture nodeRight, picture nodeLeft)
{
    picture pic;
    path pth = point(nodeRight, W){left}..{left}point(nodeLeft, E);
    draw(pic, pth, Arrow);
    return pic;
}

picture CurveLeft2RightUp(picture nodeLeft, picture nodeRight, real tvalue = 3, pen p = defaultpen)
{
    picture pic;
    path pth = point(nodeLeft, N){NE}.. tension tvalue ..{SE}point(nodeRight, N);
    draw(pic, pth, p, Arrow);
    return pic;
}

picture CurveRight2LeftDown(picture nodeRight, picture nodeLeft, real tvalue = 3, pen p = defaultpen)
{
    picture pic;
    path pth = point(nodeRight, S){SW}.. tension tvalue ..{NW}point(nodeLeft, S);
    draw(pic, pth, p, Arrow);
    return pic;
}

real shiftUnit = 5;

picture actor1 = getCircle("$actor_1$", 15);
add(actor1);

picture commNet = shift(shiftUnit, 0)*getCircle("$comm\_net$", 15);
add(commNet);

picture actor2 = shift(2shiftUnit, 0)*getCircle("$actor_2$", 15);
add(actor2);

picture actor2ToActor1 = LineRight2Left(commNet, actor1);
label("2. pull data", point(actor2ToActor1, N), up);
add(actor2ToActor1);

picture actor3ToActor2 = LineRight2Left(actor2, commNet);
label("4. pull data", point(actor3ToActor2, N), up);
add(actor3ToActor2);

picture actor1ToActor2Up  = CurveLeft2RightUp(actor1, commNet, 2, dashed);
label("1. push \emph{req} msg", point(actor1ToActor2Up, N), up);
add(actor1ToActor2Up);

picture actor2ToActor3Up  = CurveLeft2RightUp(commNet, actor2, 2, dashed);
label("3. push \emph{req} msg", point(actor2ToActor3Up, N), up);
add(actor2ToActor3Up);

picture actor3ToActor2Up  = CurveRight2LeftDown(actor2, commNet, 2, dashed);
label("5. push \emph{ack} msg", point(actor3ToActor2Up, S), down);
add(actor3ToActor2Up);

picture actor2ToActor1Up  = CurveRight2LeftDown(commNet, actor1, 2, dashed);
label("3. push \emph{ack} msg", point(actor2ToActor1Up, S), down);
add(actor2ToActor1Up);

pair midPoint = midpoint(point(actor1, E)--point(commNet, W));
path hLine = shift(0, 0.5shiftUnit)*midPoint--shift(0, -0.5shiftUnit)*midPoint;
draw(hLine, dashed);
label("network boundary", point(hLine, 1), down);


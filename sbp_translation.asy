size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));


real rsize = 0.7;
real shiftUnit = 3;

picture getCircle(string s, pair pos, pen p = white)
{
    picture pic;
    path pt_circle = circle(pos, rsize);
    filldraw(pic, pt_circle, p);
    label(pic, s, pos, fontsize(8pt));
    return pic;
}

picture getRect(string s="", pair z=(0,0), real w=1.2, real h = 1.2,pen p = white) {
  picture pic;
  pair d=(w,h);
  filldraw(pic,box(-d/2,d/2), p);
  label(pic,s,(0,0));
  return shift(z)*pic;
}

picture getLogicalPic()
{
    picture pic;
    size(pic, 40cm, 0);
    unitsize(pic, 30, 0);

    real xshiftUnit = 1.5shiftUnit;
    real yshiftUnit = -0.618shiftUnit;

    picture A0 = getRect("$A_0$");
    picture B0 = getRect("$B_0$", (xshiftUnit, 0));

    real xOfCirclePt = midpoint(point(A0, E)--point(B0,W)).x;
    picture MatMul0 = getCircle("$MatMul_0$", (xOfCirclePt, yshiftUnit));

    add(pic, A0);
    add(pic, B0);
    add(pic, MatMul0);


    transform shiftRightDown = shift(xshiftUnit, 2*yshiftUnit);
    picture Y0 = shiftRightDown*getRect("$Y_0$");
    picture B1 = shiftRightDown*getRect("$B_1$", (xshiftUnit, 0));
    picture MatMul1 = shiftRightDown*getCircle("$MatMul_1$", (xOfCirclePt, yshiftUnit));
    picture Y1 = shiftRightDown*getRect("$Y_1$", (xOfCirclePt, 2yshiftUnit));

    add(pic, Y0);
    add(pic, B1);
    add(pic, MatMul1);
    add(pic, Y1);

    //draw lines
    path A0ToMat0 = point(A0, E){right}..{right}point(MatMul0, W);
    path B0ToMat0 = point(B0, W){left}..{left}point(MatMul0, E);
    path Mat0ToY0 = point(MatMul0, S){down}.. tension 2 ..{down}point(Y0, N);
    path Y0ToMat1 = point(Y0, S){down}..{right}point(MatMul1, W);
    path B1ToMat1 = point(B1, S){down}..{left}point(MatMul1, E);
    path Mat1ToY1 = point(MatMul1, S){down}..{down}point(Y1, N);

    draw(A0ToMat0, Arrow);
    draw(B0ToMat0, Arrow);
    draw(Mat0ToY0, Arrow);
    draw(Y0ToMat1, Arrow);
    draw(B1ToMat1, Arrow);
    draw(Mat1ToY1, Arrow);

    // box it and label
    pair centerOfPic = midpoint(point(Y0, W)--point(Y0,E));
    real boxWidth = 3shiftUnit;
    real boxHeight = 1.5shiftUnit;
    pair leftBottom = shift(-boxWidth, -boxHeight)*centerOfPic;
    pair rightUp = shift(boxWidth, boxHeight)*centerOfPic;
    label(leftBottom, "Logical View", 2NE);
    path encloseBox = box(leftBottom, rightUp);
    draw(pic, encloseBox);
    return pic;
}

void fillBoxUp(picture boxPic, pen p=lightgray)
{
    pair ptLeftBottom = point(boxPic, W);
    pair ptRightBottom = point(boxPic, E);
    pair ptLeftUp = point(boxPic, NW);
    pair ptRightUp = point(boxPic, NE);
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    filldraw(boxPic, upRect, p);
}

void fillBoxDown(picture boxPic, pen p=lightgray)
{
    pair ptLeftBottom = point(boxPic, SW);
    pair ptRightBottom = point(boxPic, SE);
    pair ptLeftUp = point(boxPic, W);
    pair ptRightUp = point(boxPic, E);
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    filldraw(boxPic, upRect, p);
}

void fillBoxLeft(picture boxPic, pen p=lightgray)
{
    pair ptLeftBottom = point(boxPic, SW);
    pair ptRightBottom = midpoint(point(boxPic, SW)--point(boxPic, SE));
    pair ptLeftUp = point(boxPic, NW);
    pair ptRightUp = midpoint(point(boxPic, NW)--point(boxPic, NE));
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    filldraw(boxPic, upRect, p);
}

void fillBoxRight(picture boxPic, pen p=lightgray)
{
    pair ptLeftBottom = midpoint(point(boxPic, SW)--point(boxPic, SE));
    pair ptRightBottom = point(boxPic, SE);
    pair ptLeftUp = midpoint(point(boxPic, NW)--point(boxPic, NE));
    pair ptRightUp = point(boxPic, NE);
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    filldraw(boxPic, upRect, p);
}

picture getBoxPic()
{
    picture pic;
    size(pic, 40cm, 0);
    unitsize(pic, 30, 0);

    real xshiftUnit = 1.5shiftUnit;
    real yshiftUnit = -0.618shiftUnit;

// ------device 0 layer 1
    picture dev0_A0 = getRect("");
    fillBoxUp(dev0_A0);
    picture dev0_B0 = getRect("$B_0$", (xshiftUnit, 0));

    real xOfCirclePt = midpoint(point(dev0_A0, E)--point(dev0_B0,W)).x;
    picture dev0_MatMul0 = getCircle("$MatMul_0$", (xOfCirclePt, yshiftUnit));

    add(pic, dev0_A0);
    add(pic, dev0_B0);
    add(pic, dev0_MatMul0);

    picture dev0_Y0 = getRect("", (xOfCirclePt, 2*yshiftUnit));
    fillBoxUp(dev0_Y0);
    add(pic, dev0_Y0);

//---------- device 1 layer 1
    transform shiftToDevice1 = shift(2xshiftUnit, 0);
    picture dev0_A0 = shiftToDevice1*getRect("");
    fillBoxDown(dev0_A0);

    picture dev0_B0 = shiftToDevice1*getRect("$B_0$", (xshiftUnit, 0));

    real xOfCirclePt = midpoint(point(dev0_A0, E)--point(dev0_B0,W)).x;
    picture dev0_MatMul0 = getCircle("$MatMul_0$", (xOfCirclePt, yshiftUnit));

    add(pic, dev0_A0);
    add(pic, dev0_B0);
    add(pic, dev0_MatMul0);

    picture dev0_Y0 = getRect("", (xOfCirclePt, 2*yshiftUnit));
    fillBoxDown(dev0_Y0);
    add(pic, dev0_Y0);

//
    return pic;
}

// picture logicalPic = getLogicalPic();
// add(logicalPic);

picture boxPic = getBoxPic();
add(boxPic);
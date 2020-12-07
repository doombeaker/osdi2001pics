size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));


real rsize = 0.7;
real shiftUnit = 3;
pen fillblockpen = rgb(156,194,230);

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
    real yshiftUnit = -0.52shiftUnit;

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
    path Mat0ToY0 = point(MatMul0, S){down}.. tension 3 ..{down}point(Y0, N);
    path Y0ToMat1 = point(Y0, S){down}..{right}point(MatMul1, W);
    path B1ToMat1 = point(B1, S){down}..{left}point(MatMul1, E);
    path Mat1ToY1 = point(MatMul1, S){down}..{down}point(Y1, N);

    draw(pic, A0ToMat0, Arrow);
    draw(pic, B0ToMat0, Arrow);
    draw(pic, Mat0ToY0, Arrow);
    draw(pic, Y0ToMat1, Arrow);
    draw(pic, B1ToMat1, Arrow);
    draw(pic, Mat1ToY1, Arrow);

    // box it and label
    pair centerOfPic = midpoint(point(Y0, W)--point(Y0,E));
    real boxWidth = 2.89shiftUnit;
    real boxHeight = 1.5shiftUnit;
    pair leftBottom = shift(-boxWidth, -boxHeight)*centerOfPic;
    pair rightUp = shift(boxWidth, boxHeight)*centerOfPic;
    label(pic, "Logical View", leftBottom, 2NE);
    path encloseBox = box(leftBottom, rightUp);
    draw(pic, encloseBox);
    return pic;
}

void fillBoxUp(picture boxPic, pen p=fillblockpen)
{
    pair ptLeftBottom = point(boxPic, W);
    pair ptRightBottom = point(boxPic, E);
    pair ptLeftUp = point(boxPic, NW);
    pair ptRightUp = point(boxPic, NE);
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    filldraw(boxPic, upRect, p);
}

void fillBoxDown(picture boxPic, pen p=fillblockpen)
{
    pair ptLeftBottom = point(boxPic, SW);
    pair ptRightBottom = point(boxPic, SE);
    pair ptLeftUp = point(boxPic, W);
    pair ptRightUp = point(boxPic, E);
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    filldraw(boxPic, upRect, p);
}

void fillBoxLeft(picture boxPic, pen p=fillblockpen)
{
    pair ptLeftBottom = point(boxPic, SW);
    pair ptRightBottom = midpoint(point(boxPic, SW)--point(boxPic, SE));
    pair ptLeftUp = point(boxPic, NW);
    pair ptRightUp = midpoint(point(boxPic, NW)--point(boxPic, NE));
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    filldraw(boxPic, upRect, p);
}

void fillBoxRight(picture boxPic, pen p=fillblockpen)
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
    real yshiftUnit = -0.52shiftUnit;

// background box
    pair ptLeftBottom = (-0.55xshiftUnit, 7.5yshiftUnit);
    pair ptRightUp = (1.3xshiftUnit, -0.5yshiftUnit);
    path bgBox0 = box(ptLeftBottom, ptRightUp);
    path bgBox1 = shift(2xshiftUnit, 0)*bgBox0;
    picture bgBox0Pic;
    picture bgBox1Pic;
    filldraw(bgBox0Pic, bgBox0, lightgray);
    filldraw(bgBox1Pic, bgBox1, lightgray);
    add(pic, bgBox0Pic);
    add(pic, bgBox1Pic);

    label(pic, "Device 0", point(bgBox0Pic, SW), 2NE);
    label(pic, "Device 1", point(bgBox1Pic, SW), 2NE);

// ------device 0 layer 1
    picture dev0_A0 = getRect("");
    fillBoxUp(dev0_A0);
    label(dev0_A0, "$A_0$", point(dev0_A0, W), W);
    label(dev0_A0, "$split(0)$", point(dev0_A0, SW), W);

    picture dev0_B0 = getRect("$B_0$", (xshiftUnit, 0));

    real xOfCirclePt = midpoint(point(dev0_A0, E)--point(dev0_B0,W)).x;
    picture dev0_MatMul0 = getCircle("$MatMul_0$", (xOfCirclePt, yshiftUnit));

    add(pic, dev0_A0);
    add(pic, dev0_B0);
    add(pic, dev0_MatMul0);

    picture dev0_Y0 = getRect("", (xOfCirclePt, 2*yshiftUnit));
    fillBoxUp(dev0_Y0);
    label(dev0_Y0, "$Y_0$", point(dev0_Y0, W), W);
    label(dev0_Y0, "$split(0)$", point(dev0_Y0, SW), W);
    add(pic, dev0_Y0);

//---------- device 1 layer 1
    transform shiftToDevice1 = shift(2xshiftUnit, 0);
    picture dev1_A0 = shiftToDevice1*getRect("");
    fillBoxDown(dev1_A0);
    label(dev1_A0, "$A_0$", point(dev1_A0, W), W);
    label(dev1_A0, "$split(0)$", point(dev1_A0, SW), W);

    picture dev1_B0 = shiftToDevice1*getRect("$B_0$", (xshiftUnit, 0));

    real xOfCirclePt = midpoint(point(dev1_A0, E)--point(dev1_B0,W)).x;
    picture dev1_MatMul0 = getCircle("$MatMul_0$", (xOfCirclePt, yshiftUnit));

    add(pic, dev1_A0);
    add(pic, dev1_B0);
    add(pic, dev1_MatMul0);

    picture dev1_Y0 = getRect("", (xOfCirclePt, 2*yshiftUnit));
    fillBoxDown(dev1_Y0);
    label(dev1_Y0, "$Y_0$", point(dev1_Y0, W), W);
    label(dev1_Y0, "$split(0)$", point(dev1_Y0, SW), W);
    add(pic, dev1_Y0);

//------boxing rect
    pair boxingPos = shift(-0.12xshiftUnit, 1.5yshiftUnit)*midpoint(point(dev0_Y0, E)--point(dev1_Y0,W));
    //dot(pic, boxingPos);
    picture theBoxNode = getRect("Boxing", boxingPos, 2.5, 0.7);
    add(pic, theBoxNode);

 // ------- lines in layer 1(mat0 to boxing)
    path dev0A0ToMat0 = point(dev0_A0, E){right}..{right}point(dev0_MatMul0, W);
    path dev0B0ToMat0 = point(dev0_B0, W){left}..{left}point(dev0_MatMul0, E);
    path mat0ToDev0Y0 = point(dev0_MatMul0, S){down}..{down}point(dev0_Y0, N);
    path dev0Y0ToBoxing = point(dev0_Y0, S){down}.. tension atleast 2 ..{down}point(theBoxNode, N);
    draw(pic, dev0A0ToMat0, Arrow);
    draw(pic, dev0B0ToMat0, Arrow);
    draw(pic, mat0ToDev0Y0, Arrow);
    draw(pic, dev0Y0ToBoxing, Arrow);

    path dev1A0ToMat0 = point(dev1_A0, E){right}..{right}point(dev1_MatMul0, W);
    path dev1B0ToMat0 = point(dev1_B0, W){left}..{left}point(dev1_MatMul0, E);
    path mat0ToDev1Y0 = point(dev1_MatMul0, S){down}..{down}point(dev1_Y0, N);
    path dev1Y0ToBoxing = point(dev1_Y0, S){down}.. tension atleast 2 ..{down}point(theBoxNode, N);
    draw(pic, dev1A0ToMat0, Arrow);
    draw(pic, dev1B0ToMat0, Arrow);
    draw(pic, mat0ToDev1Y0, Arrow);
    draw(pic, dev1Y0ToBoxing, Arrow);

//----------- layer2 of device 0 nodes
    transform shiftToLayer2 = shift(0, 5yshiftUnit);
    picture l2_dev0_Y0 = shiftToLayer2*getRect("$Y_0$");
    label(l2_dev0_Y0, "$broadcast$", point(l2_dev0_Y0, W), W);

    picture l2_dev0_B1 = shiftToLayer2*getRect("", (xshiftUnit, 0));
    fillBoxLeft(l2_dev0_B1);
    label(l2_dev0_B1, "$B_1$", point(l2_dev0_B1, W), W);
    label(l2_dev0_B1, "$split(1)$", point(l2_dev0_B1, SW), W);

    real xOfCirclePt = midpoint(point(l2_dev0_Y0, E)--point(l2_dev0_B1,W)).x;
    picture l2_dev0_MatMul1 = shiftToLayer2*getCircle("$MatMul_1$", (xOfCirclePt, yshiftUnit));

    add(pic, l2_dev0_Y0);
    add(pic, l2_dev0_B1);
    add(pic, l2_dev0_MatMul1);

    picture l2_dev0_Y1 = shiftToLayer2*getRect("", (xOfCirclePt, 2*yshiftUnit));
    fillBoxLeft(l2_dev0_Y1);
    label(l2_dev0_Y1, "$Y_1$", point(l2_dev0_Y1, W), W);
    label(l2_dev0_Y1, "$split(1)$", point(l2_dev0_Y1, SW), W);
    add(pic, l2_dev0_Y1);

//----------- layer2 of device 1 nodes
    transform shiftToLayer2Dev1 = shift(2xshiftUnit, 5yshiftUnit);
    picture l2_dev1_Y0 = shiftToLayer2Dev1*getRect("$Y_0$");
    label(l2_dev1_Y0, "$broadcast$", point(l2_dev1_Y0, W), W);

    picture l2_dev1_B1 = shiftToLayer2Dev1*getRect("", (xshiftUnit, 0));
    fillBoxRight(l2_dev1_B1);
    label(l2_dev1_B1, "$B_1$", point(l2_dev1_B1, W), W);
    label(l2_dev1_B1, "$split(1)$", point(l2_dev1_B1, SW), W);

    pair ptCircle = shift(0, yshiftUnit)*midpoint(point(l2_dev1_Y0, E)--point(l2_dev1_B1,W));
    picture l2_dev1_MatMul1 = getCircle("$MatMul_1$", ptCircle);

    add(pic, l2_dev1_Y0);
    add(pic, l2_dev1_B1);
    add(pic, l2_dev1_MatMul1);

    picture l2_dev1_Y1 = getRect("", shift(0, yshiftUnit)*ptCircle);
    fillBoxRight(l2_dev1_Y1);
    label(l2_dev1_Y1, "$Y_1$", point(l2_dev1_Y1, W), W);
    label(l2_dev1_Y1, "$split(1)$", point(l2_dev1_Y1, SW), W);
    add(pic, l2_dev1_Y1);

// ------ draw lines in layer2(boxing to layer2)
    path boxingToDev0Y0 = point(theBoxNode, S){down}.. tension 2 ..{down}point(l2_dev0_Y0, N);
    path boxingToDev1Y0 = point(theBoxNode, S){down}.. tension 2 ..{down}point(l2_dev1_Y0, N);
    draw(pic, boxingToDev0Y0, Arrow);
    draw(pic, boxingToDev1Y0, Arrow);

    //dev 0
    path l2Y0ToMat1 = point(l2_dev0_Y0, S){down}..{right}point(l2_dev0_MatMul1, W);
    path l2B1ToMat1 = point(l2_dev0_B1, S){down}..{left}point(l2_dev0_MatMul1, E);
    path l2Mat1ToY1 = point(l2_dev0_MatMul1, S){down}..{down}point(l2_dev0_Y1, N);
    draw(pic, l2Y0ToMat1, Arrow);
    draw(pic, l2B1ToMat1, Arrow);
    draw(pic, l2Mat1ToY1, Arrow);

    //dev 1
    path l2Y0ToMat1Dev1 = point(l2_dev1_Y0, S){down}..{right}point(l2_dev1_MatMul1, W);
    path l2B1ToMat1Dev1 = point(l2_dev1_B1, S){down}..{left}point(l2_dev1_MatMul1, E);
    path l2Mat1ToY1Dev1 = point(l2_dev1_MatMul1, S){down}..{down}point(l2_dev1_Y1, N);
    draw(pic, l2Y0ToMat1Dev1, Arrow);
    draw(pic, l2B1ToMat1Dev1, Arrow);
    draw(pic, l2Mat1ToY1Dev1, Arrow);

    return pic;
}

picture logicalPic = getLogicalPic();
add(logicalPic.fit(), (0,0), N);

picture boxPic = getBoxPic();
add(boxPic.fit(), (0,0), 10S);
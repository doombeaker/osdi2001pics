size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(24pt));


real rsize = 0.7;
real shiftUnit = 3;
pen fillblockpen = rgb(156,194,230);
pen notexistpen = dashed;

path getCirclePath(pair pos)
{
    path pt_circle = circle(pos, rsize);
    return pt_circle;
}

picture labelNode(path pthNode, string s)
{
    picture pic;
    draw(pic, pthNode);
    fill(pic, pthNode, fillblockpen);
    pair ptCenter = midpoint(point(pthNode, 0)--point(pthNode, size(pthNode)-2));
    label(pic, s, ptCenter);
    return pic;
}

pair getCircleCenter(path pthCircle)
{
    pair ptCenter;
    ptCenter = midpoint(point(pthCircle, 0)--point(pthCircle, size(pthCircle)-2));
    return ptCenter;
}

pair getPointOfCircle(path circlePth, pair dir)
{
    pair ptDst;
    pair ptCenter = getCircleCenter(circlePth);
    //dot(ptCenter, darkblue);
    ptDst = intersectionpoint(circlePth, ptCenter--shift(ptCenter)*dir); 
    return ptDst;
}

picture getLeaf1Picture()
{
    picture pic;
    real xShiftUnit = 1*shiftUnit;
    real yshiftUnit = -1.1*shiftUnit;

    path ni = getCirclePath((0, 0));
    path nj = getCirclePath((xShiftUnit, -yshiftUnit));

    picture niPic = labelNode(ni, "$n_i$");
    add(pic, niPic);

    picture njPic = labelNode(nj, "$n_j$");
    add(pic, njPic);


    //draw lines between nodes
    pair ptNi = getPointOfCircle(ni, NE);
    pair ptNj = getPointOfCircle(nj, SW);
    draw(pic, ptNi--ptNj);

//----------draw lines to out space
    pair ptNjL = getPointOfCircle(nj, N);
    pair ptNjM = getPointOfCircle(nj, NE);
    pair ptNjR = getPointOfCircle(nj, E);

    // dot(ptNjL--ptNjM--ptNjR, red);

    draw(pic, ptNjL--shift(ptNjL)*N, dashed);
    draw(pic, ptNjM--shift(ptNjM)*NE, dashed);
    draw(pic, ptNjR--shift(ptNjR)*E, dashed);

    return pic;
}

picture getLeaf2Picture()
{
    picture pic;
    real xShiftUnit = 1*shiftUnit;
    real yshiftUnit = -1.1*shiftUnit;

    path ni = getCirclePath((0, 0));
    path nj = getCirclePath((-xShiftUnit, yshiftUnit));

    picture niPic = labelNode(ni, "$n_i$");
    add(pic, niPic);

    picture njPic = labelNode(nj, "$n_j$");
    add(pic, njPic);


    //draw lines between nodes
    pair ptNi = getPointOfCircle(ni, SW);
    pair ptNj = getPointOfCircle(nj, NE);
    draw(pic, ptNi--ptNj);


//----------draw lines to out space
    pair ptNjL = getPointOfCircle(nj, W);
    pair ptNjM = getPointOfCircle(nj, SW);
    pair ptNjR = getPointOfCircle(nj, S);

    // dot(ptNjL--ptNjM--ptNjR, red);

    draw(pic, ptNjL--shift(ptNjL)*W, dashed);
    draw(pic, ptNjM--shift(ptNjM)*SW, dashed);
    draw(pic, ptNjR--shift(ptNjR)*S, dashed);

    return pic;
}

picture getResultPicture()
{
    picture pic;
    path njp = getCirclePath((0, 0));
    picture njPic = labelNode(njp, "$n_j^{\prime}$");
    add(pic, njPic);

 //----------draw lines to out space
    pair ptNjL = getPointOfCircle(njp, NW);
    pair ptNjM = getPointOfCircle(njp, N);
    pair ptNjR = getPointOfCircle(njp, NE);

    // dot(ptNjL--ptNjM--ptNjR, red);

    draw(pic, ptNjL--shift(ptNjL)*NW, dashed);
    draw(pic, ptNjM--shift(ptNjM)*N, dashed);
    draw(pic, ptNjR--shift(ptNjR)*NE, dashed);

    return pic;
}


picture leaf1Pic = getLeaf1Picture();
add(leaf1Pic);
picture leaf2Pic = shift(2shiftUnit, 1.1shiftUnit)*getLeaf2Picture();
add(leaf2Pic);
picture resultPic = shift(3shiftUnit, 1.1shiftUnit/2)*getResultPicture();
add(resultPic);
draw(shift(0, -0.35)*(shift(-0.5shiftUnit, 0)*point(resultPic,W)--point(resultPic,W)), Arrow);
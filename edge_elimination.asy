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

picture getListPicture()
{
    picture pic;
    real xShiftUnit = 1*shiftUnit;
    real yshiftUnit = 1.1*shiftUnit;

    path nj0 = getCirclePath((0, yshiftUnit));
    path nk0 = getCirclePath((0, -yshiftUnit));

    path vline = point(nj0,0)--point(nk0,size(nk0)-2);
    pair ptNiCenter = midpoint(vline);
    // dot(vline, red);
    path ni0 = getCirclePath(ptNiCenter);

    picture nj0Pic = labelNode(nj0, "$n_j$");
    add(pic, nj0Pic);

    picture nk0Pic = labelNode(nk0, "$n_k$");
    add(pic, nk0Pic);

    picture ni0Pic = labelNode(ni0, "$n_i$");
    add(pic, ni0Pic);

    //draw lines between nodes
    pair ptNj = getPointOfCircle(nj0, S);
    pair ptNiU = getPointOfCircle(ni0, N);
    pair ptNiD = getPointOfCircle(ni0, S);
    pair ptNk = getPointOfCircle(nk0, N);
    draw(pic, "$e_j$", ptNj--ptNiU);
    draw(pic, "$e_k$", ptNiD--ptNk);

//----------draw lines to out space
    pair ptNjL = getPointOfCircle(nj0, NW);
    pair ptNjM = getPointOfCircle(nj0, N);
    pair ptNjR = getPointOfCircle(nj0, NE);

    // dot(ptNjL--ptNjM--ptNjR, red);

    draw(pic, ptNjL--shift(ptNjL)*NW, dashed);
    draw(pic, ptNjM--shift(ptNjM)*N, dashed);
    draw(pic, ptNjR--shift(ptNjR)*NE, dashed);

    pair ptNkL = getPointOfCircle(nk0, SW);
    pair ptNkM = getPointOfCircle(nk0, S);
    pair ptNkR = getPointOfCircle(nk0, SE);

    draw(pic, ptNkL--shift(ptNkL)*SW, dashed);
    draw(pic, ptNkM--shift(ptNkM)*S, dashed);
    draw(pic, ptNkR--shift(ptNkR)*SE, dashed);

    return pic;
}

picture getLinePicture()
{
    picture pic;
    real xShiftUnit = 1*shiftUnit;
    real yshiftUnit = 1.1*shiftUnit;

    path nj0 = getCirclePath((0, yshiftUnit));
    path nk0 = getCirclePath((0, -yshiftUnit));


    picture nj0Pic = labelNode(nj0, "$n_j$");
    add(pic, nj0Pic);

    picture nk0Pic = labelNode(nk0, "$n_k$");
    add(pic, nk0Pic);

    //draw lines between nodes
    pair ptNjL = getPointOfCircle(nj0, SW);
    pair ptNkL = getPointOfCircle(nk0, NW);
    draw(pic, "$e_1$", ptNjL{SW}.. tension 1.5 ..{SE}ptNkL);

    pair ptNj = getPointOfCircle(nj0, S);
    pair ptNk = getPointOfCircle(nk0, N);
    draw(pic, "$e_2$", ptNj--ptNk);

    pair ptNjR = getPointOfCircle(nj0, SE);
    pair ptNkR = getPointOfCircle(nk0, NE);
    draw(pic, "$e_3$", ptNjR{SE}.. tension 1.5 ..{SW}ptNkR);

//----------draw lines to out space
    pair ptNjL = getPointOfCircle(nj0, NW);
    pair ptNjM = getPointOfCircle(nj0, N);
    pair ptNjR = getPointOfCircle(nj0, NE);

    // dot(ptNjL--ptNjM--ptNjR, red);

    draw(pic, ptNjL--shift(ptNjL)*NW, dashed);
    draw(pic, ptNjM--shift(ptNjM)*N, dashed);
    draw(pic, ptNjR--shift(ptNjR)*NE, dashed);

    pair ptNkL = getPointOfCircle(nk0, SW);
    pair ptNkM = getPointOfCircle(nk0, S);
    pair ptNkR = getPointOfCircle(nk0, SE);

    draw(pic, ptNkL--shift(ptNkL)*SW, dashed);
    draw(pic, ptNkM--shift(ptNkM)*S, dashed);
    draw(pic, ptNkR--shift(ptNkR)*SE, dashed);

    return pic;
}

picture getResultPicture()
{
    picture pic;
    real xShiftUnit = 1*shiftUnit;
    real yshiftUnit = 1.1*shiftUnit;

    path nj0 = getCirclePath((0, yshiftUnit));
    path nk0 = getCirclePath((0, -yshiftUnit));


    picture nj0Pic = labelNode(nj0, "$n_j$");
    add(pic, nj0Pic);

    picture nk0Pic = labelNode(nk0, "$n_k$");
    add(pic, nk0Pic);

    //draw lines between nodes
    pair ptNj = getPointOfCircle(nj0, S);
    pair ptNk = getPointOfCircle(nk0, N);
    draw(pic, "$e_j^{\prime}$", ptNj--ptNk);

//----------draw lines to out space
    pair ptNjL = getPointOfCircle(nj0, NW);
    pair ptNjM = getPointOfCircle(nj0, N);
    pair ptNjR = getPointOfCircle(nj0, NE);

    // dot(ptNjL--ptNjM--ptNjR, red);

    draw(pic, ptNjL--shift(ptNjL)*NW, dashed);
    draw(pic, ptNjM--shift(ptNjM)*N, dashed);
    draw(pic, ptNjR--shift(ptNjR)*NE, dashed);

    pair ptNkL = getPointOfCircle(nk0, SW);
    pair ptNkM = getPointOfCircle(nk0, S);
    pair ptNkR = getPointOfCircle(nk0, SE);

    draw(pic, ptNkL--shift(ptNkL)*SW, dashed);
    draw(pic, ptNkM--shift(ptNkM)*S, dashed);
    draw(pic, ptNkR--shift(ptNkR)*SE, dashed);

    return pic;
}


picture linePic = shift(0,0)*getLinePicture();
picture resultPic = shift(4, 0)*getResultPicture();
add(linePic);
add(resultPic);
draw(shift(0.5, 0)*point(linePic, E)--point(resultPic,W), Arrow);
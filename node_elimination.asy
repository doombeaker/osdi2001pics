size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));


real rsize = 0.5;
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

picture getVPicture()
{
    picture pic;
    real xShiftUnit = 1*shiftUnit;
    real yshiftUnit = -1.1*shiftUnit;

    path nj0 = getCirclePath((0, 0));
    path nk0 = getCirclePath((xShiftUnit, 0));

    path vline = point(nj0,0)--point(nk0,size(nk0)-2);
    pair ptNiCenter = shift(0, 0.6yshiftUnit)*midpoint(vline);
    // dot(vline, red);
    path ni0 = getCirclePath(ptNiCenter);

    picture nj0Pic = labelNode(nj0, "$n_j$");
    add(pic, nj0Pic);

    picture nk0Pic = labelNode(nk0, "$n_k$");
    add(pic, nk0Pic);

    picture ni0Pic = labelNode(ni0, "$n_i$");
    add(pic, ni0Pic);

    //draw lines between nodes
    pair ptNj = getPointOfCircle(nj0, SE);
    pair ptNiL = getPointOfCircle(ni0, NW);
    pair ptNiR = getPointOfCircle(ni0, NE);
    pair ptNk = getPointOfCircle(nk0, SW);
    draw(pic, "$e_j$", ptNj--ptNiL);
    draw(pic, "$e_k$", ptNk--ptNiR);

//----------draw lines to out space
    pair ptNjL = getPointOfCircle(nj0, NW);
    pair ptNjM = getPointOfCircle(nj0, N);
    pair ptNjR = getPointOfCircle(nj0, NE);

    // dot(ptNjL--ptNjM--ptNjR, red);

    draw(pic, ptNjL--shift(ptNjL)*NW, dashed);
    draw(pic, ptNjM--shift(ptNjM)*N, dashed);
    draw(pic, ptNjR--shift(ptNjR)*NE, dashed);

    pair ptNkL = getPointOfCircle(nk0, NW);
    pair ptNkM = getPointOfCircle(nk0, N);
    pair ptNkR = getPointOfCircle(nk0, NE);

    draw(pic, ptNkL--shift(ptNkL)*NW, dashed);
    draw(pic, ptNkM--shift(ptNkM)*N, dashed);
    draw(pic, ptNkR--shift(ptNkR)*NE, dashed);

    return pic;
}

picture getReVPicture()
{
    picture pic;
    real xShiftUnit = 1*shiftUnit;
    real yshiftUnit = 1.1*shiftUnit;

    path nj0 = getCirclePath((0, 0));
    path nk0 = getCirclePath((xShiftUnit, 0));

    path vline = point(nj0,0)--point(nk0,size(nk0)-2);
    pair ptNiCenter = shift(0, 0.6yshiftUnit)*midpoint(vline);
    // dot(vline, red);
    path ni0 = getCirclePath(ptNiCenter);

    picture nj0Pic = labelNode(nj0, "$n_j$");
    add(pic, nj0Pic);

    picture nk0Pic = labelNode(nk0, "$n_k$");
    add(pic, nk0Pic);

    picture ni0Pic = labelNode(ni0, "$n_i$");
    add(pic, ni0Pic);

    //draw lines between nodes
    pair ptNj = getPointOfCircle(nj0, NE);
    pair ptNiL = getPointOfCircle(ni0, SW);
    pair ptNiR = getPointOfCircle(ni0, SE);
    pair ptNk = getPointOfCircle(nk0, NW);
    draw(pic, "$e_j$", ptNiL--ptNj);
    draw(pic, "$e_k$", ptNiR--ptNk);

//----------draw lines to out space
    pair ptNjL = getPointOfCircle(nj0, SW);
    pair ptNjM = getPointOfCircle(nj0, S);
    pair ptNjR = getPointOfCircle(nj0, SE);

    // dot(ptNjL--ptNjM--ptNjR, red);

    draw(pic, ptNjL--shift(ptNjL)*SW, dashed);
    draw(pic, ptNjM--shift(ptNjM)*S, dashed);
    draw(pic, ptNjR--shift(ptNjR)*SE, dashed);

    pair ptNkL = getPointOfCircle(nk0, SW);
    pair ptNkM = getPointOfCircle(nk0, S);
    pair ptNkR = getPointOfCircle(nk0, SE);

    draw(pic, ptNkL--shift(ptNkL)*SW, dashed);
    draw(pic, ptNkM--shift(ptNkM)*S, dashed);
    draw(pic, ptNkR--shift(ptNkR)*SE, dashed);

    return pic;
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

picture vPic = shift(-4, 3)*getVPicture();
picture linePic = shift(2, 0)*getListPicture();
picture reVPic = shift(-4,-3)*getReVPicture();
picture resultPic = shift(7, 0)*getResultPicture();

add(vPic);
add(reVPic);
add(linePic);
add(resultPic);

draw(point(linePic, E)--point(resultPic,W), Arrow);
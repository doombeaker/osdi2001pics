size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(24pt));


real rsize = 0.7;
real shiftUnit = 3;
pen fillblockpen = rgb(156,194,230);
pen notexistpen = dashed;

path getCirclePath(pair pos=(0,0))
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

picture drawLinesOutSpace(path circlePth, pair dir)
{
    picture pic;
//----------draw lines to out space
    pair ptMid = getPointOfCircle(circlePth, dir);
    pair ptLeft = getPointOfCircle(circlePth, rotate(45)*dir);
    pair ptRight = getPointOfCircle(circlePth, rotate(-45)*dir);

    // dot(ptNjL--ptNjM--ptNjR, red);

    draw(pic, ptMid--shift(ptMid)*dir, dashed);
    draw(pic, ptLeft--shift(ptLeft)*rotate(45)*dir, dashed);
    draw(pic, ptRight--shift(ptRight)*rotate(-45)*dir, dashed); 
    return pic;   
}

picture getNodes1Picture()
{
    picture pic;
    real xShiftUnit = 1*shiftUnit;
    real yshiftUnit = -1.1*shiftUnit;

    path ni = getCirclePath((-0.35xShiftUnit, 0));
    path nj = getCirclePath((0.35xShiftUnit, 0));
    picture niPic = labelNode(ni, "$n_i$");
    add(pic, niPic);
    picture njPic = labelNode(nj, "$n_j$");
    add(pic, njPic);

    path n1 = rotate(20)*shift(-1.5xShiftUnit, 0)*getCirclePath((0,0));
    path n2 = rotate(-20)*shift(-1.5xShiftUnit, 0)*getCirclePath((0,0));
    picture n1Pic = labelNode(n1, "$n_1$");
    add(pic, n1Pic);
    picture n2Pic = labelNode(n2, "$n_2$");
    add(pic, n2Pic);

    add(pic, drawLinesOutSpace(n1, SW));
    add(pic, drawLinesOutSpace(n2, NW));

    path n3;
    pair ptN3Center = shift(0, -1.3yshiftUnit)*midpoint(getCircleCenter(ni)--getCircleCenter(nj));
    n3 = getCirclePath(ptN3Center);
    picture n3Pic = labelNode(n3, "$n_3$");
    add(pic, n3Pic);
    add(pic, drawLinesOutSpace(n3, N));

    path n4 = rotate(20)*shift(1.5xShiftUnit, 0)*getCirclePath((0,0));
    path n5 = rotate(-20)*shift(1.5xShiftUnit, 0)*getCirclePath((0,0));
    picture n4Pic = labelNode(n4, "$n_4$");
    add(pic, n4Pic);
    picture n5Pic = labelNode(n5, "$n_5$");
    add(pic, n5Pic);
    add(pic, drawLinesOutSpace(n4, NE));
    add(pic, drawLinesOutSpace(n5, SE));

    path n6 = rotate(20)*shift(0, 1.3yshiftUnit)*getCirclePath((0,0));
    path n7 = rotate(-20)*shift(0, 1.3yshiftUnit)*getCirclePath((0,0));
    picture n6Pic = labelNode(n6, "$n_6$");
    add(pic, n6Pic);
    picture n7Pic = labelNode(n7, "$n_7$");
    add(pic, n7Pic);
    add(pic, drawLinesOutSpace(n6, S));
    add(pic, drawLinesOutSpace(n7, S));

    //draw lines between nodes
    pair ptN1 = getPointOfCircle(n1, NE);
    pair ptNiL = getPointOfCircle(ni, W);
    draw(pic, ptN1--ptNiL);

    pair ptN7 = getPointOfCircle(n7, N);
    pair ptNiD = getPointOfCircle(ni, S);
    draw(pic, ptN7--ptNiD);

    pair ptN2 = getPointOfCircle(n2, SE);
    draw(pic, ptN2--ptNiL);

    pair ptNiU = getPointOfCircle(ni, N);
    pair ptN3 = getPointOfCircle(n3, S);
    draw(pic, ptN3--ptNiU);

    pair ptNjU = getPointOfCircle(nj, N);
    draw(pic, ptN3--ptNjU);

    pair ptNjR = getPointOfCircle(nj, E);
    pair ptN4 = getPointOfCircle(n4, SW);
    draw(pic, ptN4--ptNjR);

    pair ptN5 = getPointOfCircle(n5, NW);
    draw(pic, ptN5--ptNjR);

    pair ptNjD = getPointOfCircle(nj, S);
    pair ptN6 = getPointOfCircle(n6, N);
    
    draw(pic, ptN6--ptNjD);
    draw(pic, ptN6--ptNiD);
    draw(pic, ptN7--ptNjD);



    return pic;
}


picture getNodes2Picture()
{
    picture pic;
    real xShiftUnit = 1*shiftUnit;
    real yshiftUnit = -1.1*shiftUnit;

    path ni = getCirclePath((-0.35xShiftUnit, 0));
    path nj = getCirclePath((0.35xShiftUnit, 0));
    picture niPic = labelNode(ni, "$n_i$");
    add(pic, niPic);
    picture njPic = labelNode(nj, "$n_j$");
    add(pic, njPic);

    path n1 = rotate(20)*shift(-1.5xShiftUnit, 0)*getCirclePath((0,0));
    path n2 = rotate(-20)*shift(-1.5xShiftUnit, 0)*getCirclePath((0,0));
    picture n1Pic = labelNode(n1, "$n_1$");
    add(pic, n1Pic);
    picture n2Pic = labelNode(n2, "$n_2$");
    add(pic, n2Pic);

    add(pic, drawLinesOutSpace(n1, SW));
    add(pic, drawLinesOutSpace(n2, NW));

    path n3;
    pair ptN3Center = shift(0, -1.3yshiftUnit)*midpoint(getCircleCenter(ni)--getCircleCenter(nj));
    n3 = getCirclePath(ptN3Center);
    picture n3Pic = labelNode(n3, "$n_3$");
    add(pic, n3Pic);
    add(pic, drawLinesOutSpace(n3, N));

    path n4 = rotate(20)*shift(1.5xShiftUnit, 0)*getCirclePath((0,0));
    path n5 = rotate(-20)*shift(1.5xShiftUnit, 0)*getCirclePath((0,0));
    picture n4Pic = labelNode(n4, "$n_4$");
    add(pic, n4Pic);
    picture n5Pic = labelNode(n5, "$n_5$");
    add(pic, n5Pic);
    add(pic, drawLinesOutSpace(n4, NE));
    add(pic, drawLinesOutSpace(n5, SE));

    path n6 = rotate(20)*shift(0, 1.3yshiftUnit)*getCirclePath((0,0));
    path n7 = rotate(-20)*shift(0, 1.3yshiftUnit)*getCirclePath((0,0));
    picture n6Pic = labelNode(n6, "$n_6$");
    add(pic, n6Pic);
    picture n7Pic = labelNode(n7, "$n_7$");
    add(pic, n7Pic);
    add(pic, drawLinesOutSpace(n6, S));
    add(pic, drawLinesOutSpace(n7, S));

    //draw lines between nodes
    pair ptNiR = getPointOfCircle(ni, E);
    pair ptNjL = getPointOfCircle(nj , W);
    draw(pic, ptNiR--ptNjL);

    pair ptN1 = getPointOfCircle(n1, NE);
    pair ptNiL = getPointOfCircle(ni, W);
    draw(pic, ptN1--ptNiL);

    pair ptN7 = getPointOfCircle(n7, N);
    pair ptNiD = getPointOfCircle(ni, S);
    draw(pic, ptN7--ptNiD);

    pair ptN2 = getPointOfCircle(n2, SE);
    draw(pic, ptN2--ptNiL);

    pair ptNiU = getPointOfCircle(ni, N);
    pair ptN3 = getPointOfCircle(n3, S);
    draw(pic, ptN3--ptNiU);

    pair ptNjU = getPointOfCircle(nj, N);
    draw(pic, ptN3--ptNjU);

    pair ptNjR = getPointOfCircle(nj, E);
    pair ptN4 = getPointOfCircle(n4, SW);
    draw(pic, ptN4--ptNjR);

    pair ptN5 = getPointOfCircle(n5, NW);
    draw(pic, ptN5--ptNjR);

    pair ptNjD = getPointOfCircle(nj, S);
    pair ptN6 = getPointOfCircle(n6, N);
    
    draw(pic, ptN6--ptNjD);
    draw(pic, ptN6--ptNiD);
    draw(pic, ptN7--ptNjD);

    return pic;
}

picture getNodes3Picture()
{
    picture pic;
    real xShiftUnit = 1*shiftUnit;
    real yshiftUnit = -1.1*shiftUnit;

    path nPrime = getCirclePath((0, 0));

    path n1 = rotate(20)*shift(-1.5xShiftUnit, 0)*getCirclePath((0,0));
    path n2 = rotate(-20)*shift(-1.5xShiftUnit, 0)*getCirclePath((0,0));
    picture n1Pic = labelNode(n1, "$n_1$");
    add(pic, n1Pic);
    picture n2Pic = labelNode(n2, "$n_2$");
    add(pic, n2Pic);

    add(pic, drawLinesOutSpace(n1, SW));
    add(pic, drawLinesOutSpace(n2, NW));

    path n3;
    pair ptN3Center = shift(0, -1.3yshiftUnit)*midpoint(getCircleCenter(nPrime));
    n3 = getCirclePath(ptN3Center);
    picture n3Pic = labelNode(n3, "$n_3$");
    add(pic, n3Pic);
    add(pic, drawLinesOutSpace(n3, N));

    path n4 = rotate(20)*shift(1.5xShiftUnit, 0)*getCirclePath((0,0));
    path n5 = rotate(-20)*shift(1.5xShiftUnit, 0)*getCirclePath((0,0));
    picture n4Pic = labelNode(n4, "$n_4$");
    add(pic, n4Pic);
    picture n5Pic = labelNode(n5, "$n_5$");
    add(pic, n5Pic);
    add(pic, drawLinesOutSpace(n4, NE));
    add(pic, drawLinesOutSpace(n5, SE));

    path n6 = rotate(20)*shift(0, 1.3yshiftUnit)*getCirclePath((0,0));
    path n7 = rotate(-20)*shift(0, 1.3yshiftUnit)*getCirclePath((0,0));
    picture n6Pic = labelNode(n6, "$n_6$");
    add(pic, n6Pic);
    picture n7Pic = labelNode(n7, "$n_7$");
    add(pic, n7Pic);
    add(pic, drawLinesOutSpace(n6, S));
    add(pic, drawLinesOutSpace(n7, S));

    //draw lines between nodes
    pair nPrimeCenter = getCircleCenter(nPrime);

    pair ptN1 = getPointOfCircle(n1, NE);
    draw(pic, ptN1--nPrimeCenter);

    pair ptN7 = getPointOfCircle(n7, N);
    draw(pic, ptN7--nPrimeCenter);

    pair ptN2 = getPointOfCircle(n2, SE);
    draw(pic, ptN2--nPrimeCenter);

    pair ptN3 = getPointOfCircle(n3, S);
    draw(pic, ptN3--nPrimeCenter);

    draw(pic, ptN3--nPrimeCenter);

    pair ptN4 = getPointOfCircle(n4, SW);
    draw(pic, ptN4--nPrimeCenter);

    pair ptN5 = getPointOfCircle(n5, NW);
    draw(pic, ptN5--nPrimeCenter);

    pair ptN6 = getPointOfCircle(n6, N);
    
    draw(pic, ptN6--nPrimeCenter);
    draw(pic, ptN7--nPrimeCenter);

    picture nPrimePic = labelNode(nPrime, "$n^{\prime}$");
    add(pic, nPrimePic);
    return pic;
}

real picShiftUnit = 2.3shiftUnit;
picture nodes1Pic = shift(-picShiftUnit, 0)*getNodes1Picture();
add(nodes1Pic);
picture nodes2Pic = shift(picShiftUnit, 0)*getNodes2Picture();
add(nodes2Pic);
picture nodes3Pic = shift(3.5picShiftUnit, 0)*getNodes3Picture();
add(nodes3Pic);
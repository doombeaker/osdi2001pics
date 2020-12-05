size(80cm, 25cm);
unitsize(30, 0);
defaultpen(fontsize(12pt));

real shiftunit = 3.5;
pen fillpen = rgb(156,194,230);
real ypadding = 0.8shiftunit;

picture getContextBox(pair pos=(0,0), pen p= currentpen)
{
    picture pic;
    real boxwidth = 2.5;
    real boxheight = 0.618*boxwidth;
    path boxpath = box((0,0), (boxwidth, boxheight));
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
    real squreUnit = 0.9*itemUnit;
    
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

picture box00 = getContextBox((0, 0));
picture box01 = getContextBox((shiftunit, 0));
picture box10 = getContextBox((0, -ypadding));
picture box11 = getContextBox((shiftunit, -ypadding));
add(box00);
add(box01);
add(box10);
add(box11);

picture picEllipse = getCenterNode(box00, box01, box10, box11);
add(picEllipse);

pair ptcenter = midpoint(point(box00, E)--point(box01, W)--point(box10, E)--point(box11, W));
path pth00 = point(box00, S){down}.. tension 3 ..{right}ptcenter;
path pth01 = point(box01, S){down}.. tension 3 ..{left}ptcenter;
path pth10 = point(box10, N){up}.. tension 3 ..{right}ptcenter;
path pth11 = point(box11, N){up}.. tension 3 ..{left}ptcenter;

draw(pth00, Arrows);
draw(pth01, Arrows);
draw(pth10, Arrows);
draw(pth11, Arrows);


add(drawBlocksInBox(box00));
add(drawBlocksInBox(box01));
add(drawBlocksInBox(box10));
add(drawBlocksInBox(box11));


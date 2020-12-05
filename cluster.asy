import math;
import graph;

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

add(getClusterPic());


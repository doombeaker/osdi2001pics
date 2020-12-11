import roundedpath;
import patterns;

size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));


real rsize = 0.7;
real bunit = 0.5;
real yshiftUnit = 5.05;
real xshiftUnit = 3.5;
pen fillblockpen = rgb(156,194,230);
real tinyPadding = 0.1;
real boxingWidth = 3.5;
real boxingHeigth = 1;

add("hatch",hatch(1mm, gray));
add("hatchback",hatch(1mm, NW, gray));
add("crosshatch", crosshatch(1mm, gray));

picture getCircle(string s, pair pos, pen p = white)
{
    picture pic;
    path pt_circle = circle(pos, rsize);
    filldraw(pic, pt_circle, p);
    label(pic, s, pos, fontsize(8pt));
    return pic;
}

picture getRect(string s="", real w=bunit, real h = bunit, pen pfill = white, pen pd = defaultpen) {
  picture pic;
  pair d=(w,h);
  fill(pic,box(-d/2,d/2), pfill);
  draw(pic, box(-d/2,d/2), pd);
  label(pic,s,(0,0));
  return pic;
}

picture fillBoxFull(picture boxPic, pen p=fillblockpen, pen patternpen=pattern(""), pen drawpen=defaultpen)
{
    picture pic;
    path upRect = box(point(boxPic,SW), point(boxPic,NE));
    fill(pic, upRect, p);
    fill(pic, upRect, patternpen);
    draw(pic, upRect);
    return pic;
}

picture fillBoxLeft(picture boxPic, pen p=fillblockpen, pen patternpen=pattern(""), pen drawpen=defaultpen)
{
    picture pic;
    pair ptLeftBottom = point(boxPic, SW);
    pair ptRightBottom = midpoint(point(boxPic, SW)--point(boxPic, SE));
    pair ptLeftUp = point(boxPic, NW);
    pair ptRightUp = midpoint(point(boxPic, NW)--point(boxPic, NE));
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    fill(pic, upRect, p);
    fill(pic, upRect, patternpen);
    draw(pic, upRect);
    return pic;
}

picture fillBoxRight(picture boxPic, pen p=fillblockpen, pen patternpen=pattern(""), pen drawpen=defaultpen)
{
    picture pic;
    pair ptLeftBottom = midpoint(point(boxPic, SW)--point(boxPic, SE));
    pair ptRightBottom = point(boxPic, SE);
    pair ptLeftUp = midpoint(point(boxPic, NW)--point(boxPic, NE));
    pair ptRightUp = point(boxPic, NE);
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    fill(pic, upRect, p);
    fill(pic, upRect, patternpen);
    draw(pic, upRect);
    return pic;
}

picture blockRoundBox(string s = "", real w = 3, real h = 1, pen p = white) {
  picture pic;
  pair d = (w, h);
  path rpath = roundedpath(box(-d/2,d/2), 0.1);
  filldraw(pic, rpath, p);
  label(pic, s);
  return pic;
}

picture ellipseNode(string s ="", real a = 1.6, real b = 0.5, pen p = white)
{
    picture pic;
    path ellipsePath = ellipse((0,0), a, b);
    filldraw(pic, ellipsePath, p);
    label(pic, s);
    return pic;
}

void FillBlocks(picture pic, picture[] blocks, int count = blocks.length, pen fillpen=fillblockpen, pen patternpen = pattern(""))
{
    for(int i = 0; i<count;++i)
    {
        picture blockItem = fillBoxFull(blocks[i], fillpen, patternpen);
        add(pic, blockItem);
    }
}

void FillBlocksFromRight(picture pic, picture[] blocks, int count = blocks.length, pen fillpen=fillblockpen, pen patternpen = pattern(""))
{
    for(int i = 0; i<count;++i)
    {
        picture blockItem = fillBoxFull(blocks[blocks.length-1-i], fillpen, patternpen);
        add(pic, blockItem);
    }
}

void FillHalfBlocksFromLeft(picture pic, picture[] blocks, int count, pen fillpen=fillblockpen,
                            pen patternpen = pattern(""))
{
    for(int i = 0; i<count;++i)
    {
        picture blockItem = fillBoxLeft(blocks[i], fillpen, patternpen);
        add(pic, blockItem);
    }
}

pair getMidNPtFromAry(picture[] ary)
{
    return midpoint(point(ary[3], N)--point(ary[4], N));
}

void FillBlankBlocks(picture pic, picture[] ary)
{
    for(int i = 0; i<count;++i)
    {
        picture item = fillBoxFull(ary[i], defaultpen, defaultpen);
        add(pic, item);
    }    
}

pair getMidNPtFromAryS(picture[] ary)
{
    return midpoint(point(ary[3], S)--point(ary[4], S));
}

void FillHalfBlocksFromRight(picture pic, picture[] blocks, 
                            int count, 
                            pen fillpen=fillblockpen,
                            pen patternpen = pattern(""))
{
    for(int i = 0; i<count;++i)
    {
        picture blockItem = fillBoxLeft(blocks[blocks.length-1-i], fillpen, patternpen);
        add(pic, blockItem);
    }
}

picture[] getReflectAry(picture[] dev0Ary, transform t)
{
    picture[] retAry;
    retAry.initialized(dev0Ary.length);
    for(int i = 0; i < dev0Ary.length; ++i)
    {
        picture item = t*dev0Ary[i];
        retAry[dev0Ary.length-1-i] = item;
    }
    return retAry;
}

picture getPhyPic()
{
    picture pic;
    size(pic, 0, 40cm);
    unitsize(pic, 0, 30);

    picture boxingNode = shift(xshiftUnit, 0)*blockRoundBox("boxing", boxingWidth, boxingHeigth, lightgray);
    label(pic, "reduce-scatter", point(boxingNode, S), S);

    picture dev0_lossPic = shift(-3*xshiftUnit, 0)*blockRoundBox("$loss$");
    add(pic, dev0_lossPic);

    picture dev0_backwordPic = shift(-3*xshiftUnit, -yshiftUnit)*blockRoundBox("$backward$");
    add(pic, dev0_backwordPic);

    picture[] dev0_ParamsFp16Ary;
    real shiftAryValue = -3.5*bunit-3.5*tinyPadding;
    pair ptParmsStart = point(dev0_backwordPic, S)+(shiftAryValue,-0.3yshiftUnit);
    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(i*(bunit+tinyPadding), 0)*shift(ptParmsStart)*getRect(white);
        dev0_ParamsFp16Ary.push(blockItem);
        add(pic, blockItem);
    }
    label(pic, "Params(fp16)", point(dev0_ParamsFp16Ary[0], N), NE, fontsize(8pt));
    FillHalfBlocksFromLeft(pic, dev0_ParamsFp16Ary, 4, fillblockpen);
    FillHalfBlocksFromRight(pic, dev0_ParamsFp16Ary, 4, fillblockpen, pattern("hatch"));

    picture[] dev0_grad16Ary;
    real liftX = -0.5xshiftUnit+shiftAryValue;
    real liftY = 0.5*yshiftUnit;
    pair ptParmsStart = midpoint(point(dev0_backwordPic, E)--point(boxingNode, W)+(liftX, liftY));
    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(i*(bunit+tinyPadding), 0)*shift(ptParmsStart)*getRect(white);
        dev0_grad16Ary.push(blockItem);
        add(pic, blockItem);
    }
    FillHalfBlocksFromLeft(pic, dev0_grad16Ary, 4, fillblockpen);
    FillHalfBlocksFromRight(pic, dev0_grad16Ary, 4, fillblockpen, pattern("hatch"));
    label(pic, "gradient(fp16)", point(dev0_grad16Ary[0], N), N+E, fontsize(8pt));

    picture[] dev0_grad16BoxedAry;
    liftY = -0.3yshiftUnit;
    pair ptParmsStart = midpoint(point(dev0_grad16Ary[0], W)--point(dev0_grad16Ary[0], E)) + (0, -bunit-3*tinyPadding);

    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(i*(bunit+tinyPadding), 0)*shift(ptParmsStart)*getRect(white);
        dev0_grad16BoxedAry.push(blockItem);
        add(pic, blockItem);
    }
    FillHalfBlocksFromLeft(pic, dev0_grad16BoxedAry, 4, fillblockpen);

    pair ptCast = midpoint(point(dev0_grad16BoxedAry[3], S)--point(dev0_grad16BoxedAry[4], S))+(0, -0.25*yshiftUnit);
    picture dev0_castPic = shift(ptCast)*blockRoundBox("$cast$");
    add(pic, dev0_castPic);

    picture[] dev0_grad32Ary;
    pair ptParmsStart = (point(dev0_grad16BoxedAry[0], S).x, point(dev0_castPic, S).y-0.2*yshiftUnit);

    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(i*(bunit+tinyPadding), 0)*shift(ptParmsStart)*getRect(white);
        dev0_grad32Ary.push(blockItem);
        add(pic, blockItem);
    }
    FillBlocks(pic, dev0_grad32Ary, 4, fillblockpen);
    label(pic, "gradient(fp32)", point(dev0_grad32Ary[0], N), N+E, fontsize(8pt));

    picture[] dev0_ParamsFp32Ary;
    pair ptParmsStart = (point(dev0_ParamsFp16Ary[0], S).x, 
                        point(dev0_ParamsFp16Ary[0], W).y-0.5yshiftUnit);
    //dot(pic, ptParmsStart, red);
    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(i*(bunit+tinyPadding), 0)*shift(ptParmsStart)*getRect(white);
        dev0_ParamsFp32Ary.push(blockItem);
        add(pic, blockItem);
    }
    FillBlocks(pic, dev0_ParamsFp32Ary, 4, fillblockpen);
    label(pic, "Params(fp32)", point(dev0_ParamsFp32Ary[0], N), N+E, fontsize(8pt));

    pair ptAdamOptimizer = (point(dev0_castPic, S).x, point(dev0_ParamsFp32Ary[0], W).y);
    picture dev0_adamPic = shift(ptAdamOptimizer)*blockRoundBox("$Optimizer$");
    add(pic, dev0_adamPic);    

    picture[] dev0_AdamStatMAry;
    pair ptParmsStart = (point(dev0_adamPic, N).x+0.5xshiftUnit, 
                        point(dev0_adamPic, N).y+0.15yshiftUnit);
    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(i*(bunit+tinyPadding), 0)*shift(ptParmsStart)*getRect(white);
        dev0_AdamStatMAry.push(blockItem);
        add(pic, blockItem);
    }
    FillBlocks(pic, dev0_AdamStatMAry, 4, lightgray);
    label(pic, "adam state M(fp32)", point(dev0_AdamStatMAry[0], N), N+E, fontsize(8pt));

    picture[] dev0_AdamStatVAry;
    pair ptParmsStart = (point(dev0_adamPic, N).x+0.5xshiftUnit, 
                        point(dev0_adamPic, N).y+0.35yshiftUnit+bunit);
    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(i*(bunit+tinyPadding), 0)*shift(ptParmsStart)*getRect(white);
        dev0_AdamStatVAry.push(blockItem);
        add(pic, blockItem);
    }
    FillBlocks(pic, dev0_AdamStatVAry, 4, lightgray);
    label(pic, "adam state V(fp32)", point(dev0_AdamStatVAry[0], N), N+E, fontsize(8pt));

    //draw lines
    draw(pic, getMidNPtFromAry(dev0_ParamsFp16Ary)--point(dev0_backwordPic, S), Arrow);
    draw(pic, point(dev0_backwordPic, N){N}..{right}point(dev0_grad16Ary[0], W), Arrow);
    draw(pic, point(dev0_grad16Ary[7], E){right}..{right}point(boxingNode, W), Arrow);
    draw(pic, point(boxingNode, S){down}..{left}point(dev0_grad16BoxedAry[7], E), Arrow);
    draw(pic, getMidNPtFromAryS(dev0_grad16BoxedAry)--point(dev0_castPic, N), Arrow);
    draw(pic, point(dev0_castPic, S)--getMidNPtFromAry(dev0_grad32Ary), Arrow);

    draw(pic, getMidNPtFromAryS(dev0_grad32Ary)--point(dev0_adamPic,N), Arrow);
    draw(pic, point(dev0_AdamStatMAry[0], W){left}..{down}point(dev0_adamPic,N), Arrow);
    draw(pic, point(dev0_AdamStatVAry[0], W){left}..{down}point(dev0_adamPic,N), Arrow);
    draw(pic, point(dev0_adamPic, W)--point(dev0_ParamsFp32Ary[7], E), Arrows);

    draw(pic, point(dev0_lossPic, S)--point(dev0_backwordPic, N), Arrow);


//---------------------dev1------------------------------------
    transform t = reflect(shift(0, -yshiftUnit)*point(boxingNode, N), shift(0, yshiftUnit)*point(boxingNode, N));
    picture dev1_lossPic = t*dev0_lossPic;
    picture dev1_backwordPic = t*dev0_backwordPic;
    picture dev1_castPic = t*dev0_castPic;
    picture dev1_adamPic = t*dev0_adamPic;

    add(pic, dev1_lossPic);
    add(pic, dev1_backwordPic);
    add(pic, dev1_castPic);
    add(pic, dev1_adamPic);

    picture[] dev1_grad16Ary = getReflectAry(dev0_grad16Ary, t);
    FillBlocks(pic, dev1_grad16Ary, 8, white, white);
    FillHalfBlocksFromLeft(pic, dev1_grad16Ary, 4, fillblockpen);
    FillHalfBlocksFromRight(pic, dev1_grad16Ary, 4, fillblockpen, pattern("hatch"));

    picture[] dev1_grad16BoxedAry = getReflectAry(dev0_grad16BoxedAry, t);
    FillBlocks(pic, dev1_grad16BoxedAry, 8, white, white);
    FillHalfBlocksFromRight(pic, dev1_grad16BoxedAry, 4, fillblockpen, pattern("hatch"));

    picture[] dev1_AdamStatMAry = getReflectAry(dev0_AdamStatMAry, t);
    FillBlocks(pic, dev1_AdamStatMAry, 8, white, white);
    FillBlocksFromRight(pic, dev1_AdamStatMAry, 4, lightgray, pattern("hatch"));

    picture[] dev1_AdamStatVAry = getReflectAry(dev0_AdamStatVAry, t);
    FillBlocks(pic, dev1_AdamStatVAry, 8, white, white);
    FillBlocksFromRight(pic, dev1_AdamStatVAry, 4, lightgray, pattern("hatch"));

    picture[] dev1_ParamsFp32Ary = getReflectAry(dev0_ParamsFp32Ary, t);
    FillBlocks(pic, dev1_ParamsFp32Ary, 8, white, white);
    FillBlocksFromRight(pic, dev1_ParamsFp32Ary, 4, fillblockpen, pattern("hatch"));

    picture[] dev1_grad32Ary = getReflectAry(dev0_grad32Ary, t);
    FillBlocks(pic, dev1_grad32Ary, 8, white, white);
    FillBlocksFromRight(pic, dev1_grad32Ary, 4, fillblockpen, pattern("hatch"));

    picture[] dev1_ParamsFp16Ary = getReflectAry(dev0_ParamsFp16Ary, t);
    FillBlocks(pic, dev1_ParamsFp16Ary, 8, white, white);
    FillHalfBlocksFromLeft(pic, dev1_ParamsFp16Ary, 4, fillblockpen);
    FillHalfBlocksFromRight(pic, dev1_ParamsFp16Ary, 4, fillblockpen, pattern("hatch"));

    
    //labels
    label(pic, "params(fp16)", point(dev1_ParamsFp16Ary[0], N), NE, fontsize(8pt));
    label(pic, "params(fp32)", point(dev1_ParamsFp32Ary[0], N), NE, fontsize(8pt));
    label(pic, "gradient(fp16)", point(dev1_grad16Ary[0], N), NE, fontsize(8pt));
    label(pic, "adam state M(fp32)", point(dev1_AdamStatMAry[0], N), NE, fontsize(8pt));
    label(pic, "adam state V(fp32)", point(dev1_AdamStatVAry[0], N), NE, fontsize(8pt));
    label(pic, "gradient(fp32)", point(dev1_grad32Ary[0], N), NE, fontsize(8pt));

    //draw lines
    draw(pic, getMidNPtFromAry(dev1_ParamsFp16Ary)--point(dev1_backwordPic, S), Arrow);
    draw(pic, point(dev1_backwordPic, N){N}..{left}point(dev1_grad16Ary[7], E), Arrow);
    draw(pic, point(dev1_grad16Ary[0], W){left}..{left}point(boxingNode, E), Arrow);
    draw(pic, point(boxingNode, S){down}..{right}point(dev1_grad16BoxedAry[0], W), Arrow);
    draw(pic, getMidNPtFromAryS(dev1_grad16BoxedAry)--point(dev1_castPic, N), Arrow);
    draw(pic, point(dev1_castPic, S)--getMidNPtFromAry(dev1_grad32Ary), Arrow);

    draw(pic, getMidNPtFromAryS(dev1_grad32Ary)--point(dev1_adamPic,N), Arrow);
    draw(pic, point(dev1_AdamStatMAry[7], E){right}..{down}point(dev1_adamPic,N), Arrow);
    draw(pic, point(dev1_AdamStatVAry[7], E){right}..{down}point(dev1_adamPic,N), Arrow);
    draw(pic, point(dev1_adamPic, E)--point(dev1_ParamsFp32Ary[0], W), Arrows);

    draw(pic, point(dev1_lossPic, S)--point(dev1_backwordPic, N), Arrow);

    //draw enclose boxes
    real vLeft = min(dev0_ParamsFp32Ary[0], true).x;
    real vBottom = point(dev0_adamPic, S).y-tinyPadding;
    real vRight = point(boxingNode, N).x;
    real vTop = point(boxingNode, N).y+tinyPadding;
    path dev0_box = box((vLeft,vBottom),(vRight,vTop));
    path dev1_box = t*dev0_box;
    draw(pic, dev0_box, dashed);
    draw(pic, dev1_box, dashed);
    add(pic, boxingNode);

    label(pic, "Device 0", ((vLeft+vRight)/2,vTop), S);
    label(pic, "Device 1", t*((vLeft+vRight)/2,vTop), S);
    // label(pic, "Device1", midpoint(dev1_box), S);
    return pic;
}

picture phyPic = getPhyPic();
pair rightBottom = (max(phyPic, true).x, min(phyPic, true).y);
pair rightTop = (max(phyPic, true).x, max(phyPic, true).y);
add(phyPic);

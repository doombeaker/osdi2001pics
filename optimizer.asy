import roundedpath;
import patterns;

size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));


real rsize = 0.7;
real bunit = 0.5;
real yshiftUnit = 3;
real xshiftUnit = 2;
pen fillblockpen = rgb(156,194,230);
real tinyPadding = 0.1;

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
    fill(pic, upRect, fillblockpen);
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
        write(blocks.length-i);
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

picture getLogical1Pic()
{
    picture pic;
    size(pic, 0, 40cm);
    unitsize(pic, 0, 30);

    picture inPic = blockRoundBox("$in$");
    add(pic, inPic);

    picture forwardPic = shift(0, -yshiftUnit)*ellipseNode("forward");
    add(pic,forwardPic);

    picture lossPic = shift(0, -2*yshiftUnit)*blockRoundBox("$loss$");
    add(pic, lossPic);

    picture[] psyAry;
    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(1.5xshiftUnit + i*(bunit+tinyPadding), -2*tinyPadding)*getRect(white);
        psyAry.push(blockItem);
        add(pic, blockItem);
    }
    label(pic, "Params(fp32) Broadcast", point(psyAry[0], N), NE, fontsize(8pt));
    FillBlocks(pic, psyAry, fillblockpen);

    real ptCastY = midpoint(point(inPic, S)--point(forwardPic, N)).y;
    real ptCastX = midpoint(point(psyAry[3], E)--point(psyAry[4],W)).x;
    pair ptBlocks = (ptCastX, ptCastY);
    picture castPic = shift(ptBlocks)*ellipseNode("cast to fp16");
    
    add(pic, castPic);
    draw(pic, point(inPic,S)--point(forwardPic,N), Arrow);
    draw(pic, point(forwardPic,S)--point(lossPic,N), Arrow);
    draw(pic, midpoint(point(psyAry[3], SE)--point(psyAry[4],SW))--point(castPic,N), Arrow);
    draw(pic, point(castPic, W){left}..{left}point(forwardPic,E), Arrow);

    //draw boxes
    real vleft = point(forwardPic, W).x -2tinyPadding;
    real vright = point(psyAry[7], E).x + 2tinyPadding;
    real vtop = point(inPic, N).y + tinyPadding;
    real vbottom = point(lossPic, S).y - tinyPadding;
    draw(pic, box((vleft, vbottom), (vright, vtop))); 
    return pic;
}

picture getLogical2Pic()
{
    picture pic;
    size(pic, 0, 40cm);
    unitsize(pic, 0, 30);

    picture inPic = blockRoundBox("$in$");
    add(pic, inPic);

    picture forwardPic = shift(0, -yshiftUnit)*ellipseNode("forward~broadcast");
    add(pic,forwardPic);

    picture lossPic = shift(0, -2*yshiftUnit)*blockRoundBox("$loss$");
    add(pic, lossPic);

    picture[] psyAry;
    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(-3.5xshiftUnit-2tinyPadding + i*(bunit+tinyPadding), -2*tinyPadding)*getRect(white);
        psyAry.push(blockItem);
        add(pic, blockItem);
    }

    label(pic, "Params(fp32) Broadcast to Split", point(psyAry[0], N), NE, fontsize(8pt));
    FillBlocks(pic, psyAry, fillblockpen);

    real ptCastY = midpoint(point(inPic, S)--point(forwardPic, N)).y;
    real ptCastX = midpoint(point(psyAry[3], E)--point(psyAry[4],W)).x;
    pair ptBlocks = (ptCastX, ptCastY);
    
    picture castPic = shift(ptBlocks)*ellipseNode("cast to fp16");
    add(pic, castPic);

    draw(pic, point(inPic,S)--point(forwardPic,N), Arrow);
    draw(pic, point(forwardPic,S)--point(lossPic,N), Arrow);
    draw(pic, midpoint(point(psyAry[3], SE)--point(psyAry[4],SW))--point(castPic,N), Arrow);
    draw(pic, point(castPic, E){right}..{right}point(forwardPic,W), Arrow);

    //draw chan boxes
    real chainLeft = point(psyAry[0], W).x -tinyPadding;
    real chainRight = point(psyAry[7], E).x + tinyPadding;
    real chainBottom = point(castPic, S).y - 6tinyPadding;
    real chainTop = point(psyAry[0], N).y + 4*tinyPadding;
    draw(pic, box((chainLeft, chainBottom), (chainRight, chainTop)), dashed);
    label(pic, "chain", (chainLeft, chainBottom), NE);

    // draw boxes
    real vleft = point(psyAry[0], W).x -2tinyPadding;
    real vright = point(lossPic, E).x + 2tinyPadding;
    real vtop = point(inPic, N).y + tinyPadding;
    real vbottom = point(lossPic, S).y - tinyPadding;
    draw(pic, box((vleft, vbottom), (vright, vtop))); 
    return pic;
}

picture getPhy1Pic()
{
    picture pic;
    size(pic, 0, 40cm);
    unitsize(pic, 0, 30);

    picture dev0_inPic = blockRoundBox("$in$");
    add(pic, dev0_inPic);

    picture dev0_forwardPic = shift(0, -yshiftUnit)*ellipseNode("forward");
    add(pic,dev0_forwardPic);

    picture dev0_lossPic = shift(0, -2*yshiftUnit)*blockRoundBox("$loss$");
    add(pic, dev0_lossPic);

    picture[] dev0_psyAry;
    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(1.5xshiftUnit + i*(bunit+tinyPadding), -2*tinyPadding)*getRect(white);
        dev0_psyAry.push(blockItem);
        add(pic, blockItem);
    }
    label(pic, "Params(fp32) Broadcast", point(dev0_psyAry[0], N), NE, fontsize(8pt));
    FillBlocks(pic, dev0_psyAry, 4, fillblockpen);

    real dev0_ptCastY = midpoint(point(dev0_inPic, S)--point(dev0_forwardPic, N)).y;
    real dev0_ptCastX = midpoint(point(dev0_psyAry[3], E)--point(dev0_psyAry[4],W)).x;
    pair dev0_ptBlocks = (dev0_ptCastX, dev0_ptCastY);
    picture dev0_castPic = shift(dev0_ptBlocks)*ellipseNode("cast to fp16");
    
    //cast to 16
    picture[] dev0_psyAryFp16;
    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(1.5xshiftUnit + i*(bunit+tinyPadding), -yshiftUnit)*getRect(white);
        dev0_psyAryFp16.push(blockItem);
        add(pic, blockItem);
    }
    label(pic, "Params(fp16)", point(dev0_psyAryFp16[0], N), NE, fontsize(8pt));
    FillHalfBlocksFromLeft(pic, dev0_psyAryFp16, 4, fillblockpen);

    //after boxing
    picture[] dev0_boxingFp16;
    for(int i = 0; i<8;++i)
    {
        picture blockItem = shift(1.5xshiftUnit + i*(bunit+tinyPadding), -1.75yshiftUnit)*getRect(white);
        dev0_boxingFp16.push(blockItem);
        add(pic, blockItem);
    }
    label(pic, "Params(fp16)", point(dev0_boxingFp16[0], N), NE, fontsize(8pt));
    FillHalfBlocksFromLeft(pic, dev0_boxingFp16, 4, fillblockpen);
    FillHalfBlocksFromRight(pic, dev0_boxingFp16, 4, fillblockpen, pattern("hatch"));

    add(pic, dev0_castPic);
    draw(pic, point(dev0_inPic,S)--point(dev0_forwardPic,N), Arrow);
    draw(pic, point(dev0_forwardPic,S)--point(dev0_lossPic,N), Arrow);
    draw(pic, midpoint(point(dev0_psyAry[3], SE)--point(dev0_psyAry[4],SW))--point(dev0_castPic,N), Arrow);
    draw(pic, point(dev0_castPic, S){down}..{down}midpoint(point(dev0_psyAryFp16[3], NE)--point(dev0_psyAryFp16[4], NW)), Arrow);

    //draw boxes
    real dev0_vleft = point(dev0_forwardPic, W).x -2tinyPadding;
    real dev0_vright = point(dev0_psyAry[7], E).x + 2tinyPadding;
    real dev0_vtop = point(dev0_inPic, N).y + tinyPadding;
    real dev0_vbottom = point(dev0_lossPic, S).y - tinyPadding;
    draw(pic, box((dev0_vleft, dev0_vbottom), (dev0_vright, dev0_vtop))); 
    label(pic, "Device 0", (dev0_vright, dev0_vtop), NW);

//------------------device 1--------
    real dev1_device1Shift = 8xshiftUnit;
    real w = size(pic, true).x;
    transform t = shift(dev1_device1Shift, 0);

    picture dev1_inPic = t*blockRoundBox("$in$");
    add(pic, dev1_inPic);

    picture dev1_forwardPic = t*shift(0, -yshiftUnit)*ellipseNode("forward~broadcast");
    add(pic,dev1_forwardPic);

    picture dev1_lossPic = t*shift(0, -2*yshiftUnit)*blockRoundBox("$loss$");
    add(pic, dev1_lossPic);

    picture[] dev1_psyAry;
    for(int i = 0; i<8;++i)
    {
        picture blockItem = t*shift(-3.5xshiftUnit-2tinyPadding + i*(bunit+tinyPadding), -2*tinyPadding)*getRect(white);
        dev1_psyAry.push(blockItem);
        add(pic, blockItem);
    }

    label(pic, "Params(fp32) Broadcast to Split", point(dev1_psyAry[0], N), NE, fontsize(8pt));
    FillBlocksFromRight(pic, dev1_psyAry, 4, fillblockpen, pattern("hatch"));

    real dev1_ptCastY = midpoint(point(dev1_inPic, S)--point(dev1_forwardPic, N)).y;
    real dev1_ptCastX = midpoint(point(dev1_psyAry[3], E)--point(dev1_psyAry[4],W)).x;
    pair dev1_ptBlocks = (dev1_ptCastX, dev1_ptCastY);
    
    picture dev1_castPic = shift(dev1_ptBlocks)*ellipseNode("cast to fp16");
    add(pic, dev1_castPic);

    //cast to 16
    picture[] dev1_psyAryFp16;
    for(int i = 0; i<8;++i)
    {
        picture blockItem = t*shift(-3.5xshiftUnit + i*(bunit+tinyPadding), -yshiftUnit)*getRect(white);
        dev1_psyAryFp16.push(blockItem);
        add(pic, blockItem);
    }
    label(pic, "Params(fp16)", point(dev1_psyAryFp16[4], N), NE, fontsize(8pt));
    FillHalfBlocksFromRight(pic, dev1_psyAryFp16, 4, fillblockpen, pattern("hatch"));

    //after boxing
    picture[] dev1_boxingFp16;
    for(int i = 0; i<8;++i)
    {
        picture blockItem = t*shift(-3.5xshiftUnit + i*(bunit+tinyPadding), -1.75yshiftUnit)*getRect(white);
        dev1_boxingFp16.push(blockItem);
        add(pic, blockItem);
    }
    label(pic, "Params(fp16)", point(dev1_boxingFp16[0], N), NE, fontsize(8pt));
    FillHalfBlocksFromLeft(pic, dev1_boxingFp16, 4, fillblockpen);
    FillHalfBlocksFromRight(pic, dev1_boxingFp16, 4, fillblockpen, pattern("hatch"));

    draw(pic, point(dev1_inPic,S)--point(dev1_forwardPic,N), Arrow);
    draw(pic, point(dev1_forwardPic,S)--point(dev1_lossPic,N), Arrow);
    draw(pic, midpoint(point(dev1_psyAry[3], SE)--point(dev1_psyAry[4],SW))--point(dev1_castPic,N), Arrow);
    draw(pic, point(dev1_castPic, E){right}..{right}point(dev1_forwardPic,W), Arrow);

    // draw boxes
    real dev1_vleft = point(dev1_psyAry[0], W).x -2tinyPadding;
    real dev1_vright = point(dev1_lossPic, E).x + 2tinyPadding;
    real dev1_vtop = point(dev1_inPic, N).y + tinyPadding;
    real dev1_vbottom = point(dev1_lossPic, S).y - tinyPadding;
    draw(pic, box((dev1_vleft, dev1_vbottom), (dev1_vright, dev1_vtop))); 
    label(pic, "Device 1", (dev1_vleft, dev1_vtop), NE);
    return pic;
}

// picture logicalPic1 = getLogical1Pic();
// logicalPic1 = shift(-min(logicalPic1, true))*logicalPic1;
// add(logicalPic1);
// picture logicalPic2 = getLogical2Pic();
// logicalPic2 = shift(max(logicalPic1,true).x,0)*shift(-min(logicalPic2,true))*logicalPic2;
// add(logicalPic2);

picture phyPic1 = getPhy1Pic();
add(phyPic1);


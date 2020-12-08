import geometry;

size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));
real xshiftUnit = 1.4;
pen fillReady = rgb(156,194,230);
pen fillBusy = lightgray;
pen fillFree = white;

real tinyPadding = 0.1;

picture getBatch(real width, pen pstyle = defaultpen, pen pbg = lightgray)
{
    picture pic;
    path lineBatch = box((0,0),(width,0.05));
    fill(pic, lineBatch, pbg);
    draw(pic, lineBatch, pstyle);
    return pic;
}

picture blockBox(real w = 0.3, real h = 0.3, pen p = white) {
  picture pic;
  pair d = (w, h);
  path boxpath = box((0,0), d);
  filldraw(pic, boxpath, p);
  return pic;
}

//对齐上方btach的左边边缘
picture getRegAlignToUpBatchLeft(picture batchPic, real yaxis)
{
    picture reg = blockBox();

    pair ptLeft = point(batchPic, W);
    pair ptTo =(ptLeft.x, ptLeft.y+yaxis);
    return shift(ptTo)*reg;
}

//对齐上方btach的右边缘
picture getRegAlignToUpBatchRight(picture batchPic, real yaxis)
{
    picture reg = blockBox();

    pair ptLeft = point(batchPic, E);
    pair ptTo =(ptLeft.x, ptLeft.y+yaxis);
    return shift(ptTo)*reg;
}

//对齐下方btach的左边缘
picture getRegAlignToDownBatchLeft(picture batchPic, real yaxis)
{
    picture reg = blockBox();

    pair ptLeft = point(batchPic, W);
    pair ptTo =(ptLeft.x, ptLeft.y-yaxis);
    return shift(ptTo)*reg;
}

//对齐下方btach的右边缘
picture getRegAlignToDownBatchRight(picture batchPic, real yaxis)
{
    picture reg = blockBox();

    pair ptLeft = point(batchPic, E);
    pair ptTo =(ptLeft.x, ptLeft.y-yaxis);
    return shift(ptTo)*reg;
}

picture fillRegBox(picture boxPic, pen p=fillFree)
{
    pair ptLeftBottom = point(boxPic, SW);
    pair ptRightBottom = point(boxPic, SE);
    pair ptLeftUp = point(boxPic, NW);
    pair ptRightUp = point(boxPic, NE);
    path upRect = ptLeftBottom--ptRightBottom--ptRightUp--ptLeftUp--cycle;
    write(upRect);
    filldraw(boxPic, upRect, p);
    return boxPic;
}

picture getMainPic()
{
    picture pic;

    //draw dataloading batches
    real batchWidthUnit = xshiftUnit;
    real yshiftUnit = 1.2xshiftUnit;
    real shiftBatch1padding = xshiftUnit+tinyPadding;
    picture dataloadingPic;
    
    //dataloader batch 1, reg1 0
    picture data_batch1 = getBatch(batchWidthUnit);
    add(pic, data_batch1);
    real yaxisShift = -0.55xshiftUnit;
    real boxd = 0.3;
    picture reg1_00 = getRegAlignToUpBatchLeft(data_batch1, yaxisShift);
    picture reg1_10 = getRegAlignToUpBatchLeft(data_batch1, yaxisShift-tinyPadding-boxd);
    add(pic, reg1_00);
    add(pic, reg1_10);

    //dataloader batch 2, reg1 1, preprocess batch1
    picture data_batch2 = shift(point(data_batch1, E).x+tinyPadding, 0)*getBatch(batchWidthUnit); 
    add(pic, data_batch2);

    picture reg1_01 = getRegAlignToUpBatchLeft(data_batch2, yaxisShift);
    picture reg1_11 = getRegAlignToUpBatchLeft(data_batch2, yaxisShift-tinyPadding-boxd);
    add(pic, reg1_01);
    add(pic, fillRegBox(reg1_11, fillBusy));

    real preproWidth = 2.5*xshiftUnit;
    real shiftYValue = -yshiftUnit;
    picture prepro_batch1 = shift(point(data_batch2, W).x, shiftYValue)*getBatch(preproWidth, dotted);
    add(pic, prepro_batch1);

    //reg1 2
    picture reg1_02 = shift(tinyPadding,0)*getRegAlignToUpBatchRight(data_batch2, yaxisShift);
    picture reg1_12 = shift(tinyPadding,0)*getRegAlignToUpBatchRight(data_batch2, yaxisShift-tinyPadding-boxd);
    add(pic, fillRegBox(reg1_02, fillReady));
    add(pic, fillRegBox(reg1_12, fillBusy));    

    //dataloader batch3, reg1 3
    picture data_batch3 = shift(point(prepro_batch1, E).x+tinyPadding, 0)*getBatch(batchWidthUnit); 
    add(pic, data_batch3);
    picture reg1_03 = getRegAlignToUpBatchLeft(data_batch3, yaxisShift);
    picture reg1_13 = getRegAlignToUpBatchLeft(data_batch3, yaxisShift-tinyPadding-boxd);
    add(pic, fillRegBox(reg1_03, fillBusy));
    add(pic, fillRegBox(reg1_13, fillFree));        

    //preprocess batch2
    picture prepro_batch2 = shift(point(data_batch3, W).x, shiftYValue)*getBatch(preproWidth, dotted);
    add(pic, prepro_batch2);

    real copyWidth = 0.6*xshiftUnit;
    real copyYValue =  -2*yshiftUnit;
    
    //copyh2d batch1, regs2 1
    pair ptCopyBase = (point(prepro_batch1, E).x+tinyPadding, copyYValue);
    picture copyh2d_batch1 = shift(ptCopyBase)*getBatch(copyWidth, solid, black);
    add(pic, copyh2d_batch1);

    picture reg2_01 = getRegAlignToUpBatchLeft(prepro_batch2, yaxisShift);
    picture reg2_11 = getRegAlignToUpBatchLeft(prepro_batch2, yaxisShift-tinyPadding-boxd);
    add(pic, fillRegBox(reg2_01, fillFree));
    add(pic, fillRegBox(reg2_11, fillBusy));        

    //regs2 2, regs3 1
    picture reg2_02 = shift(point(copyh2d_batch1, E).x+tinyPadding, point(reg2_01, SW).y)*blockBox();
    picture reg2_12 = shift(point(copyh2d_batch1, E).x+tinyPadding, point(reg2_11, SW).y)*blockBox();;
    add(pic, fillRegBox(reg2_02, fillFree));
    add(pic, fillRegBox(reg2_12, fillFree));        

    picture reg3_01 = shift(tinyPadding,0)*getRegAlignToUpBatchRight(copyh2d_batch1, yaxisShift);
    picture reg3_11 = shift(tinyPadding,0)*getRegAlignToUpBatchRight(copyh2d_batch1, yaxisShift-tinyPadding-boxd);
    add(pic, fillRegBox(reg3_11, fillBusy));
    add(pic, fillRegBox(reg3_01, fillFree));
    
    //train batch1
    real trainWidth = 2preproWidth+2*tinyPadding;
    real trainYValue =  -3*yshiftUnit; 
    pen Dotted(pen p=currentpen) {return linetype(new real[] {0,3})+2*linewidth(p);}    
    pair ptTrainBatch1 = (point(copyh2d_batch1, E).x+tinyPadding, trainYValue);
    picture train_batch1 = shift(ptTrainBatch1)*getBatch(trainWidth, Dotted, gray);
    add(pic, train_batch1);

    //dataloader batch4, regs1 4
    picture data_batch4 = shift(point(data_batch3, E).x+tinyPadding, 0)*getBatch(batchWidthUnit); 
    add(pic, data_batch4);

    picture reg1_04 = shift(tinyPadding,0)*getRegAlignToUpBatchRight(data_batch3, yaxisShift);
    picture reg1_14 = shift(tinyPadding,0)*getRegAlignToUpBatchRight(data_batch3, yaxisShift-tinyPadding-boxd);
    add(pic, fillRegBox(reg1_04, fillBusy));
    add(pic, fillRegBox(reg1_14, fillBusy)); 

    //picture prepro_batch2 = shift(3shiftBatch1padding, shiftYValue)*getBatch(preproWidth, dotted);
    // picture prepro_batch3 = shift(5shiftBatch1padding, shiftYValue)*getBatch(preproWidth, dotted);
    // picture prepro_batch4 = shift(7shiftBatch1padding, shiftYValue)*getBatch(preproWidth, dotted);
    // picture prepro_batch5 = shift(9shiftBatch1padding, shiftYValue)*getBatch(preproWidth, dotted);
    
    //add(preProcPic, prepro_batch1);
    //add(preProcPic, prepro_batch2);
    // add(preProcPic, prepro_batch3);
    // add(preProcPic, prepro_batch4);
    // add(preProcPic, prepro_batch5);

    //draw copyh2d batches
    // picture copyh2dPic;
    // real copyWidth = 0.8*xshiftUnit;
    // real copyYValue =  -2*yshiftUnit;
    
    // pair ptCopyBase = (point(prepro_batch1, E).x+tinyPadding, copyYValue);
    // picture copyh2d_batch1 = shift(ptCopyBase)*getBatch(copyWidth, solid, black);
    // add(copyh2dPic, copyh2d_batch1);

    // picture trainPic;
    // real trainWidth = 2preproWidth+2*tinyPadding;
    // real trainYValue =  -3*yshiftUnit; 
    // pen Dotted(pen p=currentpen) {return linetype(new real[] {0,3})+2*linewidth(p);}

    // pair ptTrainBatch1 = (point(copyh2d_batch1, E).x+tinyPadding, trainYValue);
    // picture train_batch1 = shift(ptTrainBatch1)*getBatch(trainWidth, Dotted, gray);
    // add(trainPic, train_batch1);

    // pair ptBatch1Right = (locate(point(train_batch1, E)).x+tinyPadding, trainYValue);
    // picture train_batch2 = shift(ptBatch1Right)*getBatch(trainWidth, Dotted, gray);
    // add(trainPic, train_batch2);

//  draw regs
    // picture regsPic;

    // /*  row1
    //     00 01 02 03 04 05 06 07 08
    //     10 11 12 13 14 15 16 17 18
    // */

    // picture reg1_02 = getRegAlignToUpBatchRight(data_batch2, yaxisShift);
    // picture reg1_12 = getRegAlignToUpBatchRight(data_batch2, yaxisShift-tinyPadding-boxd);
    // add(regsPic, reg1_02);
    // add(regsPic, reg1_12);
    // picture reg1_03 = getRegAlignToUpBatchLeft(data_batch3, yaxisShift);
    // picture reg1_13 = getRegAlignToUpBatchLeft(data_batch3, yaxisShift-tinyPadding-boxd);
    // add(regsPic, reg1_03);
    // add(regsPic, reg1_13);
    // picture reg1_04 = getRegAlignToUpBatchRight(data_batch3, yaxisShift);
    // picture reg1_14 = getRegAlignToUpBatchRight(data_batch3, yaxisShift-tinyPadding-boxd);
    // add(regsPic, reg1_04);
    // add(regsPic, reg1_14);

    // add(regsPic, fillRegBox(reg1_11, fillBusy));
    // add(regsPic, fillRegBox(reg1_02, fillReady));
    // add(regsPic, fillRegBox(reg1_12, fillBusy));
    // add(regsPic, fillRegBox(reg1_03, fillBusy));
    // add(regsPic, fillRegBox(reg1_04, fillBusy));
    // add(regsPic, fillRegBox(reg1_14, fillReady));
    // //row 2

    // picture reg2_00 = getRegAlignToUpBatchLeft(data_batch1, yaxisShift+shiftYValue);
    // picture reg2_10 = getRegAlignToUpBatchLeft(data_batch1, yaxisShift+shiftYValue-boxd-tinyPadding);
    // add(regsPic, reg2_00);
    // add(regsPic, reg2_10);
    // picture reg2_01 = getRegAlignToUpBatchLeft(prepro_batch2, yaxisShift);
    // picture reg2_11 = getRegAlignToUpBatchLeft(prepro_batch2, yaxisShift - tinyPadding - boxd);
    // add(regsPic, reg2_01);
    // add(regsPic, reg2_11);

    // add(regsPic, fillRegBox(reg2_01, fillBusy));
    // pair ptBase0 = point(reg2_01, SW);
    // pair ptBase1 = point(reg2_11, SW);
    // picture reg2_02 = shift(ptBase0.x+copyWidth+tinyPadding, ptBase0.y)*blockBox();
    // picture reg2_12 = shift(ptBase1.x+copyWidth+tinyPadding, ptBase1.y)*blockBox();
    // add(regsPic, reg2_02);
    // add(regsPic, reg2_12);

    // // row 3
    // // no use regs
    // add(regsPic, shift(0, shiftYValue)*reg2_00);
    // add(regsPic, shift(0, shiftYValue)*reg2_10);

    // picture reg3_01 = shift(tinyPadding, 0)*getRegAlignToUpBatchRight(copyh2d_batch1, yaxisShift);
    // picture reg3_11 = shift(tinyPadding, 0)*getRegAlignToUpBatchRight(copyh2d_batch1, yaxisShift-tinyPadding-boxd);
    // add(regsPic, reg3_01);
    // add(regsPic, reg3_11);

//-----------------------------------------
    //add(pic, dataloadingPic);
    //add(pic, preProcPic);
    //add(pic, copyh2dPic);
    //add(pic, trainPic);
    //add(pic, regsPic);
    return pic;
}

add(getMainPic());


// add(legend());
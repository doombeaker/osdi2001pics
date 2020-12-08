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

    real preproWidth = 2.7*xshiftUnit;
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
    real trainWidth = 6.5*xshiftUnit;
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
    add(pic, fillRegBox(reg1_14, fillReady));

    //regs1 5
    picture reg1_05 = shift(tinyPadding,0)*getRegAlignToUpBatchRight(data_batch4, yaxisShift);
    picture reg1_15 = shift(tinyPadding,0)*getRegAlignToUpBatchRight(data_batch4, yaxisShift-tinyPadding-boxd);
    add(pic, fillRegBox(reg1_05, fillBusy));
    add(pic, fillRegBox(reg1_15, fillReady));    

    //Dataloader batch 5 regs1 6
    picture data_batch5 = shift(point(prepro_batch2, E).x+tinyPadding, 0)*getBatch(batchWidthUnit); 
    add(pic, data_batch5);
    
    picture reg1_06 = shift(point(prepro_batch2, E).x+tinyPadding, point(reg1_05, SW).y)*blockBox();
    picture reg1_16 = shift(point(prepro_batch2, E).x+tinyPadding, point(reg1_15, SW).y)*blockBox();
    add(pic, fillRegBox(reg1_06, fillReady));
    add(pic, fillRegBox(reg1_16, fillBusy));

    //preprocess batch 3, regs2 3
    picture prepro_batch3 = shift(point(prepro_batch2, E).x +tinyPadding, shiftYValue)*getBatch(preproWidth, dotted);
    add(pic, prepro_batch3);
    picture reg2_03 = shift(point(prepro_batch3, W).x, point(reg2_01, SW).y)*blockBox();
    picture reg2_13 = shift(point(prepro_batch3, W).x, point(reg2_11, SW).y)*blockBox();;
    add(pic, fillRegBox(reg2_03, fillFree));
    add(pic, fillRegBox(reg2_13, fillBusy));

    // copyh2d batch2
    picture copyh2d_batch2 = shift((point(prepro_batch2, E).x+tinyPadding, point(copyh2d_batch1, S).y))*getBatch(copyWidth, solid, black);
    add(pic, copyh2d_batch2);

    // regs3 2, regs2 4
    picture reg3_02 = shift(point(copyh2d_batch2, E).x+tinyPadding, point(reg3_01, SW).y)*blockBox();
    picture reg3_12 = shift(point(copyh2d_batch2, E).x+tinyPadding, point(reg3_11, SW).y)*blockBox();
    add(pic, fillRegBox(reg3_02, fillReady));
    add(pic, fillRegBox(reg3_12, fillBusy)); 

    picture reg2_04 = shift(point(copyh2d_batch2, E).x+tinyPadding, point(reg2_01, SW).y)*blockBox();
    picture reg2_14 = shift(point(copyh2d_batch2, E).x+tinyPadding, point(reg2_11, SW).y)*blockBox();;
    add(pic, fillRegBox(reg2_04, fillFree));
    add(pic, fillRegBox(reg2_14, fillFree));

    // regs1 7

    picture reg1_07 = shift(point(data_batch5, E).x+tinyPadding, point(reg1_05, SW).y)*blockBox();
    picture reg1_17 = shift(point(data_batch5, E).x+tinyPadding, point(reg1_15, SW).y)*blockBox();
    add(pic, fillRegBox(reg1_07, fillReady));
    add(pic, fillRegBox(reg1_17, fillBusy)); 

    //dataloader batch 6, regs 1 8      
    picture data_batch6 = shift(point(prepro_batch3, E).x+tinyPadding, 0)*getBatch(batchWidthUnit); 
    add(pic, data_batch6);
    picture reg1_08 = shift(point(data_batch6, W).x, point(reg1_05, SW).y)*blockBox();
    picture reg1_18 = shift(point(data_batch6, W).x, point(reg1_15, SW).y)*blockBox();
    add(pic, fillRegBox(reg1_08, fillBusy));
    add(pic, fillRegBox(reg1_18, fillReady));

    //preprocess batch 4
    picture prepro_batch4 = shift(point(prepro_batch3, E).x +tinyPadding, shiftYValue)*getBatch(preproWidth, dotted);
    add(pic, prepro_batch4);

    //copyh2d batch3, regs 2 5
    picture copyh2d_batch3 = shift((point(prepro_batch3, E).x+tinyPadding, point(copyh2d_batch1, S).y))*getBatch(copyWidth, solid, black);
    add(pic, copyh2d_batch3);             
    picture reg2_05 = shift(point(copyh2d_batch3, W).x, point(reg2_01, SW).y)*blockBox();
    picture reg2_15 = shift(point(copyh2d_batch3, W).x, point(reg2_11, SW).y)*blockBox();;
    add(pic, fillRegBox(reg2_05, fillFree));
    add(pic, fillRegBox(reg2_15, fillBusy));

    //regs 2 6
    picture reg2_06 = shift(point(copyh2d_batch3, E).x+tinyPadding, point(reg2_01, SW).y)*blockBox();
    picture reg2_16 = shift(point(copyh2d_batch3, E).x+tinyPadding, point(reg2_11, SW).y)*blockBox();;
    add(pic, fillRegBox(reg2_06, fillFree));
    add(pic, fillRegBox(reg2_16, fillFree));    
    
    return pic;
}

add(getMainPic());


// add(legend());
import geometry;

size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));
real xshiftUnit = 1.4;
pen fillReady = rgb(156,194,230);
pen fillBusy = lightgray;
pen fillFree = white;

real tinyPadding = 0.15;

// 各种 batch 的样式长度设置
real batchWidthUnit = xshiftUnit; //dataloader
real preproWidth = 2.8*xshiftUnit; //preprocess 
real copyWidth = 0.7*xshiftUnit; //copyh2d
real trainWidth = 6.5*xshiftUnit; //train

pen Dotted(pen p=currentpen) {return linetype(new real[] {0,3})+2*linewidth(p);}   

picture getBatch(real width, pen pstyle = defaultpen, pen pbg = lightgray)
{
    picture pic;
    path lineBatch = box((0,0),(width,0.05));
    fill(pic, lineBatch, pbg);
    draw(pic, lineBatch, pstyle);
    return pic;
}

picture blockBox(real w = 0.5, real h = 0.5, pen p = white) {
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
    
    //reg1 0
    add(pic, reg1_00);
    add(pic, reg1_10);

    //dataloader batch 2, reg1 1, preprocess batch1
    picture data_batch2 = shift(point(data_batch1, E).x+tinyPadding, 0)*getBatch(batchWidthUnit); 
    add(pic, data_batch2);

    picture reg1_01 = getRegAlignToUpBatchLeft(data_batch2, yaxisShift);
    picture reg1_11 = getRegAlignToUpBatchLeft(data_batch2, yaxisShift-tinyPadding-boxd);
    add(pic, reg1_01);
    add(pic, fillRegBox(reg1_11, fillBusy));

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

    real copyYValue =  -2*yshiftUnit;

    add(pic, shift(0, -yshiftUnit)*reg1_00);
    add(pic, shift(0, -yshiftUnit)*reg1_10);
    add(pic, shift(0, -2yshiftUnit)*reg1_00);
    add(pic, shift(0, -2yshiftUnit)*reg1_10);
    
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
    real trainYValue =  -3*yshiftUnit;  
    pair ptTrainBatch1 = (point(copyh2d_batch1, E).x+tinyPadding, trainYValue);
    picture train_batch1 = shift(ptTrainBatch1)*getBatch(trainWidth, Dotted, gray);
    add(pic, train_batch1);

    picture reg1_04 = shift(tinyPadding,0)*getRegAlignToUpBatchRight(data_batch3, yaxisShift);
    picture reg1_14 = shift(tinyPadding,0)*getRegAlignToUpBatchRight(data_batch3, yaxisShift-tinyPadding-boxd);
    add(pic, fillRegBox(reg1_04, fillBusy));
    add(pic, fillRegBox(reg1_14, fillReady));


    //Dataloader batch 4 regs1 5
    picture data_batch4 = shift(point(prepro_batch2, E).x+tinyPadding, 0)*getBatch(batchWidthUnit); 
    add(pic, data_batch4);
    
    picture reg1_05 = shift(point(prepro_batch2, E).x+tinyPadding, point(reg1_01, SW).y)*blockBox();
    picture reg1_15 = shift(point(prepro_batch2, E).x+tinyPadding, point(reg1_11, SW).y)*blockBox();
    add(pic, fillRegBox(reg1_05, fillFree));
    add(pic, fillRegBox(reg1_15, fillBusy));

    //regs1 6
    picture reg1_07 = shift(point(data_batch4, E).x+tinyPadding, point(reg1_01, SW).y)*blockBox();
    picture reg1_17 = shift(point(data_batch4, E).x+tinyPadding, point(reg1_11, SW).y)*blockBox();
    add(pic, fillRegBox(reg1_07, fillReady));
    add(pic, fillRegBox(reg1_17, fillBusy));

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

    //dataloader batch 5, regs 1 7      
    picture data_batch5 = shift(point(prepro_batch3, E).x+tinyPadding, 0)*getBatch(batchWidthUnit); 
    add(pic, data_batch5);
    picture reg1_07 = shift(point(data_batch5, W).x, point(reg1_01, SW).y)*blockBox();
    picture reg1_17 = shift(point(data_batch5, W).x, point(reg1_11, SW).y)*blockBox();
    add(pic, fillRegBox(reg1_07, fillBusy));
    add(pic, fillRegBox(reg1_17, fillFree));

    //preprocess batch 4
    picture prepro_batch4 = shift(point(prepro_batch3, E).x +tinyPadding, shiftYValue)*getBatch(preproWidth, dotted);
    add(pic, prepro_batch4);

    //regs 2 5         
    picture reg2_05 = shift((point(prepro_batch3, E).x+tinyPadding, point(reg2_01, SW).y))*blockBox();
    picture reg2_15 = shift((point(prepro_batch3, E).x+tinyPadding, point(reg2_11, SW).y))*blockBox();;
    add(pic, fillRegBox(reg2_05, fillFree));
    add(pic, fillRegBox(reg2_15, fillReady));

    //train batch 2
    picture train_batch2 = shift(point(train_batch1, E).x +tinyPadding, trainYValue)*xscale(0.6)*getBatch(trainWidth, Dotted, gray);
    add(pic, train_batch2);

    // copyh2d batch3 regs3 3
    picture copyh2d_batch3 = shift((point(train_batch1, E).x+tinyPadding, point(copyh2d_batch1, S).y))*getBatch(copyWidth, solid, black);
    add(pic, copyh2d_batch3);
    picture reg3_03 = shift(point(copyh2d_batch3, W).x, point(reg3_01, SW).y)*blockBox();
    picture reg3_13 = shift(point(copyh2d_batch3, W).x, point(reg3_11, SW).y)*blockBox();
    add(pic, fillRegBox(reg3_03, fillBusy));
    add(pic, fillRegBox(reg3_13, fillFree)); 

    // regs2 6
    picture reg2_06 = shift((point(copyh2d_batch3, W).x, point(reg2_01, SW).y))*blockBox();
    picture reg2_16 = shift((point(copyh2d_batch3, W).x, point(reg2_11, SW).y))*blockBox();;
    add(pic, fillRegBox(reg2_06, fillFree));
    add(pic, fillRegBox(reg2_16, fillBusy));

    //regs3 4, regs2 7
    picture reg3_04 = shift(point(copyh2d_batch3, E).x+tinyPadding, point(reg3_01, SW).y)*blockBox();
    picture reg3_14 = shift(point(copyh2d_batch3, E).x+tinyPadding, point(reg3_11, SW).y)*blockBox();
    add(pic, fillRegBox(reg3_04, fillBusy));
    add(pic, fillRegBox(reg3_14, fillReady)); 

    picture reg2_07 = shift((point(copyh2d_batch3, E).x+tinyPadding, point(reg2_01, SW).y))*blockBox();
    picture reg2_17 = shift((point(copyh2d_batch3, E).x+tinyPadding, point(reg2_11, SW).y))*blockBox();;
    add(pic, fillRegBox(reg2_07, fillFree));
    add(pic, fillRegBox(reg2_17, fillFree));

    return pic;
}

picture getLegend()
{
    picture pic;
    real d = 0.2;
    pair legendYShift = (0, -0.1-d);
    picture freeBlock = blockBox(d,d);
    freeBlock = fillRegBox(freeBlock, fillFree);
    label(freeBlock, "Free", point(freeBlock, SW), N+4E, fontsize(8pt));
    add(pic, freeBlock);   
    
    picture busyBlock = blockBox(d,d);
    busyBlock = shift(legendYShift)*fillRegBox(busyBlock, fillBusy);
    label(busyBlock, "Busy", point(busyBlock, SW), N+4E, fontsize(8pt));
    add(pic, busyBlock);

    picture readyBlock = blockBox(d,d);
    readyBlock = shift(2legendYShift)*fillRegBox(readyBlock, fillReady);
    label(readyBlock, "Ready", point(readyBlock, SW), N+4E, fontsize(8pt));
    add(pic, readyBlock);

    //batches
    real yShift = -1.8;
    real legendBatchUnit = 1.1;

    picture dataLoader = getBatch(legendBatchUnit);
    dataLoader = shift(0, yShift)*shift(point(freeBlock, W))*dataLoader;
    label(dataLoader, "Dataload", point(dataLoader, E), 4E, fontsize(8pt));
    add(pic, dataLoader);

    picture preProcess = getBatch(legendBatchUnit, dotted);
    preProcess = shift(0, -0.3)*shift(point(dataLoader, W))*preProcess;
    label(preProcess, "Preprocess", point(preProcess, E), 4E, fontsize(8pt));
    add(pic, preProcess);

    picture copyH2D = getBatch(legendBatchUnit, solid, black);
    copyH2D = shift(0, -0.3)*shift(point(preProcess, W))*copyH2D;
    label(copyH2D, "CopyH2D", point(copyH2D, E), 4E, fontsize(8pt));
    add(pic, copyH2D);

    picture training = getBatch(legendBatchUnit, Dotted, gray);
    training = shift(0, -0.3)*shift(point(copyH2D, W))*training;
    label(training, "Train", point(training, E), 4E, fontsize(8pt));
    add(pic, training);

    return pic;
}

picture mainPic = getMainPic();
add(mainPic);

pair ptCornerUp = max(mainPic, true);
//dot(ptCornerUp);

picture legendPic = shift(0, -1)*shift(ptCornerUp-2.5xshiftUnit)*getLegend();
add(legendPic);




// add(legend());
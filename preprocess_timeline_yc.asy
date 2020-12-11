import geometry;

size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(14pt));
real xshiftUnit = 1.4;
pen fillReady = rgb(156,194,230);
pen fillBusy = lightgray;
pen fillFree = white;
real batchHeight = 0.7;
real d = 0.5; //reg长度

real tinyPadding = 0.15;
real regPaddingBottom = 0.3;
real paddingBetweenBatch = 1.5;

// 各种 batch 的样式长度设置           //对齐chengcheng的流水线batch的长度
real trainWidth = 5*xshiftUnit; //train  320
real dataloadWidth = (80/320)*trainWidth; //dataloader  80
real preproWidth = (120/320)*trainWidth; //preprocess 120
real copyWidth = (70/320)*trainWidth; //copyh2d 60


pen Dotted(pen p=currentpen) {return linetype(new real[] {0,3})+2*linewidth(p);}   

picture getBatch(string s = "", real width, pen pstyle = defaultpen, pen pbg = lightgray)
{
    picture pic;
    pair d = (width, batchHeight);
    path lineBatch = box(-d/2, d/2);
    fill(pic, lineBatch, pbg);
    draw(pic, lineBatch, pstyle);
    label(pic, s);
    return pic;
}

picture blockBox(real w =d, real h = d, pen p = white) {
  picture pic;
  pair d = (w, h);
  path boxpath = box((0,0), d);
  filldraw(pic, boxpath, p);
  return pic;
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

picture getRegByBatchUpLeft(picture batchPic, string s="", 
    bool isBottom = true,
    pen pbg = fillFree)
{
    picture pic;
    real liftValue;
    if(isBottom){
        liftValue = 0;
    }else{
        liftValue = d;
    }
    picture regPic = shift(point(batchPic, NW)+(0, regPaddingBottom+liftValue))*blockBox(pbg);
    add(pic, regPic);
    pair ptCetner =  midpoint(point(regPic, W)--point(regPic, E));
    label(pic, s, ptCetner);
    return pic;
}

picture getRegByBatchDownRight(picture batchPic, string s="", 
    bool isBottom = true,
    pen pbg = fillFree, real ybase)
{
    picture pic;
    real liftValue;
    if(isBottom){
        liftValue = 0;
    }else{
        liftValue = d;
    }
    picture regPic = shift((point(batchPic,E).x+tinyPadding,regPaddingBottom+ybase+liftValue))*blockBox(pbg);
    add(pic, regPic);
    pair ptCetner =  midpoint(point(regPic, W)--point(regPic, E));
    label(pic, s, ptCetner);
    
    return pic;
}

picture getRegByBatchDownLeft(picture batchPic, string s="", 
    bool isBottom = true,
    pen pbg = fillFree, real ybase)
{
    picture pic;
    real liftValue;
    if(isBottom){
        liftValue = 0;
    }else{
        liftValue = d;
    }
    picture regPic = shift((point(batchPic,W).x,regPaddingBottom+ybase+liftValue))*blockBox(pbg);
    add(pic, regPic);
    pair ptCetner =  midpoint(point(regPic, W)--point(regPic, E));
    label(pic, s, ptCetner);
    
    return pic;
}



picture getMainPic()
{
    picture pic;

    picture[] trainBatchAry;
    for(int i = 0; i<4; ++i)
    {
        pen pBg;
        if(i%2==1)
        {
            pBg = fillReady;
        }
        else
        {
            pBg = fillBusy;
        }
        picture batchItem = shift(i*(tinyPadding+trainWidth), 0)*getBatch("Batch"+string(3+i+1),trainWidth, solid, pBg);
        trainBatchAry.push(batchItem);
        add(pic, batchItem);
    } 

    picture regTrainBatch3C0Bottom = getRegByBatchUpLeft(trainBatchAry[0], 
                                            "3", 
                                            true, fillReady);
    picture regTrainBatch3C0Top = getRegByBatchUpLeft(trainBatchAry[0], 
                                            "", 
                                            false, fillFree);
    picture regTrainBatch4C0Bottom = getRegByBatchUpLeft(trainBatchAry[1], 
                                            "", 
                                            true, fillFree);
    picture regTrainBatch4C0Top = getRegByBatchUpLeft(trainBatchAry[1], 
                                            "4", 
                                            false, fillReady);
    picture regTrainBatch5C0Bottom = getRegByBatchUpLeft(trainBatchAry[2], 
                                            "5", 
                                            true, fillBusy);
    picture regTrainBatch5C0Top = getRegByBatchUpLeft(trainBatchAry[2], 
                                            "", 
                                            false, fillFree);
    picture regTrainBatch6C0Bottom = getRegByBatchUpLeft(trainBatchAry[3], 
                                            "", 
                                            true, fillFree);
    picture regTrainBatch6C0Top = getRegByBatchUpLeft(trainBatchAry[3], 
                                            "6", 
                                            false, fillReady);


    add(pic, regTrainBatch3C0Bottom);
    add(pic, regTrainBatch3C0Top);
    add(pic, regTrainBatch4C0Bottom);
    add(pic, regTrainBatch4C0Top);
    add(pic, regTrainBatch5C0Bottom);
    add(pic, regTrainBatch5C0Top);
    add(pic, regTrainBatch6C0Bottom);
    add(pic, regTrainBatch6C0Top);

    //--------copyh2d batches
    picture[] copyH2DBatchAry;
    for(int i =0; i<trainBatchAry.length;++i)
    {
        pen pBg;
        if(i%2==0)
        {
            pBg = fillReady;
        }
        else
        {
            pBg = fillBusy;
        }
        picture batchItem = shift(point(trainBatchAry[i],W).x+copyWidth/2,
                             2*regPaddingBottom+paddingBetweenBatch)*\
                    getBatch("Batch"+string(4+i),copyWidth, solid, pBg);
        copyH2DBatchAry.push(batchItem);
        add(pic, batchItem);
    }
    real ybase = point(trainBatchAry[0], N).y;
    picture regTrainBatch3C1Bottom = getRegByBatchDownRight(copyH2DBatchAry[0],
                        "3", true, fillBusy, ybase);
    picture regTrainBatch3C1Top = getRegByBatchDownRight(copyH2DBatchAry[0],
                        "4", false, fillReady, ybase);
    picture regTrainBatch4C1Bottom = getRegByBatchDownRight(copyH2DBatchAry[1],
                        "5", true, fillBusy, ybase);
    picture regTrainBatch4C1Top = getRegByBatchDownRight(copyH2DBatchAry[1],
                        "4", false, fillReady, ybase);
    picture regTrainBatch5C1Bottom = getRegByBatchDownRight(copyH2DBatchAry[2],
                        "5", true, fillBusy, ybase);
    picture regTrainBatch5C1Top = getRegByBatchDownRight(copyH2DBatchAry[2],
                        "6", false, fillReady, ybase);
    picture regTrainBatch6C1Bottom = getRegByBatchDownRight(copyH2DBatchAry[3],
                        "7", true, fillBusy, ybase);
    picture regTrainBatch6C1Top = getRegByBatchDownRight(copyH2DBatchAry[3],
                        "6", false, fillReady, ybase);
    add(pic, regTrainBatch3C1Bottom);
    add(pic, regTrainBatch3C1Top);
    add(pic, regTrainBatch4C1Bottom);
    add(pic, regTrainBatch4C1Top);
    add(pic, regTrainBatch5C1Bottom);
    add(pic, regTrainBatch5C1Top);
    add(pic, regTrainBatch6C1Bottom);
    add(pic, regTrainBatch6C1Top);

//--------preprocess batches
    picture[] preProcessBatchAry;
    for(int i =0; i<copyH2DBatchAry.length;++i)
    {
        pen pBg;
        if(i%2==0)
        {
            pBg = fillReady;
        }
        else
        {
            pBg = fillBusy;
        }
        picture batchItem = shift(tinyPadding+point(copyH2DBatchAry[i],E).x+preproWidth/2,
                            2*regPaddingBottom+batchHeight+2paddingBetweenBatch)*\
                    getBatch("Batch"+string(6+i),preproWidth, solid, pBg);
        preProcessBatchAry.push(batchItem);
        add(pic, batchItem);
    }
    real ybase = point(copyH2DBatchAry[0], N).y;
    picture regCopyH2dBatchC0Top = getRegByBatchDownLeft(preProcessBatchAry[0],
                        "", false, fillFree, ybase);
    picture regCopyH2dBatchC0Bottom = getRegByBatchDownLeft(preProcessBatchAry[0],
                        "5", true, fillBusy, ybase);
    picture regCopyH2dBatchC1Top = getRegByBatchDownRight(preProcessBatchAry[0],
                        "6", false, fillReady, ybase);
    picture regCopyH2dBatchC1Bottom = getRegByBatchDownRight(preProcessBatchAry[0],
                        "5", true, fillBusy, ybase);
    
    picture regCopyH2dBatchC2Top = getRegByBatchDownLeft(preProcessBatchAry[1],
                        "6", false, fillReady, ybase);
    picture regCopyH2dBatchC2Bottom = getRegByBatchDownLeft(preProcessBatchAry[1],
                        "", true, fillFree, ybase);
    picture regCopyH2dBatchC3Top = getRegByBatchDownRight(preProcessBatchAry[1],
                        "6", false, fillReady, ybase);
    picture regCopyH2dBatchC3Bottom = getRegByBatchDownRight(preProcessBatchAry[1],
                        "7", true, fillBusy, ybase);

    picture regCopyH2dBatchC4Top = getRegByBatchDownLeft(preProcessBatchAry[2],
                        "", false, fillFree, ybase);
    picture regCopyH2dBatchC4Bottom = getRegByBatchDownLeft(preProcessBatchAry[2],
                        "7", true, fillFree, ybase);
    picture regCopyH2dBatchC5Top = getRegByBatchDownRight(preProcessBatchAry[2],
                        "8", false, fillReady, ybase);
    picture regCopyH2dBatchC5Bottom = getRegByBatchDownRight(preProcessBatchAry[2],
                        "7", true, fillBusy, ybase);

    picture regCopyH2dBatchC6Top = getRegByBatchDownLeft(preProcessBatchAry[3],
                        "8", false, fillReady, ybase);
    picture regCopyH2dBatchC6Bottom = getRegByBatchDownLeft(preProcessBatchAry[3],
                        "", true, fillFree, ybase);
    picture regCopyH2dBatchC7Top = getRegByBatchDownRight(preProcessBatchAry[3],
                        "8", false, fillReady, ybase);
    picture regCopyH2dBatchC7Bottom = getRegByBatchDownRight(preProcessBatchAry[3],
                        "9", true, fillBusy, ybase);

    add(pic, regCopyH2dBatchC0Top);
    add(pic, regCopyH2dBatchC0Bottom);
    add(pic, regCopyH2dBatchC1Top);
    add(pic, regCopyH2dBatchC1Bottom);
    add(pic, regCopyH2dBatchC2Top);
    add(pic, regCopyH2dBatchC2Bottom);
    add(pic, regCopyH2dBatchC3Top);
    add(pic, regCopyH2dBatchC3Bottom);
    add(pic, regCopyH2dBatchC4Top);
    add(pic, regCopyH2dBatchC4Bottom);
    add(pic, regCopyH2dBatchC5Top);
    add(pic, regCopyH2dBatchC5Bottom);
    add(pic, regCopyH2dBatchC6Top);
    add(pic, regCopyH2dBatchC6Bottom);
    add(pic, regCopyH2dBatchC7Top);
    add(pic, regCopyH2dBatchC7Bottom);

//--------dataload batches
    picture[] dataloadBatchAry;
    for(int i =0; i<preProcessBatchAry.length;++i)
    {
        pen pBg;
        if(i%2==0)
        {
            pBg = fillReady;
        }
        else
        {
            pBg = fillBusy;
        }
        picture batchItem = shift(tinyPadding+point(preProcessBatchAry[i],E).x+dataloadWidth/2,
                            2*regPaddingBottom+2batchHeight+3paddingBetweenBatch)*\
                    getBatch("Batch"+string(8+i),dataloadWidth, solid, pBg);
        dataloadBatchAry.push(batchItem);
        add(pic, batchItem);
    }
    real ybase = point(preProcessBatchAry[0], N).y;
    //special regs
    transform t = shift(-2*preproWidth,0);
    picture regPreProcessC0Top = t*getRegByBatchDownLeft(dataloadBatchAry[0],
                        "6", false, fillReady, ybase);
    picture regPreProcessC0Bottom = t*getRegByBatchDownLeft(dataloadBatchAry[0],
                        "7", true, fillBusy, ybase);    
    add(pic, regPreProcessC0Top);
    add(pic, regPreProcessC0Bottom);
    //normal regs
    picture regPreProcessC1Top = getRegByBatchDownLeft(dataloadBatchAry[0],
                        "", false, fillFree, ybase);
    picture regPreProcessC1Bottom = getRegByBatchDownLeft(dataloadBatchAry[0],
                        "7", true, fillBusy, ybase);
    picture regPreProcessC2Top = getRegByBatchDownRight(dataloadBatchAry[0],
                        "8", false, fillReady, ybase);
    picture regPreProcessC2Bottom = getRegByBatchDownRight(dataloadBatchAry[0],
                        "7", true, fillBusy, ybase);
    

    add(pic, regPreProcessC1Top);
    add(pic, regPreProcessC1Bottom);
    add(pic, regPreProcessC2Top);
    add(pic, regPreProcessC2Bottom);

    picture regPreProcessC3Top = getRegByBatchDownLeft(dataloadBatchAry[1],
                        "8", false, fillFree, ybase);
    picture regPreProcessC3Bottom = getRegByBatchDownLeft(dataloadBatchAry[1],
                        "", true, fillFree, ybase);
    picture regPreProcessC4Top = getRegByBatchDownRight(dataloadBatchAry[1],
                        "8", false, fillReady, ybase);
    picture regPreProcessC4Bottom = getRegByBatchDownRight(dataloadBatchAry[1],
                        "9", true, fillBusy, ybase);
    

    add(pic, regPreProcessC3Top);
    add(pic, regPreProcessC3Bottom);
    add(pic, regPreProcessC4Top);
    add(pic, regPreProcessC4Bottom);

    picture regPreProcessC5Top = getRegByBatchDownLeft(dataloadBatchAry[2],
                        "", false, fillFree, ybase);
    picture regPreProcessC5Bottom = getRegByBatchDownLeft(dataloadBatchAry[2],
                        "9", true, fillBusy, ybase);
    picture regPreProcessC6Top = getRegByBatchDownRight(dataloadBatchAry[2],
                        "10", false, fillReady, ybase);
    picture regPreProcessC6Bottom = getRegByBatchDownRight(dataloadBatchAry[2],
                        "9", true, fillBusy, ybase);
    

    add(pic, regPreProcessC5Top);
    add(pic, regPreProcessC5Bottom);
    add(pic, regPreProcessC6Top);
    add(pic, regPreProcessC6Bottom);

    picture regPreProcessC7Top = getRegByBatchDownLeft(dataloadBatchAry[3],
                        "10", false, fillReady, ybase);
    picture regPreProcessC7Bottom = getRegByBatchDownLeft(dataloadBatchAry[3],
                        "", true, fillFree, ybase);
    picture regPreProcessC8Top = getRegByBatchDownRight(dataloadBatchAry[3],
                        "10", false, fillReady, ybase);
    picture regPreProcessC8Bottom = getRegByBatchDownRight(dataloadBatchAry[3],
                        "11", true, fillBusy, ybase);
    

    add(pic, regPreProcessC7Top);
    add(pic, regPreProcessC7Bottom);
    add(pic, regPreProcessC8Top);
    add(pic, regPreProcessC8Bottom);

    return pic;
}

picture getLegend(picture rightTopPic=currentpicture)
{
    picture pic;

    string [] explantion = {"Free", "Busy", "Ready"};
    pen [] pens = {fillFree, fillBusy, fillReady};

    for(int i = 0; i < explantion.length;++i)
    {
        picture blockItem = shift(0, i*1.2)*blockBox(pens[i]);
        add(pic, blockItem);
        label(pic, explantion[i], point(blockItem, SW), N+4E);        
    }
    return pic;
}

picture mainPic = getMainPic();
add(mainPic);

picture legendPic = getLegend();
legendPic = shift(5tinyPadding, 0)*shift(point(mainPic, E))*legendPic;
path enBox = box(point(legendPic, SW)+(-tinyPadding,-tinyPadding), shift(1.5)*point(legendPic, NE)+(tinyPadding,tinyPadding));
draw(enBox, dashed);
add(legendPic);
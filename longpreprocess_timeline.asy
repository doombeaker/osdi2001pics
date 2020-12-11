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
real preproWidth = 5*xshiftUnit; //train  320
real dataloadWidth = (80/320)*preproWidth; //dataloader  80
real trainWidth = (120/320)*preproWidth; //train 120
real copyWidth = (70/320)*preproWidth; //copyh2d 60


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

picture getRegByBatchUpRight(picture batchPic, string s="", 
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
    picture regPic = shift(point(batchPic, NE)+(tinyPadding, regPaddingBottom+liftValue))*blockBox(pbg);
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
    picture regPic = shift((point(batchPic,E).x+tinyPadding, regPaddingBottom+ybase+liftValue))*blockBox(pbg);
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

    picture[] preProcessBatchAry;
    for(int i = 0; i<5; ++i)
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
        picture batchItem = shift(i*(tinyPadding+preproWidth), 0)*getBatch(
                "Batch"+string(1+i),
                preproWidth, 
                solid, pBg);
        preProcessBatchAry.push(batchItem);
        add(pic, batchItem);
    }

    picture regPreBatch1C0Top = getRegByBatchUpLeft(preProcessBatchAry[0], 
                                            "", 
                                            false, fillFree);
    picture regPreBatch1C0Bottom = getRegByBatchUpLeft(preProcessBatchAry[0], 
                                            "1", 
                                            true, fillBusy);
    add(pic, regPreBatch1C0Top);
    add(pic, regPreBatch1C0Bottom);

    picture regPreBatch2C0Top = getRegByBatchUpLeft(preProcessBatchAry[1], 
                                            "2", 
                                            false, fillReady);
    picture regPreBatch2C0Bottom = getRegByBatchUpLeft(preProcessBatchAry[1], 
                                            "", 
                                            true, fillFree);
    add(pic, regPreBatch2C0Top);
    add(pic, regPreBatch2C0Bottom);

    picture regPreBatch3C0Top = getRegByBatchUpLeft(preProcessBatchAry[2], 
                                            "", 
                                            false, fillFree);
    picture regPreBatch3C0Bottom = getRegByBatchUpLeft(preProcessBatchAry[2], 
                                            "3", 
                                            true, fillBusy);
    add(pic, regPreBatch3C0Top);
    add(pic, regPreBatch3C0Bottom);

    picture regPreBatch4C0Top = getRegByBatchUpLeft(preProcessBatchAry[3], 
                                            "4", 
                                            false, fillReady);
    picture regPreBatch4C0Bottom = getRegByBatchUpLeft(preProcessBatchAry[3], 
                                            "", 
                                            true, fillFree);
    add(pic, regPreBatch4C0Top);
    add(pic, regPreBatch4C0Bottom);

    picture regPreBatch5C0Top = getRegByBatchUpLeft(preProcessBatchAry[4], 
                                            "", 
                                            false, fillFree);
    picture regPreBatch5C0Bottom = getRegByBatchUpLeft(preProcessBatchAry[4], 
                                            "5", 
                                            true, fillBusy);
    add(pic, regPreBatch5C0Top);
    add(pic, regPreBatch5C0Bottom);

    picture[] dataloadBatchAry;
    real yofDataLoaderBatch =  2*regPaddingBottom+2d+batchHeight;
    transform t = shift(-tinyPadding-dataloadWidth/2+point(preProcessBatchAry[0], W).x, yofDataLoaderBatch);
    picture batch1Pic = t*getBatch("Batch1", dataloadWidth ,pbg=fillBusy);
    dataloadBatchAry.push(batch1Pic);
    add(pic, batch1Pic);
    for(int i = 0; i < preProcessBatchAry.length; ++i)
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
        picture batchItem = shift(point(preProcessBatchAry[i], W).x+dataloadWidth/2, yofDataLoaderBatch)*getBatch(
                "Batch"+string(2+i),
                dataloadWidth, 
                solid, pBg);
        dataloadBatchAry.push(batchItem);
        add(pic, batchItem);
    }

    picture[] copyH2DBatchAry;
    real yofDataLoaderBatch =  -batchHeight-2d-2regPaddingBottom;
    for(int i = 0; i < preProcessBatchAry.length-1; ++i)
    {
        pen pBg;
        if(i%2==0)
        {
            pBg = fillBusy;
        }
        else
        {
            pBg = fillReady;
        }
        picture batchItem = shift(point(preProcessBatchAry[i+1], W).x+copyWidth/2, yofDataLoaderBatch)*getBatch(
                "Batch"+string(1+i),
                copyWidth, 
                solid, pBg);
        copyH2DBatchAry.push(batchItem);
        add(pic, batchItem);
    }

    picture[] trainingBatchAry;
    real yofDataLoaderBatch = point(copyH2DBatchAry[0], S).y+yofDataLoaderBatch+batchHeight/2;
    for(int i = 0; i < copyH2DBatchAry.length; ++i)
    {
        pen pBg;
        if(i%2==0)
        {
            pBg = fillBusy;
        }
        else
        {
            pBg = fillReady;
        }
        picture batchItem = shift(point(copyH2DBatchAry[i], E).x+trainWidth/2+tinyPadding, yofDataLoaderBatch)*getBatch(
                "Batch"+string(1+i),
                trainWidth, 
                solid, pBg);
        trainingBatchAry.push(batchItem);
        add(pic, batchItem);
    }

    picture regPreBatch1C1Top = getRegByBatchDownRight(dataloadBatchAry[1], 
                                            "2", 
                                            false, fillReady,
                                            point(preProcessBatchAry[1], N).y);
    picture regPreBatch1C1Bottom = getRegByBatchDownRight(dataloadBatchAry[1], 
                                            "1", 
                                            true, fillBusy,
                                            point(preProcessBatchAry[1], N).y);
    add(pic, regPreBatch1C1Top);
    add(pic, regPreBatch1C1Bottom);

    picture regPreBatch2C1Top = getRegByBatchDownRight(dataloadBatchAry[2], 
                                            "2", 
                                            false, fillReady,
                                            point(preProcessBatchAry[1], N).y);
    picture regPreBatch2C1Bottom = getRegByBatchDownRight(dataloadBatchAry[2], 
                                            "3", 
                                            true, fillBusy,
                                            point(preProcessBatchAry[1], N).y);
    add(pic, regPreBatch2C1Top);
    add(pic, regPreBatch2C1Bottom);

    picture regPreBatch3C1Top = getRegByBatchDownRight(dataloadBatchAry[3], 
                                            "4", 
                                            false, fillReady,
                                            point(preProcessBatchAry[1], N).y);
    picture regPreBatch3C1Bottom = getRegByBatchDownRight(dataloadBatchAry[3], 
                                            "3", 
                                            true, fillBusy,
                                            point(preProcessBatchAry[1], N).y);
    add(pic, regPreBatch3C1Top);
    add(pic, regPreBatch3C1Bottom);

    picture regPreBatch4C1Top = getRegByBatchDownRight(dataloadBatchAry[4], 
                                            "4", 
                                            false, fillReady,
                                            point(preProcessBatchAry[4], N).y);
    picture regPreBatch4C1Bottom = getRegByBatchDownRight(dataloadBatchAry[4], 
                                            "5", 
                                            true, fillBusy,
                                            point(preProcessBatchAry[1], N).y);
    add(pic, regPreBatch4C1Top);
    add(pic, regPreBatch4C1Bottom);

    picture regPreBatch5C1Top = getRegByBatchDownRight(dataloadBatchAry[5], 
                                            "6", 
                                            false, fillReady,
                                            point(preProcessBatchAry[1], N).y);
    picture regPreBatch5C1Bottom = getRegByBatchDownRight(dataloadBatchAry[5], 
                                            "5", 
                                            true, fillBusy,
                                            point(preProcessBatchAry[1], N).y);
    add(pic, regPreBatch5C1Top);
    add(pic, regPreBatch5C1Bottom);

    picture regCopy1C0Top = getRegByBatchUpLeft(copyH2DBatchAry[0], 
                                            "", 
                                            false, fillFree
                                           );
    picture regCopy1C0Bottom = getRegByBatchUpLeft(copyH2DBatchAry[0], 
                                            "1", 
                                            true, fillBusy
                                            );
    add(pic, regCopy1C0Top);
    add(pic, regCopy1C0Bottom);

    picture regCopy2C0Top = getRegByBatchUpLeft(copyH2DBatchAry[1], 
                                            "2", 
                                            false, fillReady
                                           );
    picture regCopy2C0Bottom = getRegByBatchUpLeft(copyH2DBatchAry[1], 
                                            "1", 
                                            true, fillFree
                                            );
    add(pic, regCopy2C0Top);
    add(pic, regCopy2C0Bottom);

    picture regCopy3C0Top = getRegByBatchUpLeft(copyH2DBatchAry[2], 
                                            "", 
                                            false, fillFree
                                           );
    picture regCopy3C0Bottom = getRegByBatchUpLeft(copyH2DBatchAry[2], 
                                            "3", 
                                            true, fillBusy
                                            );
    add(pic, regCopy3C0Top);
    add(pic, regCopy3C0Bottom);

    picture regCopy4C0Top = getRegByBatchUpLeft(copyH2DBatchAry[3], 
                                            "4", 
                                            false, fillReady
                                           );
    picture regCopy4C0Bottom = getRegByBatchUpLeft(copyH2DBatchAry[3], 
                                            "", 
                                            true, fillFree
                                            );
    add(pic, regCopy4C0Top);
    add(pic, regCopy4C0Bottom);

    picture regTrain1C0Top = getRegByBatchUpLeft(trainingBatchAry[0], 
                                            "", 
                                            false, fillFree
                                           );
    picture regTrain1C0Bottom = getRegByBatchUpLeft(trainingBatchAry[0], 
                                            "1", 
                                            true, fillBusy
                                            );
    add(pic, regTrain1C0Top);
    add(pic, regTrain1C0Bottom);

    picture regTrain2C0Top = getRegByBatchUpLeft(trainingBatchAry[1], 
                                            "2", 
                                            false, fillReady
                                           );
    picture regTrain2C0Bottom = getRegByBatchUpLeft(trainingBatchAry[1], 
                                            "", 
                                            true, fillFree
                                            );
    add(pic, regTrain2C0Top);
    add(pic, regTrain2C0Bottom);

    picture regTrain3C0Top = getRegByBatchUpLeft(trainingBatchAry[2], 
                                            "", 
                                            false, fillFree
                                           );
    picture regTrain3C0Bottom = getRegByBatchUpLeft(trainingBatchAry[2], 
                                            "3", 
                                            true, fillBusy
                                            );
    add(pic, regTrain3C0Top);
    add(pic, regTrain3C0Bottom);

    picture regTrain4C0Top = getRegByBatchUpLeft(trainingBatchAry[3], 
                                            "4", 
                                            false, fillReady
                                           );
    picture regTrain4C0Bottom = getRegByBatchUpLeft(trainingBatchAry[3], 
                                            "", 
                                            true, fillFree
                                            );
    add(pic, regTrain4C0Top);
    add(pic, regTrain4C0Bottom);

    picture regTrain1C1Top = getRegByBatchUpRight(trainingBatchAry[0],
                                "",
                                false, fillFree);
    picture regTrain1C1Bottom = getRegByBatchUpRight(trainingBatchAry[0],
                                "",
                                true, fillFree);
    add(pic, regTrain1C1Top);
    add(pic, regTrain1C1Bottom);

    picture regTrain2C1Top = getRegByBatchUpRight(trainingBatchAry[1],
                                "",
                                false, fillFree);
    picture regTrain2C1Bottom = getRegByBatchUpRight(trainingBatchAry[1],
                                "",
                                true, fillFree);
    add(pic, regTrain2C1Top);
    add(pic, regTrain2C1Bottom);

    picture regTrain3C1Top = getRegByBatchUpRight(trainingBatchAry[2],
                                "",
                                false, fillFree);
    picture regTrain3C1Bottom = getRegByBatchUpRight(trainingBatchAry[2],
                                "",
                                true, fillFree);
    add(pic, regTrain3C1Top);
    add(pic, regTrain3C1Bottom);

    for(int i = 0; i<copyH2DBatchAry.length; ++i)
    {
        add(pic, getRegByBatchUpRight(copyH2DBatchAry[i],
                                "",
                                false, fillFree));
        add(pic, getRegByBatchUpRight(copyH2DBatchAry[i],
                                "",
                                true, fillFree));
    }

    picture regInitTop1 = shift(-tinyPadding-dataloadWidth)*regPreBatch1C0Top;
    picture regInitBottom1 = shift(0,-d)*regInitTop1;
    add(pic, regInitTop1);
    add(pic, regInitBottom1);

    picture regInitTop2 = shift(point(regInitTop1, W).x, point(regCopy1C0Top,W).y-d/2)*blockBox();
    add(pic, regInitTop2);
    add(pic, shift(0, -d)*regInitTop2);

    picture regInitTop3 = shift(point(regInitTop1, W).x, point(regTrain1C0Top,W).y-d/2)*blockBox();
    add(pic, regInitTop3);
    add(pic, shift(0, -d)*regInitTop3);
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
mainPic = shift(-min(mainPic, true))*mainPic;
add(mainPic);
picture legendPic = getLegend();
legendPic = shift(5tinyPadding, 0)*shift(point(mainPic, E))*legendPic;
path enBox = box(point(legendPic, SW)+(-tinyPadding,-tinyPadding), shift(1.5)*point(legendPic, NE)+(tinyPadding,tinyPadding));
draw(enBox, dashed);
add(legendPic);
//add();
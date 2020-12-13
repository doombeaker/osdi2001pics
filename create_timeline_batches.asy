import geometry;

size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(14pt));
real xshiftUnit = 1.4;
pen fillReady = RGB(173,215,255);
pen fillBusy = lightgray;
pen fillFree = white;

real d = 0.5; //reg长度

real tinyPadding = 0.15;
real regPaddingBottom = 0.3;
real paddingBetweenBatch = 2*d+2regPaddingBottom;

// 各种 batch 的样式长度设置           //对齐chengcheng的流水线batch的长度
real batchHeight = 0.7;          
real preproWidth = 5*xshiftUnit; //train  320
real dataloadWidth = (80/320)*preproWidth; //dataloader  80
real trainWidth = (120/320)*preproWidth; //train 120
real copyWidth = (70/320)*preproWidth; //copyh2d 60

struct tagBatch
{
    picture _pic;
    string _label;
    pen _fillpen;
    pen _stylepen;
    pair _pos;
    real _width;
    real _height = batchHeight;

    void drawAt(pair pos=_pos){
        pair d = (_width, _height);
        _pos = pos;
        path lineBatch = shift(_pos)*box((0,0), d);
        label(_pic, _label, _pos+(_width/2, _height/2));
        fill(_pic, lineBatch, _fillpen);
        draw(_pic, lineBatch, _stylepen);
    }

    void operator init(string s ="", real w, real h=batchHeight, 
                    pair pos=(0,0), 
                    pen p = defaultpen, pen pstyle=defaultpen){
        this._label = s;
        this._fillpen = p;
        this._width = w;
        this._height = h;
        this._pos = pos;
        this._stylepen = pstyle;
        this.drawAt();
    }

    void operator init(tagBatch prevPipeBatch, string s ="", real w, real h=batchHeight, 
                    real paddingValue = paddingBetweenBatch+2regPaddingBottom, 
                    pen p = prevPipeBatch._fillpen, pen pstyle=prevPipeBatch._stylepen,
                    bool isNextWorkflow=true){
        this._label = s;
        this._fillpen = p;
        this._width = w;
        this._height = h;
        this._pos = point(prevPipeBatch._pic, SE) + (tinyPadding, 0);
        if(isNextWorkflow){
            this._pos = this._pos + (0, -paddingValue);
        }else{
            this._pos = this._pos + (0, +paddingValue);
        }
        
        this._stylepen = pstyle;
        this.drawAt();
    }

    tagBatch getNextBatch(string s="", pen p = this._fillpen, pen pstyle=this._stylepen){
        pair nextPos = _pos+(_width+tinyPadding, 0);
        tagBatch nextBatch = tagBatch(s, w=_width, h=_height, nextPos, p, pstyle);
        return nextBatch;
    }
}

picture operator cast(tagBatch b) {return b._pic;}

struct tagRegs
{
    struct tagReg{
        string _s;
        pen _fillpen;

        void operator init(string s="", pen p=fillFree){
            _s = s;
            _fillpen = p;
        }
    }

    tagReg[] _regs; //0 for bottom, 1 for top
    _regs.initialized(2);
    pair _pos;
    picture _pic;

    void DrawSelf(){
        path regBottom = box((0,0), (d,d));
        label(_pic, _regs[0]._s, (d/2, d/2));
        fill(_pic, regBottom, _regs[0]._fillpen);
        draw(_pic, regBottom);

        label(_pic, _regs[1]._s, (d/2, d+d/2));
        fill(_pic, shift(0,d)*regBottom, _regs[1]._fillpen);
        draw(_pic, shift(0,d)*regBottom);

        _pic = shift(_pos)*_pic;
    }
    void operator init(tagBatch batch, string dir="NW", string sb="", pen pb=fillFree, string st="", pen pt=fillFree)
    {
        _regs[0] = tagReg(sb, pb);
        _regs[1] = tagReg(st, pt);   

        if(dir == "NW"){
            _pos = point(batch, NW) + (0, regPaddingBottom);
            DrawSelf();
        }else if(dir == "NE"){
            _pos = point(batch, NE) + (tinyPadding, regPaddingBottom);
            DrawSelf();            
        }else if(dir == "SE"){
             _pos = point(batch, SE) + (tinyPadding, -regPaddingBottom-2d);
            DrawSelf();        
        }
        else{
            write("not implemented");
        }
    }
}

picture operator cast(tagRegs b) {return b._pic;}

picture getMainPic()
{
    picture pic;
    tagBatch dataBatch1 = tagBatch("Batch1", dataloadWidth, fillBusy);
    add(pic, dataBatch1);

    tagBatch dataBatch2 = dataBatch1.getNextBatch("Batch2", fillReady);
    add(pic, dataBatch2);

    tagBatch preProcessBatch1 = tagBatch(dataBatch2, "Batch1", preproWidth, fillBusy);
    add(pic, preProcessBatch1);

    tagBatch dataBatch3 = tagBatch(preProcessBatch1, "Batch3", dataloadWidth, fillBusy, false);
    add(pic, dataBatch3);

    tagBatch preProcessBatch2 = preProcessBatch1.getNextBatch("Batch2", fillReady);
    add(pic, preProcessBatch2);

    tagBatch copyBatch1 = tagBatch(preProcessBatch1, "Batch1", copyWidth, fillBusy);
    add(pic, copyBatch1);

    tagBatch trainBatch1 = tagBatch(copyBatch1, "Batch1", trainWidth, fillBusy);
    add(pic, trainBatch1);

    tagBatch dataBatch4 = tagBatch(preProcessBatch2, "Batch4", dataloadWidth, fillReady, false);
    add(pic, dataBatch4);

    tagBatch preProcessBatch3 = preProcessBatch2.getNextBatch("Batch3", fillBusy);
    add(pic, preProcessBatch3);

    tagBatch copyBatch2 = tagBatch(preProcessBatch2, "Batch2", copyWidth, 
                            fillReady);
    add(pic, copyBatch2);

    tagBatch trainBatch2 = tagBatch(copyBatch2, "Batch2", trainWidth,
                            fillReady);
    add(pic, trainBatch2);

    tagBatch dataBatch5 = tagBatch(preProcessBatch3, "Batch5", 
                            dataloadWidth,
                            fillBusy,
                            false);
    add(pic, dataBatch5);

    tagBatch preProcessBatch4 = preProcessBatch3.getNextBatch("Batch4",
                            fillReady);
    add(pic, preProcessBatch4);
    
    tagBatch copyBatch3 = tagBatch(preProcessBatch3,
                            "Batch3",
                            copyWidth);
    add(pic, copyBatch3);

    tagBatch trainBatch3 = tagBatch(copyBatch3,
                            "Batch3",
                            trainWidth);
    add(pic, trainBatch3);

    tagBatch dataBatch6 = tagBatch(preProcessBatch4,
                            "Batch6",
                            dataloadWidth,
                            fillReady,
                            false);
    add(pic, dataBatch6);

    tagBatch copyBatch4 = tagBatch(preProcessBatch4,
                        "Batch4",
                        copyWidth);
    add(pic, copyBatch4);

    tagBatch trainBatch4 = tagBatch(copyBatch4,
    "Batch4",
    trainWidth);
    add(pic, trainBatch4);

    tagBatch preProcessBatch5 = preProcessBatch4.getNextBatch("Batch5",
            fillBusy);
    add(pic, preProcessBatch5);

    tagRegs reg0 =  tagRegs(preProcessBatch1, "NW", "1", fillBusy, "2", fillReady);
    add(pic, reg0);

    tagRegs reg1 =  tagRegs(preProcessBatch1, "NE");
    add(pic, reg1);

    tagRegs reg2 =  tagRegs(preProcessBatch1, "SE", "5", fillReady);
    add(pic, reg2);

    return pic;

}

add(getMainPic());

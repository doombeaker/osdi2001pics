import roundedpath;
import patterns;

size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));
real xshiftUnit = 1.4;
real wUnit = 2.5xshiftUnit;
pen fillblockpen = rgb(156,194,230);
real yshiftUnit = 1.9;
real d = 0.4;
real tinypadding = 0.1;
real rsize=1;

picture getCircle(real r = rsize,pen p = white)
{
    picture pic;
    path pt_circle = circle((0,0), r);
    filldraw(pic, pt_circle, p);
    return pic;
}

picture blockRoundBox(string s = "", real w = 1, real h = 1, pen p = white) {
  picture pic;
  pair d = (w, h);
  path rpath = roundedpath(box(-d/2,d/2), 0.1);
  filldraw(pic, rpath, p);
  label(pic, s);
  return pic;
}

picture blockBox(real w = d, real h = d, pen p = white) {
  picture pic;
  pair d = (w, h);
  path boxpath = box(-d/2,d/2);
  filldraw(pic, boxpath, p);
  return pic;
}

pair getCircleCenter(path pthCircle)
{
    pair ptCenter;
    ptCenter = midpoint(point(pthCircle, 0)--point(pthCircle, size(pthCircle)-2));
    return ptCenter;
}

picture addLabelCenter(picture item, string s, real max=15pt, pen psize = defaultpen)
{
    picture pic;
    label(pic, minipage(s, max), shift(midpoint(point(item,S)--point(item, N)))*(0,0), psize);
    return pic;
}

picture getPipelineWighRegPic(string s = "GPU0")
{
    picture pic;
    picture picDataLoading = shift(0, 0)*getCircle(fillblockpen);
    
    picture labelDataLoading = addLabelCenter(picDataLoading, "Data Loading", 40pt, fontsize(11pt));
    
    picture picPreprocess = shift(wUnit, 0)*getCircle();    
    picture labelPreprocess = addLabelCenter(picPreprocess, "Preprocess", 50pt, fontsize(11pt));


    picture picCopyH2D = shift(2wUnit, 0)*getCircle();
    
    picture labelCopyH2D = addLabelCenter(picCopyH2D, "CopyH2D", 40pt, fontsize(11pt));
    
    picture picComput0 = shift(3wUnit, 0)*getCircle();
    
    picture labelComput0 = addLabelCenter(picComput0, "Compute0", 45pt, fontsize(11pt));

    picture picComput1 = shift(4wUnit, 0)*getCircle();

    picture labelComput1 = addLabelCenter(picComput1, "Compute1", 45pt, fontsize(11pt));

    pair labelPos = point(picComput1,E)+(0.25wUnit, 0);

    //regs
    pair pt0 = midpoint(point(picDataLoading, E)--point(picPreprocess,W));
    picture reg_00 = shift(pt0+(0, -d/2-0.25))*blockBox();
    picture reg_10 = shift(pt0+(0, -d/2-0.25-d))*blockBox(fillblockpen);

    pair pt0 = midpoint(point(picCopyH2D, E)--point(picComput0,W));
    picture reg_02 = shift(pt0+(0, -d/2-0.25))*blockBox();
    picture reg_12 = shift(pt0+(0, -d/2-0.25-d))*blockBox(fillblockpen);

    pair pt0 = midpoint(point(picPreprocess, E)--point(picCopyH2D,W));
    picture reg_01 = shift(pt0+(0, -d/2-0.25))*blockBox();
    picture reg_11 = shift(pt0+(0, -d/2-0.25-d))*blockBox(fillblockpen);

    pair pt0 = midpoint(point(picComput0, E)--point(picComput1,W));
    picture reg_3 = shift(pt0+(0, -d/2-0.25-d/2))*blockBox(fillblockpen);

    //draw bg box
    real left = point(picCopyH2D, W).x - tinypadding;
    real bottom = point(picCopyH2D, S).y - tinypadding;
    real right = labelPos.x + tinypadding;
    real top = point(picComput1, N).y +tinypadding;
    filldraw(pic, box((left, bottom),(right,top)), lightgray);
    label(pic, s, (right, top), SW);
    label(pic, "$\dots$", labelPos,W);

    //lines between node, regs
    draw(pic, point(picDataLoading, E){right}..{right}point(reg_00, W), Arrow);
    draw(pic, point(reg_10, E){right}..{NE}point(picPreprocess, W), Arrow);

    draw(pic, point(picPreprocess, E){right}..{right}point(reg_01, W), Arrow);
    draw(pic, point(reg_11, E){right}..{NE}point(picCopyH2D, W), Arrow);

    draw(pic, point(picCopyH2D, E){right}..{right}point(reg_02, W), Arrow);
    draw(pic, point(reg_12, E){right}..{NE}point(picComput0, W), Arrow);

    draw(pic, point(picComput0, E){right}..{right}point(reg_3, W), Arrow);
    draw(pic, point(reg_3, E){right}..{NE}point(picComput1, W), Arrow);

    add(pic, picDataLoading);
    add(pic, labelDataLoading);    
    add(pic, picPreprocess);
    add(pic, labelPreprocess);
    draw(pic, point(picDataLoading,E)--point(picPreprocess,W), Arrow);    
    add(pic, picCopyH2D);
    draw(pic, point(picPreprocess,E)--point(picCopyH2D,W), Arrow);
    add(pic, labelCopyH2D);
    add(pic, picComput0);
    add(pic, labelComput0);
    draw(pic, point(picCopyH2D,E)--point(picComput0,W), Arrow);    
    
    add(pic, picComput1);
    add(pic, labelComput1);

    draw(pic, point(picComput0,E)--point(picComput1,W), Arrow);
    add(pic,reg_00);
    add(pic,reg_10);
    add(pic,reg_01);
    add(pic,reg_11);
    add(pic,reg_02);
    add(pic,reg_12);
    add(pic,reg_3);

    return pic;
}

picture getPipelinePic(string s = "GPU0")
{
    picture pic;
    picture picDataLoading = shift(0, 0)*getCircle(fillblockpen);
    add(pic, picDataLoading);
    picture labelDataLoading = addLabelCenter(picDataLoading, "Data Loading", 40pt, fontsize(11pt));
    add(pic, labelDataLoading);

    picture picPreprocess = shift(wUnit, 0)*getCircle();
    picture labelPreprocess = addLabelCenter(picPreprocess, "Preprocess", 50pt, fontsize(11pt));

    picture picCopyH2D = shift(2wUnit, 0)*getCircle();

    picture labelCopyH2D = addLabelCenter(picCopyH2D, "CopyH2D", 40pt, fontsize(11pt));


    picture picComput0 = shift(3wUnit, 0)*getCircle();

    picture labelComput0 = addLabelCenter(picComput0, "Compute0", 45pt, fontsize(11pt));

    picture picComput1 = shift(4wUnit, 0)*getCircle();

    picture labelComput1 = addLabelCenter(picComput1, "Compute1", 45pt, fontsize(11pt));
    pair labelPos = point(picComput1,E)+(0.25wUnit, 0);
    picture picdots = shift(labelPos)*getCircle(0);
    

    //draw bg box
    real left = point(picCopyH2D, W).x - tinypadding;
    real bottom = point(picCopyH2D, S).y - tinypadding;
    real right = labelPos.x + tinypadding;
    real top = point(picComput1, N).y +tinypadding;
    filldraw(pic, box((left, bottom),(right,top)), lightgray);
    label(pic, s, (right, top), SW);
    label(pic, "$\dots$", labelPos,W);

    // add  subpics
    add(pic, picPreprocess);
    add(pic, labelPreprocess);
    draw(pic, point(picDataLoading,E)--point(picPreprocess,W), Arrow);
    add(pic, picCopyH2D);
    add(pic, labelCopyH2D);
    draw(pic, point(picPreprocess,E)--point(picCopyH2D,W), Arrow);
    add(pic, picComput0);    
    add(pic, picComput1);
    add(pic, labelComput1);
    add(pic, labelComput0);

    draw(pic, point(picCopyH2D,E)--point(picComput0,W), Arrow);
    draw(pic, point(picComput0,E)--point(picComput1,W), Arrow);
    return pic;
}

picture picDisk = blockRoundBox("Disk", w=1.5, h=1.5);
real diskShiftUnit = 0.75wUnit;
picture picC2G0 = shift(diskShiftUnit, 2yshiftUnit)*getPipelineWighRegPic("GPU0");
picture picC2G1 = shift(diskShiftUnit, 0.65yshiftUnit)*getPipelinePic("GPU1"); 
picture picC2G2 = shift(diskShiftUnit, -0.65yshiftUnit)*getPipelinePic("GPU2"); 
picture picC2G3 = shift(diskShiftUnit, -2yshiftUnit)*getPipelinePic("GPU3"); 

draw(point(picDisk, E){right}.. tension 3 ..{right}point(picC2G0, W), Arrow);
draw(point(picDisk, E){right}.. tension 1 ..{right}point(picC2G1, W), Arrow);
draw(point(picDisk, E){right}.. tension 1 ..{right}point(picC2G2, W), Arrow);
draw(point(picDisk, E){right}.. tension 3 ..{right}point(picC2G3, W), Arrow);

// draw cpu box
real left = point(picC2G0, W).x - tinypadding;
real top = point(picC2G0, N).y + tinypadding;
real right = diskShiftUnit  + 1.5wUnit;
real bottom = point(picC2G3, S).y - tinypadding;
draw(box((left, bottom),(right,top)), dashed);
label("CPU", (right, top), SW);

add(picDisk);
add(picC2G0);
add(picC2G1);
add(picC2G2);
add(picC2G3);


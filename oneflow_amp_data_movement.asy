import roundedpath;
import patterns;

size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));
real xshiftUnit = 1.4;
real wUnit = 3xshiftUnit;
pen fillblockpen = rgb(156,194,230);

picture getCircle(pen p = white)
{
    picture pic;
    path pt_circle = circle((0,0), 1);
    filldraw(pic, pt_circle, p);
    return pic;
}

picture blockBox(string s = "", real w = 1, real h = 1, pen p = white) {
  picture pic;
  pair d = (w, h);
  path rpath = roundedpath(box(-d/2,d/2), 0.1);
  filldraw(pic, rpath, p);
  label(pic, s);
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

picture getMixDecodeNode(real r=1)
{
    picture pic;
    pen hatchpen = gray;
    add("hatch",hatch(gray));
    add("hatchback",hatch(NW, gray));
    add("crosshatch", crosshatch(3mm, mediumgray));

    picture picLeft;

    pair pbox = (2r, 2r);
    path pth_box = shift(-r,0)*box(-pbox/2, pbox/2);

    path pth_circle = circle((0,0), r);
    filldraw(pic, pth_circle, white);
    filldraw(pic, pth_circle, pattern("crosshatch"));
    //add(pic, pth_circle);
    // filldraw(picLeft, pth_circle, pattern("hatch"));
    // clip(picLeft, pth_box);

    // picture picRight;
    // filldraw(picRight, pth_circle, pattern("hatchback"));
    // clip(picRight, shift(2r,0)*pth_box); 

    // add(pic, picLeft);
    // add(pic, picRight);  
    return pic;
}

picture picDisk = blockBox("Disk", w=1.5, h=1.5);

picture picDataLoading = shift(wUnit, 0)*getCircle(fillblockpen);
picture labelDataLoading = addLabelCenter(picDataLoading, "Data Loading", 40pt, fontsize(11pt));

picture picDecode = shift(2wUnit, 0)*getMixDecodeNode();
picture labelDecode = addLabelCenter(picDecode, "Decode", 40pt, fontsize(13pt));

picture picPreprocess = shift(3wUnit, 0)*blockBox("Preprocessing", w=3, h=1.5);

picture picTraining = shift(4wUnit, 0)*blockBox("Training", w=3, h=1.5);

// draw cpu box
real padding =  0.1*wUnit;
real cpuLeft = xpart(point(picDataLoading, W)) -padding;
real cpuUp = ypart(point(picDataLoading, N)) + padding;
real cpuRight = xpart(point(picDecode, 0));
real cpuDown = ypart(point(picDataLoading, S)) - padding;

pair cpuLeftDown = (cpuLeft, cpuDown);
pair cpuRightUp = (cpuRight, cpuUp);
path cpuBox = box(cpuLeftDown,cpuRightUp);
filldraw(cpuBox, pattern("hatch"));

label("mixed", point(picDecode, S), 4S);

label("CPU", midpoint((cpuLeft, cpuUp)--(cpuRight, cpuUp)), N);

// // label gpu box
real gpuLeft = cpuRight;
real gpuUp = ypart(point(picDataLoading, N)) + padding;
real gpuRight = xpart(point(picTraining, E)) + padding;
real gpuDown = ypart(point(picDataLoading, S)) - padding;

pair gpuLeftDown = (gpuLeft, gpuDown);
pair gpuRightUp = (gpuRight, gpuUp);
path gpuBox = box(gpuLeftDown,gpuRightUp);
filldraw(gpuBox, pattern("hatchback"));

label("GPU", midpoint((gpuLeft, gpuUp)--(gpuRight, gpuUp)), N);


//add pictures

add(picDisk);
add(picDataLoading);
add(labelDataLoading);
add(picDecode);
add(labelDecode);
add(picPreprocess);
add(picTraining);

//draw lines
draw(point(picDisk, E)--point(picDataLoading, W), Arrow);
draw(point(picDataLoading, E)--point(picDecode, W), Arrow);
draw(point(picDecode, E)--point(picPreprocess, W), Arrow);
draw(point(picPreprocess, E)--point(picTraining, W), Arrow);


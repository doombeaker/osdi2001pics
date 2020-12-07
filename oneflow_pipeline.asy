import roundedpath;

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

picture addLabelCenter(picture item, string s, real max=15pt)
{
    picture pic;
    label(pic, minipage(s, max), shift(midpoint(point(item,S)--point(item, N)))*(0,0), fontsize(11pt));
    return pic;
}

picture picDisk = blockBox("Disk", w=1.5, h=1.5);
picture picDataLoading = shift(wUnit, 0)*getCircle(fillblockpen);
picture labelDataLoading = addLabelCenter(picDataLoading, "Data Loading", 40pt);
picture picPreprocess = shift(2wUnit, 0)*blockBox("Preprocessing", w=3, h=1.5);
picture picCopy2HD = shift(3wUnit, 0)*getCircle(fillblockpen);
picture labelCopyH2D = addLabelCenter(picCopy2HD, "CopyH2D", 40pt);


picture picTraining = shift(4wUnit, 0)*blockBox("Training", w=3, h=1.5);

// draw cpu box
real padding =  0.1*wUnit;
real cpuLeft = xpart(point(picDataLoading, W)) -padding;
real cpuUp = ypart(point(picDataLoading, N)) + padding;
real cpuRight = xpart(point(picPreprocess, E)) +padding;
real cpuDown = ypart(point(picDataLoading, S)) - padding;

write(cpuLeft);
pair cpuLeftDown = (cpuLeft, cpuDown);
pair cpuRightUp = (cpuRight, cpuUp);
path cpuBox = box(cpuLeftDown,cpuRightUp);
filldraw(cpuBox, palegray);

label("CPU", midpoint((cpuLeft, cpuUp)--(cpuRight, cpuUp)), S);

// label gpu box
label("GPU", (point(picTraining, N).x, cpuUp), S);


//add pictures

add(picDisk);
add(picDataLoading);
add(labelDataLoading);
add(picPreprocess);
add(picCopy2HD);
add(labelCopyH2D);
add(picTraining);

//draw lines
draw(point(picDisk, E)--point(picDataLoading, W), Arrow);
draw(point(picDataLoading, E)--point(picPreprocess, W), Arrow);
draw(point(picPreprocess, E)--point(picCopy2HD, W), Arrow);
draw(point(picCopy2HD, E)--point(picTraining, W), Arrow);


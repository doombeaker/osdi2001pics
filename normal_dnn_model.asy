size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));
real xshiftUnit = 1.4;
real wUnit = 6xshiftUnit;
pen fillblockpen = rgb(156,194,230);

picture getCircle(pen p = white)
{
    picture pic;
    path pt_circle = circle((0,0), 0.5);
    filldraw(pic, pt_circle, p);
    return pic;
}

picture blockBox(real w = 1, real h = 1, pen p = white) {
  picture pic;
  pair d = (w, h);
  filldraw(pic,box(-d/2,d/2), p);
  return pic;
}

picture addLabelDown(picture item, string s, real max=15pt)
{
    picture pic;
    draw(pic, minipage(s, max), (0,0), S);
    pic = shift(point(item,S))*pic;
    return pic;
}


picture picData = blockBox(fillblockpen);
add(picData);
label("Data", point(picData, S), S);

picture picConvLayer = shift(xshiftUnit, 0)*blockBox(w=0.3, h = 2);
add(picConvLayer);
picture convLabel = addLabelDown(picConvLayer, "Conv Layer");
add(convLabel);


picture picReluLayer = shift(2xshiftUnit, 0)*blockBox(w=0.3, h = 2);
add(picReluLayer);
picture ReluLabel = addLabelDown(picReluLayer, "Relu Layer");
add(ReluLabel);

picture picPoolingLayer = shift(3xshiftUnit, 0)*blockBox(w=0.3, h = 2);
add(picPoolingLayer);
picture PoolingLabel = addLabelDown(picPoolingLayer, "Pooling Layer");
add(PoolingLabel);

real paddingHidden = 0.7xshiftUnit;
picture picHiddenLayer0 = shift(4xshiftUnit, 0)*blockBox(w=0.3, h = 2);
picture picHiddenLayer1 = shift(paddingHidden, 0)*picHiddenLayer0;
add(picHiddenLayer0);
add(picHiddenLayer1);
picture HiddenLabel = addLabelDown(picHiddenLayer0, "\flushright{Hidden Layers}", 70pt);
add(HiddenLabel);
label("$\dots$", midpoint(point(picHiddenLayer0,E)--point(picHiddenLayer1,W)));

picture picDenseLayer = shift(paddingHidden+5xshiftUnit, 0)*blockBox(w=0.3, h = 2);
add(picDenseLayer);
picture DenseLabel = addLabelDown(picDenseLayer, "\flushright{Dense Layer}", 50pt);
add(DenseLabel);

picture picLoss = shift(paddingHidden+6xshiftUnit, 0)*getCircle(lightgray);
add(picLoss);
picture LossLabel = addLabelDown(picLoss, "Loss");
add(LossLabel);

// draw lines
draw(point(picData, E)--point(picConvLayer, W), Arrow);
draw(point(picConvLayer, E)--point(picReluLayer, W), Arrow);
draw(point(picReluLayer, E)--point(picPoolingLayer, W), Arrow);
draw(point(picPoolingLayer, E)--point(picHiddenLayer0, W), Arrow);
draw(point(picHiddenLayer1, E)--point(picDenseLayer, W), Arrow);
draw(point(picDenseLayer, E)--point(picLoss, W), Arrow);

// box
pair ptLeftDown = (midpoint(point(picData, E)--point(picConvLayer,W)).x, point(convLabel, S).y- 0.7xshiftUnit);
pair ptRightUp = (point(picLoss, E).x+0.2xshiftUnit, point(picDenseLayer, N).y+0.4xshiftUnit);
//dot(ptLeftDown--ptRightUp, red);
draw(box(ptLeftDown,ptRightUp), dashed);

pair titlepos = (midpoint(ptLeftDown--ptRightUp).x, ptRightUp.y);
label("Computing primitives", titlepos, S);
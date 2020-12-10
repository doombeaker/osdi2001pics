size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));
real xshiftUnit = 1.1;
pen fillReady = rgb(156,194,230);
pen ackStyle = dotted;
pen reqStyle = dashdotted;
real rsize = 0.5;
real blockUnit = 1;

picture getCircle(pair pos, real r = rsize)
{
    picture pic;
    path pt_circle = circle(pos, r);
    draw(pic, pt_circle);
    return pic;
}

picture blockBox(string s="", real w = blockUnit, real h = blockUnit, pen p = black, pen bgp=white) 
{
  picture pic;
  pair d = (w, h);
  path boxpath = box(-d/2, d/2);
  fill(pic, boxpath, bgp);
  draw(pic, boxpath, p);
  label(pic, s, (0,0), fontsize(14pt));
  return pic;
}

picture getMainPic()
{
    picture pic;

    real yshiftUnit = -1.5;
    real xAxisValue = 1.5xshiftUnit;

    picture ringBuffer1 = shift(-2xAxisValue-blockUnit, 0)*blockBox("$r_1$");
    picture ringBuffer2 = shift(-xAxisValue, 0)*blockBox("$r_2$");
    picture ringBuffer3 = shift(xAxisValue, 0)*blockBox("$r_3$");
    picture ringBuffer4 = shift(2xAxisValue+blockUnit, 0)*blockBox("$r_4$");

    add(pic, ringBuffer1);
    add(pic, ringBuffer2);
    add(pic, ringBuffer3);
    add(pic, ringBuffer4);

    pair ptFWActor = shift(0, 1.5*yshiftUnit)*midpoint(point(ringBuffer1,E)--point(ringBuffer2, W));
    pair ptBWActor = shift(0, 1.5*yshiftUnit)*midpoint(point(ringBuffer2,E)--point(ringBuffer3, W));
    pair ptUpdateActor = shift(0, 1.5*yshiftUnit)*midpoint(point(ringBuffer3,E)--point(ringBuffer4, W));

    picture cirFWActor = getCircle(ptFWActor);
    label(pic, minipage("forward actor", 30pt), point(cirFWActor, S), S);
    picture cirBWActor = getCircle(ptBWActor);
    label(pic, minipage("backward actor", 30pt), point(cirBWActor, S), S);
    picture cirUpdateActor = getCircle(ptUpdateActor);
    label(pic, minipage("ssp update\\ actor", 70pt), point(cirUpdateActor, S)+0.5E, S);

    add(pic, cirFWActor);
    add(pic, cirBWActor);
    add(pic, cirUpdateActor);

    path buffer2ToFWActor = point(ringBuffer2, S){left}..{down}point(cirFWActor, N);
    draw(pic, buffer2ToFWActor, reqStyle, Arrow);
    path FWActorTobuffer2 = point(cirFWActor, N){right}..{up}point(ringBuffer2, S);
    draw(pic, FWActorTobuffer2, ackStyle, Arrow);

    path buffer3ToBWActor = point(ringBuffer3, S){left}..{down}point(cirBWActor, N);
    draw(pic, buffer3ToBWActor, reqStyle, Arrow);
    path BWActorTobuffer3 = point(cirBWActor, N){right}..{up}point(ringBuffer3, S);
    draw(pic, BWActorTobuffer3, ackStyle, Arrow);

    path updateTobuffer3 = point(cirUpdateActor, N){up}..{left}point(ringBuffer3, E);
    draw(pic, updateTobuffer3, reqStyle, Arrow);

    path buffer2ToUpdate = point(ringBuffer2, N).. tension 1.5 ..midpoint(point(ringBuffer3,NE)--point(ringBuffer4, NW))..point(cirUpdateActor,N);
    draw(pic, buffer2ToUpdate, reqStyle, Arrow);

    path backToUpdate = point(cirBWActor, E)..point(cirUpdateActor, W);
    draw(pic, backToUpdate, reqStyle, Arrow);

    label(pic, "1. $r_{10}$", midpoint(buffer2ToFWActor), W);
    label(pic, "2. $r_{10}$", midpoint(FWActorTobuffer2), E);
    label(pic, "3. $r_{7}$", midpoint(buffer3ToBWActor), W);
    label(pic, "5. $r_{7}$", midpoint(BWActorTobuffer3), E);
    label(pic, "4. $r_{10}$", midpoint(buffer2ToUpdate), N);
    label(pic, "6. $r_{11}$", midpoint(updateTobuffer3));
    label(pic, "4. G_{10}", midpoint(backToUpdate), S);

    picture legendPic;
    draw(legendPic, (0,0)--(1,0), reqStyle);
    label(legendPic, "req", (1,0), E);
    draw(legendPic, (0, 0.5)--(1,0.5), ackStyle);
    label(legendPic, "ack", (1,0.5), E);

    real x = point(ringBuffer1, W).x;
    real y = point(ringBuffer1, N).y + 0.5;
    legendPic = shift(x,y)*legendPic;
    add(pic, legendPic);
    return pic;
}

picture mainPic =getMainPic();
add(mainPic);

size(20cm, 0);
unitsize(20, 0);
defaultpen(fontsize(13pt));

real shiftSizeUnit = 7;

picture fillEllipse(path pthEllipse, string s="", real pagewidth = 50pt, pen p=white)
{
    picture pic;
    pair ptCenter = midpoint(point(pthEllipse,0)--point(pthEllipse,2));
    label(ptCenter, minipage(s, pagewidth));
    filldraw(pic, pthEllipse, p);
    return pic;
}

path genEllipse(pair pos=(0,0), real a=2.5, real b = 1.3)
{
    return ellipse(pos, a, b);
}

picture drawCurveDonw2Up(string s, pair ptDown, pair ptUp, pair dir=NW)
{
    picture pic;
    path mypath = ptDown{up}..{up}ptUp;
    draw(pic, mypath, Arrow);
    label(midpoint(mypath), s, dir);
    return pic;
}

real xshift = 1.3shiftSizeUnit;
real yshift = -shiftSizeUnit;
pair ptOutRready = (xshift, 0);
pair ptOutInReady = (2xshift, 0);
pair ptNoOutIn = (xshift, yshift);
pair ptRunning = (2xshift, yshift);
pair ptInReady = midpoint(ptOutRready--ptOutInReady--ptNoOutIn--ptRunning);

path nodeStart = genEllipse();
path nodeOutReady = shift(ptOutRready)*genEllipse();
path nodeOutInReady = shift(ptOutInReady)*genEllipse();
path nodeNoOutIn = shift(ptNoOutIn)*genEllipse();
path nodeRunning = shift(ptRunning)*genEllipse();
path nodeInReady = shift(ptInReady)*genEllipse();

dot();

pair ptNoOutInRightUp = intersectionpoint(nodeNoOutIn, ptNoOutIn--(ptNoOutIn+(5,5)));
pair ptInReadyLeftDwon = intersectionpoint(nodeInReady, ptInReady--(ptNoOutIn+(-5,-5)));
pair ptInReadyRightUp = intersectionpoint(nodeInReady, ptInReady--(ptNoOutIn+(5,5)));
pair ptOutInReadyLeftDwon = intersectionpoint(nodeOutInReady, ptOutInReady--(ptOutInReady+(-5,-5)));

picture startPic = fillEllipse(nodeStart, "\quad start", lightgray);
add(startPic);

picture outReadyPic = fillEllipse(nodeOutReady, "\emph{out}\\available", lightgray);
add(outReadyPic);

picture outInReadyPic = fillEllipse(nodeOutInReady, "\emph{out} available\\\emph{in} available", 70pt, lightgray);
add(outInReadyPic);

picture noOutInPic = fillEllipse(nodeNoOutIn, "no \emph{out}\\ no \emph{in}", 35pt, lightgray);
add(noOutInPic);

picture runningPic = fillEllipse(nodeRunning, "\quad running", 70pt);
add(runningPic);

picture inReadyPic = fillEllipse(nodeInReady, "\emph{in}\\available", lightgray);
add(inReadyPic);

picture curvePic0 = drawCurveDonw2Up("on \emph{req} msg", ptNoOutInRightUp, ptInReadyLeftDwon, SE);
add(curvePic0);
picture curvePic1 = drawCurveDonw2Up("on \emph{ack} msg", ptInReadyRightUp, ptOutInReadyLeftDwon);
add(curvePic1);

path start2outReady = point(startPic, E)--point(outReadyPic, W);
draw(start2outReady, Arrow);

path outReady2OutInReady = point(outReadyPic, E)--point(outInReadyPic, W);
draw(outReady2OutInReady, Arrow);
label("on \emph{req} msg", midpoint(outReady2OutInReady), up);

path outInReady2Running = point(outInReadyPic, S)--point(runningPic, N);
draw(outInReady2Running, Arrow);

path running2NoOutIn = point(runningPic, W)--point(noOutInPic, E);
draw(running2NoOutIn, Arrow);

path noOutIn2Ready = point(noOutInPic, N)--point(outReadyPic, S);
draw(noOutIn2Ready, Arrow);


picture labelpic;
size(labelpic, 0.2cm, 0);
pair labelPos = midpoint(point(outReadyPic, S)--point(noOutInPic, N));
label(labelpic, "on \emph{ack} msg", labelPos, left);
labelpic = shift(0.72shiftSizeUnit, -1.6shiftSizeUnit)*rotate(90)*labelpic;
add(labelpic);


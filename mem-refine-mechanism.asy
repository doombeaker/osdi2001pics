real g_colSpace = 2;
defaultpen(fontsize(14pt));
size(30cm, 0);
unitsize(50);

picture getCircleNode(string strLabel, pair pos, pen p=mediumgray){
    picture pic;
    fill(pic, circle((0,0), 0.2*g_colSpace), p);
    label(pic, strLabel);
    return shift(pos)*pic;
}

void drawLeft2Right(picture pic, picture circleFrom, picture circleTo, pen p=defaultpen)
{
    pair ptFrom = point(circleFrom, E);
    pair ptTo = point(circleTo, W);
    draw(pic, ptFrom--ptTo, p, Arrow);
}

void drawRight2Left(picture pic, picture circleFrom, picture circleTo, pen p=defaultpen)
{
    pair ptFrom = point(circleFrom, W);
    pair ptTo = point(circleTo, E);
    draw(pic, ptFrom--ptTo, p, Arrow);
}

void drawUp2Down(picture pic, picture circleFrom, picture circleTo, pen p=defaultpen)
{
    pair ptFrom = point(circleFrom, S);
    pair ptTo = point(circleTo, N);
    draw(pic, ptFrom--ptTo, p, Arrow);
}

picture getOriginPic()
{
    picture originpic;
    real colSpace = 2;
    size(originpic, 30cm);
    // foward
    picture FW_a = getCircleNode("$FW_a$", (colSpace, 0));
    picture FW_b = getCircleNode("$FW_b$", (2colSpace, 0));
    picture FW_c = getCircleNode("$FW_c$", (3colSpace, 0));
    picture FW_d = getCircleNode("$FW_d$", (4colSpace, 0));
    picture FW_e = getCircleNode("$FW_e$", (5colSpace, 0));
    picture FW_f = getCircleNode("$FW_f$", (6colSpace, 0));
    picture FW_g = getCircleNode("$FW_g$", (7colSpace, 0));

    add(originpic, FW_a);
    add(originpic, FW_b);
    add(originpic, FW_c);
    add(originpic, FW_d);
    add(originpic, FW_e);
    add(originpic, FW_f);
    add(originpic, FW_g);

    // backword
    picture BW_a = getCircleNode("$BW_a$", (colSpace, -colSpace));
    picture BW_b = getCircleNode("$BW_b$", (2colSpace, -colSpace));
    picture BW_c = getCircleNode("$BW_c$", (3colSpace, -colSpace));
    picture BW_d = getCircleNode("$BW_d$", (4colSpace, -colSpace));
    picture BW_e = getCircleNode("$BW_e$", (5colSpace, -colSpace));
    picture BW_f = getCircleNode("$BW_f$", (6colSpace, -colSpace));
    picture BW_g = getCircleNode("$BW_g$", (7colSpace, -colSpace));

    add(originpic, BW_a);
    add(originpic, BW_b);
    add(originpic, BW_c);
    add(originpic, BW_d);
    add(originpic, BW_e);
    add(originpic, BW_f);
    add(originpic, BW_g);

    // loss node
    pair FW_g_pt = point(FW_g, E);
    pair BW_g_pt = point(BW_g, E);
    pair loss_pos = shift(0.8colSpace,0)*midpoint(FW_g_pt--BW_g_pt);
    picture lossNode = getCircleNode("$Loss$", loss_pos, lightyellow);
    add(originpic, lossNode);

    // arrow line up to down
    drawUp2Down(originpic, FW_a, BW_a);
    drawUp2Down(originpic, FW_b, BW_b);
    drawUp2Down(originpic, FW_c, BW_c);
    drawUp2Down(originpic, FW_d, BW_d);
    drawUp2Down(originpic, FW_e, BW_e);
    drawUp2Down(originpic, FW_f, BW_f);
    drawUp2Down(originpic, FW_g, BW_g);

    // arrow line forward
    drawLeft2Right(originpic, FW_a, FW_b);
    drawLeft2Right(originpic, FW_b, FW_c);
    drawLeft2Right(originpic, FW_c, FW_d);
    drawLeft2Right(originpic, FW_d, FW_e);
    drawLeft2Right(originpic, FW_e, FW_f);
    drawLeft2Right(originpic, FW_f, FW_g);

    // arrow line backword
    drawRight2Left(originpic, BW_b, BW_a);
    drawRight2Left(originpic, BW_c, BW_b);
    drawRight2Left(originpic, BW_d, BW_c);
    drawRight2Left(originpic, BW_e, BW_d);
    drawRight2Left(originpic, BW_f, BW_e);
    drawRight2Left(originpic, BW_g, BW_f);

    // arrow to loss
    path FG2Loss = point(FW_g, E){right}..{ESE}point(lossNode, W);
    draw(originpic, FG2Loss, Arrow);
    path Loss2BG = point(lossNode, W){left}..{WSW}point(BW_g, E);
    draw(originpic, Loss2BG, Arrow);

    return originpic;
}

picture getOptimizedPic()
{
    picture pic;
    real colSpace = 2;
    size(pic, 30cm);
    // foward
    picture FW_a = getCircleNode("$FW_a$", (colSpace, 0));
    picture FW_b = getCircleNode("$FW_b$", (2colSpace, 0));
    picture CP_Begin = getCircleNode("$CP_b$", (3colSpace, 0), cyan);
    picture FW_c = getCircleNode("$FW_c$", (4colSpace, 0));
    picture FW_d = getCircleNode("$FW_d$", (5colSpace, 0));
    picture FW_e = getCircleNode("$FW_e$", (6colSpace, 0));
    picture CP_End = getCircleNode("$CP_e$", (7colSpace, 0), cyan);
    picture FW_f = getCircleNode("$FW_f$", (8colSpace, 0));
    picture FW_g = getCircleNode("$FW_g$", (9colSpace, 0));

    add(pic, FW_a);
    add(pic, FW_b);
    add(pic, CP_Begin);
    add(pic, FW_c);
    add(pic, FW_d);
    add(pic, FW_e);
    add(pic, CP_End);
    add(pic, FW_f);
    add(pic, FW_g);

    // backword
    real rowSpace = 3.5;
    picture BW_a = getCircleNode("$BW_a$", (colSpace, -rowSpace));
    picture BW_b = getCircleNode("$BW_b$", (2colSpace, -rowSpace));
    picture CPBW_Begin = getCircleNode("$CP^0_b$", (3colSpace, -rowSpace), cyan);
    picture BW_c = getCircleNode("$BW_c$", (4colSpace, -rowSpace));
    picture BW_d = getCircleNode("$BW_d$", (5colSpace, -rowSpace));
    picture BW_e = getCircleNode("$BW_e$", (6colSpace, -rowSpace));
    picture CPBW_End = getCircleNode("$CP^0_e$", (7colSpace, -rowSpace), cyan);
    picture BW_f = getCircleNode("$BW_f$", (8colSpace, -rowSpace));
    picture BW_g = getCircleNode("$BW_g$", (9colSpace, -rowSpace));

    add(pic, BW_a);
    add(pic, BW_b);
    add(pic, CPBW_Begin);
    add(pic, BW_c);
    add(pic, BW_d);
    add(pic, BW_e);
    add(pic, CPBW_End);
    add(pic, BW_f);
    add(pic, BW_g);

    // loss node
    pair FW_g_pt = point(FW_g, E);
    pair BW_g_pt = point(BW_g, E);
    pair loss_pos = shift(0.8colSpace,0)*midpoint(FW_g_pt--BW_g_pt);
    picture lossNode = getCircleNode("$Loss$", loss_pos, lightyellow);
    add(pic, lossNode);

    // middle nodes
    picture new_FW_c = getCircleNode("$FW_c$", 
                                shift(0, -0.5rowSpace)*point(FW_c, (0,0)), 
                                lightblue);
    picture new_FW_d = getCircleNode("$FW_d$", 
                                shift(0, -0.5rowSpace)*point(FW_d, (0,0)), 
                                lightblue);
    picture new_FW_e = getCircleNode("$FW_e$", 
                                shift(0, -0.5rowSpace)*point(FW_e, (0,0)), 
                                lightblue);
    add(pic, new_FW_c);
    add(pic, new_FW_d);
    add(pic, new_FW_e);

    // line about middle nodes
    path CPBegin2NewFWC = point(CP_Begin, E){down}..{right}point(new_FW_c, W);
    draw(pic, CPBegin2NewFWC, dashed, Arrow);

    path NewFWC2NewFWD = point(new_FW_c, E)..point(new_FW_d, W);
    draw(pic, NewFWC2NewFWD, dashed, Arrow);

    path NewFWD2NewFWE = point(new_FW_d, E)..point(new_FW_e, W);
    draw(pic, NewFWD2NewFWE, dashed, Arrow);

    path CPEnd2NewFWC = point(CPBW_End, N){up}\
        ..shift(0,0.6rowSpace)*point(CPBW_End, N){left}\
        ..shift(-0.5colSpace,0.6rowSpace)*point(CPBW_End, N)\
        ..shift(-colSpace,0.6rowSpace)*point(CPBW_End, N)\
        ..shift(-1.5colSpace,0.6rowSpace)*point(CPBW_End, N)\
        ..shift(-2colSpace,0.6rowSpace)*point(CPBW_End, N)\
        ..shift(-2.5colSpace,0.6rowSpace)*point(CPBW_End, N)\
        ..{SW}point(new_FW_c, N);
    label(pic, "Control Edge", midpoint(CPEnd2NewFWC), N, fontsize(10pt));
    draw(pic, CPEnd2NewFWC, longdashed, Arrow);

    path NewFWC2BWC = point(new_FW_c, S)..point(BW_c, N);
    draw(pic, NewFWC2BWC, Arrow);

    path NewFWD2BWD = point(new_FW_d, S)..point(BW_d, N);
    draw(pic, NewFWD2BWD, Arrow);

    path NewFWE2BWE = point(new_FW_e, S)..point(BW_e, N);
    draw(pic, NewFWE2BWE, Arrow);

    // arrow line up to down
    drawUp2Down(pic, FW_a, BW_a);
    drawUp2Down(pic, FW_b, BW_b);
    drawUp2Down(pic, FW_f, BW_f);
    drawUp2Down(pic, FW_g, BW_g);

    // arrow line forward
    drawLeft2Right(pic, FW_a, FW_b);
    drawLeft2Right(pic, FW_b, CP_Begin);
    drawLeft2Right(pic, CP_Begin, FW_c);
    drawLeft2Right(pic, FW_c, FW_d);
    drawLeft2Right(pic, FW_d, FW_e);
    drawLeft2Right(pic, FW_e, CP_End);
    drawLeft2Right(pic, CP_End, FW_f);
    drawLeft2Right(pic, FW_f, FW_g);

    // arrow line backword
    drawRight2Left(pic, BW_b, BW_a);
    drawRight2Left(pic, CPBW_Begin, BW_b);
    drawRight2Left(pic, BW_c, CPBW_Begin);
    drawRight2Left(pic, BW_d, BW_c);
    drawRight2Left(pic, BW_e, BW_d);
    drawRight2Left(pic, CPBW_End, BW_e);
    drawRight2Left(pic, BW_f, CPBW_End);
    drawRight2Left(pic, BW_g, BW_f);

    // arrow to loss
    path FG2Loss = point(FW_g, E){right}..{ESE}point(lossNode, W);
    draw(pic, FG2Loss, Arrow);
    path Loss2BG = point(lossNode, W){left}..{WSW}point(BW_g, E);
    draw(pic, Loss2BG, Arrow);

    return pic;    
}

picture originPic = getOriginPic();
picture optimizedPic = shift(0, -4)*getOptimizedPic();

add(originPic);
add(optimizedPic);

label("$Origin$", point(originPic, S), down);
label("$Optimized$", point(optimizedPic, S), down);

shipout(bbox(0.25cm));
write(size(originPic));
write(size(optimizedPic));

write(size(originPic, true));
write(size(optimizedPic, true));
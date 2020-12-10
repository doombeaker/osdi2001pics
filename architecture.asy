size(40cm, 0);
unitsize(30, 0);
defaultpen(fontsize(12pt));


picture blockBox(string s = "", real w = 1, real h = 1, pen p = white) {
  picture pic;
  pair d = (w, h);
  path rpath = roundedpath(box(-d/2,d/2), 0.1);
  filldraw(pic, rpath, p);
  label(pic, s);
  return pic;
}
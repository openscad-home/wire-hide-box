// a little foldable box to hide the cables between the two LED lamps on my desk
mm = 1;
cm = 10 * mm;
x = 11 * cm; // width
y = 4 * cm; // depth
z = 15 * mm; // height

w = 1 * mm; // material width

e = 1 * mm; // a little extra offset to ensure that cut-offs are not leaving a zero width material on the side

// the depth of the chamfer that makes the sides foldable
chamfer_depth = 0.9 * mm;

sideX = w;
sideY = y - 2 * chamfer_depth;
sideZ = z - 2 * chamfer_depth;

hole_pos = 15 * mm; // the position of the hole at the side
d = 10 * mm; // diameter of the hole on the side

topPlaneMargin = 10*mm;
backGapWidth = 2*mm;
backGapHeight = 10*mm;

colors = [ "red", "green", "blue", "yellow", "orange", "purple", "black", "white"   ];

module chamfer() {
    translate([- e, 0, w - chamfer_depth])
        rotate([45, 0, 0])
            cube([x + 2 * e, 2 * w, 2 * w]);
}
offset = [z, y, z, y];
// calculate the positions of the sides in the Y direction
pos = [ 0,
        offset[0],
        offset[0] + offset[1],
        offset[0] + offset[1] + offset[2],
        offset[0] + offset[1] + offset[2] + offset[3]
];

// the four sides of the box laying on the XY sheet
difference() {
    union() {
        for (i = [0:len(offset) - 1])
        color(colors[i])
            translate([0, pos[i], 0])
                cube([x, offset[i], w]);
    }
    // remove the chamfers
    union() {
        for (i = [0:len(pos) - 1]) {
            translate([0, pos[i], 0])
                chamfer();
        }
    }

    // remove the middle of the top, just to save some material
    translate([topPlaneMargin, pos[3] + topPlaneMargin, -e])
        cube([x-2*topPlaneMargin, y - 2 * topPlaneMargin, w + 2 * e]);

    for( i = [0:x/2/backGapWidth-2])
        translate([2*backGapWidth+i * 2 * backGapWidth, pos[2]+(z-backGapHeight)/2, -e])
            cube([backGapWidth, backGapHeight, w + 2 * e]);

}

// the two sides with the holes for the cables
difference(){
    union(){
        translate([0, pos[1] + chamfer_depth, w])
            cube([sideX, sideY, sideZ]);
        translate([x-w, pos[1] + chamfer_depth, w])
            cube([sideX, sideY, sideZ]);
    }
    // creating the two holes with a long cylinder
    translate([- e,  hole_pos + pos[1] + w,z/2])
        rotate([0, 90, 0])
            cylinder(d = d, h = x + 2 * e, $fn= 100);
}

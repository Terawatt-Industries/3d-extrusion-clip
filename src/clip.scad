use <tools/MCAD/metric_fasteners.scad>

// Part PARAMETERS
overall_thickness = 7;
extrusion_width = 20.1;
extrusion_height = 20.1;
wall_thickness = 4;
clip_width = 18;
clip_length = 10;
clip_length_offset = 3;
clip_flange_width = 15;	// FIXME: actually this is size of arrow cube, isn't rly usable as parametrized

// CALCULATIONS
clip_channel_height = clip_width - wall_thickness * 1.414;
extrusion_channel_offset = 2;		// affects thickness of solid wall

assembly(ot = overall_thickness, extw = extrusion_width, exth = extrusion_height, wt = wall_thickness, ceh = clip_width, cl = clip_length, clo = clip_length_offset, cft = clip_flange_width, cch = clip_channel_height);

module assembly(ot, extw, exth, wt, ceh, cl, clo, cft, cch) {
difference() {
union() {
// extrusion clip base
hull() {
minkowski() {
translate([1, 1, 0]) cube([extw + wt * 2 - 1, exth + wt * 2 - 2, ot - 0.01]);
cylinder(r=1, h=0.01, $fn=24);
}
minkowski() {
translate([extw + wt * 2 + 1, 6 / 2, 0]) cube([clo - 1, exth + wt * 2 - 6, ot - 0.01]);
cylinder(r=1, h=0.01, $fn=24);
}
}
// spring clip
translate([extw + clo + cl, (exth + 2 * wt) / 2, ot / 2]) cube(size = [cl - wt, ceh, ot], center = true);
difference() {
translate([extw + wt + clo + cl, ((exth + 2 * wt) - (sqrt(2) * (cft + wt))) / 2, 0]) rotate([0, 0, 45]) cube([cft + wt, cft + wt, ot]); 
translate([extw + clo + cl - cft, 0, -0.01]) cube([cft + wt * 0.7, exth + 2 * wt, ot + 0.02]);
// cutoff clip end
translate([extw + clo + cl + cft / 2, 0, -0.01]) cube([cft + wt * 0.7, exth + 2 * wt, ot + 0.02]);
}
}
// extrusion channel
translate([wt + extrusion_channel_offset, wt, -0.01]) cube([extw, exth, ot + 0.02]);
// angled cut in channel
translate([extw + wt + extrusion_channel_offset, (exth + 2 * wt) / 2, ot / 2]) rotate([0, 0, 45]) cube(size=[extw * 0.5, exth * 0.5, ot + 0.02], center=true);
// extrusion clip freedom
translate([wt + extw / 2 + extrusion_channel_offset, wt + exth / 2, 0]) {
for (a = [-45, 45, 225]) {
rotate([0, 0, a])
translate([-extw / 2 + 1.5, -exth / 2 + 1.5, -0.01]) cube([5, 5, ot + 0.02]);
}
}
// spring clip channel
translate([(extw + wt * 2) / 2, (exth + wt * 2) / 2 - (cch / 2), -0.01]) cube([exth + cl + clo + 5, cch, ot + 0.02]);
}
// screw nipple for 4-40 or M3 screw:
difference() {
union() {
translate([0, exth / 2 + wt, ot / 2]) rotate([0, -90, 0]) cylinder(r1 = 3.2, r2 = 2.5, h = ot / 1.414 - wt / 2 + 2.5, center = false, $fn = 24);
translate([0, exth / 4 + wt, 1.5]) minkowski() {
rotate([0, -45, 0]) cube([ot / 1.414 - 2, exth / 2, ot / 1.414 - 2]);
rotate([90, 0, 0]) cylinder(r = 1, h = 0.01, center = true, $fn = 24);
}
}
translate([-1, exth / 2 + wt, ot / 2]) rotate([0, -90, 0]) cylinder(r = 1.35, h = ot * 3, center = false, $fn = 24);
}
}
use <tools/MCAD/metric_fasteners.scad>

// Part PARAMETERS
overall_thickness = 10;
extrusion_width = 20;
extrusion_height = 20;
wall_thickness = 4;
clip_effective_height = 13;
clip_length = 13;
clip_length_offset = 5;
clip_flange_thickness = 13;	// FIXME: actually this is size of arrow cube, isn't rly usable as parametrized

// CALCULATIONS
clip_channel_height = clip_effective_height - wall_thickness * 2;

assembly(ot = overall_thickness, extw = extrusion_width, exth = extrusion_height, wt = wall_thickness, ceh = clip_effective_height, cl = clip_length, clo = clip_length_offset, cft = clip_flange_thickness, cch = clip_channel_height);

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
translate([extw + wt + clo, (exth + wt - ceh) / 2, 0]) cube([cl, ceh + wt, ot]);
// spring clip
difference() {
translate([extw + wt + clo + cl, ((exth + 2 * wt) - (sqrt(2) * (cft + wt))) / 2, 0]) rotate([0, 0, 45]) cube([cft + wt, cft + wt, ot]); 
translate([extw + clo + cl - cft, 0, -0.01]) cube([cft + wt * 0.7, exth + 2 * wt, ot + 0.02]);
// stub clip end
translate([extw + clo + cl + cft * 0.6, 0, -0.01]) cube([cft + wt * 0.7, exth + 2 * wt, ot + 0.02]);
}
}
// extrusion channel
translate([wt, wt, -0.01]) cube([extw, exth, ot + 0.02]);
// extrusion clip freedom
translate([wt + extw / 2, wt + exth / 2, 0]) {
for (a = [0, 90, 270]) {
rotate([0, 0, a])
translate([-extw / 2 + wt / 3, -wt, -0.01]) rotate([0, 0, 45]) cube([5, 5, ot + 0.02]);
}
}
// spring clip channel
translate([(extw + wt * 2) / 2, (exth + wt * 2) / 2 - (cch / 2), -0.01]) cube([exth + cl + clo + 5, cch, ot + 0.02]);
}
}
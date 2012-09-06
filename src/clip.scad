use <tools/MCAD/metric_fasteners.scad>

// Part PARAMETERS
overall_thickness = 10;
extrusion_width = 20;
extrusion_height = 20;
wall_thickness = 6;
clip_width = 13;
clip_length = 13;
clip_length_offset = 5;
clip_flange_width = 8;	// FIXME: actually this is size of arrow cube, isn't rly usable as parametrized

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
translate([extw + clo + cl, (exth + 2 * wt) / 2, ot / 2]) cube(size = [cl, ceh, ot], center = true);
difference() {
translate([extw + wt + clo + cl, ((exth + 2 * wt) - (sqrt(2) * (cft + wt))) / 2, 0]) rotate([0, 0, 45]) cube([cft + wt, cft + wt, ot]); 
translate([extw + clo + cl - cft, 0, -0.01]) cube([cft + wt * 0.7, exth + 2 * wt, ot + 0.02]);
// cutoff clip end
translate([extw + clo + cl + cft, 0, -0.01]) cube([cft + wt * 0.7, exth + 2 * wt, ot + 0.02]);
}
}
// extrusion channel
translate([wt + extrusion_channel_offset, wt, -0.01]) cube([extw, exth, ot + 0.02]);
// angled cut in channel
translate([extw + wt + extrusion_channel_offset, (exth + 2 * wt) / 2, ot / 2]) rotate([0, 0, 45]) cube(size=[extw * 0.5, exth * 0.5, ot + 0.02], center=true);
// extrusion clip freedom
for (y = [extw + wt + ( 6 * wt / 20), 6 * wt / 20]) {
translate([wt * 1.25 + extrusion_channel_offset, y, -0.01]) cube([exth * 0.2, wt * 0.4, ot + 0.02]);
translate([wt * 2.25 + extrusion_channel_offset, y, -0.01]) cube([exth * 0.2, wt * 0.4, ot + 0.02]);
translate([wt * 3.25 + extrusion_channel_offset, y, -0.01]) cube([exth * 0.2, wt * 0.4, ot + 0.02]);
translate([wt * 4.25 + extrusion_channel_offset, y, -0.01]) cube([exth * 0.15, wt * 0.3, ot + 0.02]);
}
// spring clip channel
translate([(extw + wt * 2) / 2, (exth + wt * 2) / 2 - (cch / 2), -0.01]) cube([exth + cl + clo + 5, cch, ot + 0.02]);
}

}
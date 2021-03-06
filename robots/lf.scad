use <../wheels/wheel_d.scad>;
use <../motors/HL149.scad>;
use <../wheels/encoder_wheel.scad>;

module lf(chassis_only = true) {
	// TODO: Prepare a place for encoders
	// TODO: Add PCB case
	// TODO: Figure out how to fix the motor on its back

	filament_color = "DarkOrange";
	wheels_distance = 150;
	motor_d = 27.8;
	wall_thickness = 3;
	width = motor_d + 2 * wall_thickness;
	front_thickness = 4.4;
	d_holes_place = 19.6;
	d_holes = 3;
	platform_height = 5;
	shaft_hole_d = 9.4;
	wheel_d = 50;
	encoders_cutout_width = 36;
	echo(bottom_clearance = (wheel_d / 2 - motor_d / 2 - platform_height));
	core_inner_width = 72;
	core_inner_length = 36;
	core_length = core_inner_length + wall_thickness;
	core_width = core_inner_width + 2 * wall_thickness;
	core_hole_depth = 2;
	step_width = 2;
	pole_d = 8;
	pole_screw_d = 3;
	pole_screw_head_d = 5.6;
	pole_screw_head_h = 1.5;
	poles_y = [-encoders_cutout_width / 2, 0, encoders_cutout_width / 2];
	poles_x = [width / 2 + core_inner_length / 2, 0, width / 2 + core_inner_length / 2];

	module lf_motor_handle(chassis_only = chassis_only) {
		wheel_on_shaft_distance = 7.5;
		encoder_wheel_dictance = wheels_distance / 2 - 11;
		translate([0, wheels_distance / 2, 0]) union() {
			color(filament_color) rotate([-90, 0, 0]) linear_extrude(front_thickness) difference() {
				circle(d = width, $fn = 100);
				circle(d = shaft_hole_d, $fn = 100);
				translate([d_holes_place / 2, 0, 0]) circle(d = d_holes, $fn = 100);
				translate([-d_holes_place / 2, 0, 0]) circle(d = d_holes, $fn = 100);
			}
			if(!chassis_only) {
				color("Silver") HL149();
				rotate([270, 0, 0]) {
					color(filament_color) translate([0, 0, wheel_on_shaft_distance]) wheel_d(wheel_d);
					color("DimGray") translate([0, 0, -encoder_wheel_dictance]) encoder_wheel();
				}
			}
		}
	}

	union() {
		color(filament_color) difference() {
			union() {
				translate([-width / 2, -wheels_distance / 2 - front_thickness, 0]) difference() {
					union() {
						difference() {
							cube([width, wheels_distance + 2 * front_thickness, platform_height + motor_d / 2]);
							translate([width / 2, 0, platform_height + motor_d / 2]) rotate([270, 0, 0])
								translate([0, 0, -1]) cylinder(d = motor_d, h = wheels_distance + 2 * (front_thickness + 1), $fn = 100);
							translate([wall_thickness, front_thickness + wheels_distance / 2 - encoders_cutout_width / 2, platform_height])
								cube([width, encoders_cutout_width, motor_d + 1]);
						}
						translate([width, front_thickness + wheels_distance / 2 - core_width / 2, 0]) cube([core_length, core_width, platform_height]);
					}
					translate([width + step_width, front_thickness + wheels_distance / 2 - core_inner_width / 2 + step_width, platform_height - core_hole_depth])
						cube([core_inner_length - 2 * step_width, core_inner_width - 2 * step_width, core_hole_depth + 1]);
					translate([wall_thickness + step_width, front_thickness + wheels_distance / 2 - encoders_cutout_width / 2 + step_width, platform_height - core_hole_depth])
						cube([width, encoders_cutout_width - 2 * step_width, core_hole_depth + 1]);
				}
				for(i = [0 : 2]) {
					translate([poles_x[i], poles_y[i], 0]) cylinder(d = pole_d, h = platform_height, $fn = 100);
				}
			}
			// holes for screws
			for(i = [0 : 2]) {
				translate([poles_x[i], poles_y[i], -1]) {
					cylinder(d = pole_screw_d, h = platform_height + 2, $fn = 100);
					cylinder(d = pole_screw_head_d, h = pole_screw_head_h + 1, $fn = 6);
				}
			}
		}
		translate([0, 0, motor_d / 2 + platform_height]) {
			lf_motor_handle();
			mirror([0, 1, 0]) lf_motor_handle();
		}
	}
}

lf(chassis_only = false);
translate([0, 0, -100]) lf();

